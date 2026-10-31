# FieldOps - Gate G0 check (Windows PowerShell 5+).
# Runs every Phase 0 verification step and writes a full log to <repo>\g0-check.log.
# Start it with scripts\g0-check.bat (double-click) or:
#   powershell -ExecutionPolicy Bypass -File scripts\g0-check.ps1

$ErrorActionPreference = 'Continue'
$root = Split-Path -Parent $PSScriptRoot
$backend = Join-Path $root 'backend'
$log = Join-Path $root 'g0-check.log'
Start-Transcript -Path $log -Force | Out-Null
$results = [ordered]@{}

function Run-Step([string]$name, [scriptblock]$block) {
    Write-Host ""
    Write-Host "=== $name ==="
    $global:LASTEXITCODE = 0
    $ok = $true
    try {
        & $block 2>&1 | Tee-Object -Variable out | Out-Host
        $last = @($out)[-1]
        if ($last -is [bool]) { $ok = $last }
        if ($global:LASTEXITCODE -ne 0) { $ok = $false }
    } catch {
        Write-Host "ERROR: $_"
        $ok = $false
    }
    $results[$name] = if ($ok) { 'PASS' } else { 'FAIL' }
    Write-Host "--> $name : $($results[$name])"
    return $ok
}

function Read-EnvFile([string]$path) {
    $vars = @{}
    if (Test-Path $path) {
        foreach ($line in Get-Content $path) {
            if ($line -match '^\s*([A-Z0-9_]+)\s*=\s*(.*)$') { $vars[$Matches[1]] = $Matches[2].Trim() }
        }
    }
    return $vars
}

