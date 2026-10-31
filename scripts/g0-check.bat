@echo off
rem FieldOps - Gate G0 check. Double-click to run; results go to ..\g0-check.log
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0g0-check.ps1"
echo.
echo Log written to %~dp0..\g0-check.log
pause
