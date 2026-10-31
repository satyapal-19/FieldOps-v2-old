@echo off
rem FieldOps - one-time native PostgreSQL setup (creates the fieldops role and databases).
powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0setup-local-postgres.ps1"
echo.
pause
