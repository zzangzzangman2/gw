@echo off
setlocal
chcp 65001 >nul
set "BASE=%~dp0..\.."
powershell -NoProfile -ExecutionPolicy Bypass -File "%BASE%\_restore_tools\scripts\run_maininterface_121_route_skeletongraphic_clipping_texture_handoff.ps1"
exit /b %errorlevel%