function Start-Api([string]$label, [hashtable]$vars) {
    $saved = @{}
    foreach ($k in $vars.Keys) { $saved[$k] = [Environment]::GetEnvironmentVariable($k); [Environment]::SetEnvironmentVariable($k, $vars[$k]) }
    $p = Start-Process -FilePath 'node' -ArgumentList 'dist/main' -WorkingDirectory $backend -PassThru -NoNewWindow `
        -RedirectStandardOutput (Join-Path $root "g0-$label.out.log") -RedirectStandardError (Join-Path $root "g0-$label.err.log")
    foreach ($k in $vars.Keys) { [Environment]::SetEnvironmentVariable($k, $saved[$k]) }
    return $p
}

function Check-Api([string]$label, [hashtable]$vars, [int]$port) {
    $p = Start-Api $label $vars
    $healthy = $false
    for ($i = 0; $i -lt 40 -and -not $healthy; $i++) {
        Start-Sleep -Seconds 1
        if ($p.HasExited) { break }
        try {
            $h = Invoke-RestMethod -Uri "http://localhost:$port/api/v1/health" -TimeoutSec 2
            $r = Invoke-RestMethod -Uri "http://localhost:$port/api/v1/ready" -TimeoutSec 5
            Write-Host "health: $($h | ConvertTo-Json -Compress)"
            Write-Host "ready:  $($r | ConvertTo-Json -Compress)"
            $healthy = ($h.status -eq 'ok' -and $r.status -eq 'ready')
        } catch { }
    }
    if (-not $p.HasExited) { Stop-Process -Id $p.Id -Force -ErrorAction SilentlyContinue }
    if (-not $healthy) {
        Write-Host "API ($label) did not become healthy. Last output:"
        Get-Content (Join-Path $root "g0-$label.out.log") -Tail 30 -ErrorAction SilentlyContinue
        Get-Content (Join-Path $root "g0-$label.err.log") -Tail 30 -ErrorAction SilentlyContinue
    }
    return $healthy
}

Write-Host "FieldOps Gate G0 check - $(Get-Date -Format s)"
Write-Host "Repo: $root"

Run-Step 'Tools: node, npm' {
    node -v; npm.cmd -v
    if (Get-Command docker -ErrorAction SilentlyContinue) { docker --version } else { Write-Host 'docker: not installed (native PostgreSQL will be used)' }
} | Out-Null

Run-Step 'Local settings files' {
    if (-not (Test-Path "$root\.env")) { Copy-Item "$root\.env.example" "$root\.env"; Write-Host 'created .env' }
    if (-not (Test-Path "$backend\.env.development")) { Copy-Item "$backend\env-templates\development.example" "$backend\.env.development"; Write-Host 'created backend\.env.development' }
    if (-not (Test-Path "$backend\.env.test")) { Copy-Item "$backend\env-templates\test.example" "$backend\.env.test"; Write-Host 'created backend\.env.test' }
    $true
} | Out-Null

Run-Step 'PostgreSQL reachable (Docker or native install)' {
    if (Get-Command docker -ErrorAction SilentlyContinue) {
        Push-Location $root
        docker compose up -d postgres
        Pop-Location
        $status = ''
        for ($i = 0; $i -lt 60 -and $status -ne 'healthy'; $i++) {
            Start-Sleep -Seconds 2
            $status = (docker inspect -f '{{.State.Health.Status}}' fieldops-postgres 2>$null)
        }
        Write-Host "docker postgres: $status"
        $global:LASTEXITCODE = 0
        $status -eq 'healthy'
    } else {
        $dev = Read-EnvFile "$backend\.env.development"
        $port = if ($dev['DB_PORT']) { [int]$dev['DB_PORT'] } else { 5432 }
        $open = Test-NetConnection -ComputerName 'localhost' -Port $port -InformationLevel Quiet -WarningAction SilentlyContinue
        Write-Host "Docker not installed; native PostgreSQL on port ${port}: $(if ($open) { 'listening' } else { 'NOT listening' })"
        Write-Host 'If migrations fail with an authentication error, run scripts\setup-local-postgres.bat once.'
        $open
    }
} | Out-Null

Push-Location $backend
Run-Step 'npm install' { npm.cmd install --no-audit --no-fund } | Out-Null
Run-Step 'Lint' { npm.cmd run lint } | Out-Null
Run-Step 'Unit tests' { npm.cmd test -- --ci } | Out-Null
Run-Step 'Build' { npm.cmd run build } | Out-Null
Run-Step 'Migrations (test database)' { npm.cmd run db:migrate:test } | Out-Null
Run-Step 'End-to-end tests' { npm.cmd run test:e2e -- --ci } | Out-Null
Run-Step 'Migrations (dev database)' { npm.cmd run db:migrate:dev } | Out-Null

# Port 3000 is often taken by another local app (e.g. a React/Next dev server); check on 3300.
$busy = Get-NetTCPConnection -LocalPort 3000 -State Listen -ErrorAction SilentlyContinue | Select-Object -First 1
if ($busy) {
    $owner = (Get-Process -Id $busy.OwningProcess -ErrorAction SilentlyContinue).ProcessName
    Write-Host "Note: port 3000 is used by another program ($owner, PID $($busy.OwningProcess)); the dev check uses port 3300."
}
Run-Step 'API starts: development' { Check-Api 'dev' @{ NODE_ENV = 'development'; PORT = '3300' } 3300 } | Out-Null
Run-Step 'API starts: test' { Check-Api 'test' @{ NODE_ENV = 'test'; PORT = '3100' } 3100 } | Out-Null

# Production with real-looking settings (database from the dev file, strong throwaway secrets).
$dev = Read-EnvFile "$backend\.env.development"
$prod = @{
    NODE_ENV = 'production'; PORT = '3200'; CORS_ORIGINS = 'http://localhost:3001'
    DB_TYPE = 'postgres'; DB_HOST = $dev['DB_HOST']; DB_PORT = $dev['DB_PORT']
    DB_USERNAME = $dev['DB_USERNAME']; DB_PASSWORD = $dev['DB_PASSWORD']; DB_NAME = $dev['DB_NAME']
    JWT_ACCESS_SECRET = 'g0-check-access-secret-0123456789abcdef'
    JWT_REFRESH_SECRET = 'g0-check-refresh-secret-0123456789abcdef'
    AUTH_TEST_LOGIN_ENABLED = 'false'
}
Run-Step 'API starts: production' { Check-Api 'prod' $prod 3200 } | Out-Null

Run-Step 'Production refuses test login' {
    $bad = $prod.Clone(); $bad['AUTH_TEST_LOGIN_ENABLED'] = 'true'; $bad['PORT'] = '3201'
    $p = Start-Api 'prod-refuse' $bad
    $exited = $p.WaitForExit(30000)
    if (-not $exited) { Stop-Process -Id $p.Id -Force; Write-Host 'still running - should have refused'; return $false }
    $err = Get-Content (Join-Path $root 'g0-prod-refuse.err.log') -Raw -ErrorAction SilentlyContinue
    Write-Host $err
    $global:LASTEXITCODE = 0
    ($p.ExitCode -ne 0) -and ($err -match 'AUTH_TEST_LOGIN_ENABLED must be false in production')
} | Out-Null
Pop-Location

Write-Host ""
Write-Host "================ GATE G0 SUMMARY ================"
foreach ($k in $results.Keys) { Write-Host ("{0,-40} {1}" -f $k, $results[$k]) }
$failed = @($results.Values | Where-Object { $_ -ne 'PASS' }).Count
if ($failed -eq 0) { Write-Host 'GATE G0: PASSED' } else { Write-Host "GATE G0: $failed step(s) failed - see details above" }
Stop-Transcript | Out-Null
