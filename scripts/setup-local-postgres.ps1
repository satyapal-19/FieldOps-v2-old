# FieldOps - one-time setup of a native PostgreSQL install (no Docker needed).
# Creates the 'fieldops' login role and the fieldops_dev + fieldops_test databases, using the
# DB_USERNAME / DB_PASSWORD from backend\.env.development. psql asks for YOUR postgres
# superuser password; it is typed by you and never stored.

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent $PSScriptRoot
$envFile = Join-Path $root 'backend\.env.development'
if (-not (Test-Path $envFile)) {
    Copy-Item (Join-Path $root 'backend\env-templates\development.example') $envFile
}

$vars = @{}
foreach ($line in Get-Content $envFile) {
    if ($line -match '^\s*([A-Z0-9_]+)\s*=\s*(.*)$') { $vars[$Matches[1]] = $Matches[2].Trim() }
}
$user = $vars['DB_USERNAME']; $password = $vars['DB_PASSWORD']
$port = if ($vars['DB_PORT']) { $vars['DB_PORT'] } else { '5432' }
if ($user -notmatch '^[a-z_][a-z0-9_]*$') { throw "DB_USERNAME '$user' must be lower-case letters, digits or _" }
$pwSql = $password.Replace("'", "''")

$psql = Get-ChildItem 'C:\Program Files\PostgreSQL\*\bin\psql.exe' -ErrorAction SilentlyContinue |
    Sort-Object FullName -Descending | Select-Object -First 1
if (-not $psql) { throw 'psql.exe not found under C:\Program Files\PostgreSQL. Install PostgreSQL 16+ first.' }
Write-Host "Using $($psql.FullName) on port $port"

$sql = @"
SELECT 'CREATE ROLE $user LOGIN PASSWORD ''$pwSql'''
WHERE NOT EXISTS (SELECT 1 FROM pg_roles WHERE rolname = '$user')\gexec
ALTER ROLE $user WITH LOGIN PASSWORD '$pwSql';
SELECT 'CREATE DATABASE fieldops_dev OWNER $user'
WHERE NOT EXISTS (SELECT 1 FROM pg_database WHERE datname = 'fieldops_dev')\gexec
SELECT 'CREATE DATABASE fieldops_test OWNER $user'
WHERE NOT EXISTS (SELECT 1 FROM pg_database WHERE datname = 'fieldops_test')\gexec
SELECT datname, pg_get_userbyid(datdba) AS owner FROM pg_database WHERE datname LIKE 'fieldops_%';
"@
$sqlFile = Join-Path $env:TEMP 'fieldops-setup.sql'
Set-Content -Path $sqlFile -Value $sql -Encoding ASCII

Write-Host ''
Write-Host 'Enter the password of the PostgreSQL "postgres" superuser when asked.'
& $psql.FullName -h localhost -p $port -U postgres -d postgres -v ON_ERROR_STOP=1 -f $sqlFile
$code = $LASTEXITCODE
Remove-Item $sqlFile -ErrorAction SilentlyContinue
if ($code -eq 0) { Write-Host "`nDone: role '$user' and databases fieldops_dev, fieldops_test are ready." }
else { Write-Host "`nSetup failed (exit $code). Check the postgres password and that the PostgreSQL service is running." }
