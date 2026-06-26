@echo off
setlocal
chcp 65001 >nul
set "BASE=%~dp0..\.."
python "%BASE%\_restore_tools\scripts\maininterface122_home_reference_route_runtime_state_trace.py"
exit /b %errorlevel%
