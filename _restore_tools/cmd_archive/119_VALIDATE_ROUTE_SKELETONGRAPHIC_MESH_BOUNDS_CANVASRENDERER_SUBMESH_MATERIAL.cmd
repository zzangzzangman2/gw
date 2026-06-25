@echo off
setlocal
chcp 65001 >nul
set "BASE=%~dp0..\.."
powershell -NoProfile -ExecutionPolicy Bypass -File "%BASE%\_restore_tools\scripts\run_maininterface_119_route_skeletongraphic_mesh_bounds.ps1"
exit /b %errorlevel%
