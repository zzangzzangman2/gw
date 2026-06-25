@echo off
setlocal
set "BASE=%~dp0..\.."
powershell -NoProfile -ExecutionPolicy Bypass -File "%BASE%\_restore_tools\scripts\run_maininterface_115_route_skeletongraphic_replay_integration.ps1"
endlocal
