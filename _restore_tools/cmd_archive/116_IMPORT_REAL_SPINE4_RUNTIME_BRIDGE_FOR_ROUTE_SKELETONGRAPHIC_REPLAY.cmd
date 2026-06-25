@echo off
setlocal
chcp 65001 >nul
set "BASE=%~dp0..\.."
powershell -NoProfile -ExecutionPolicy Bypass -File "%BASE%\_restore_tools\scripts\run_maininterface_116_import_real_spine4_runtime_bridge.ps1"
exit /b %errorlevel%
