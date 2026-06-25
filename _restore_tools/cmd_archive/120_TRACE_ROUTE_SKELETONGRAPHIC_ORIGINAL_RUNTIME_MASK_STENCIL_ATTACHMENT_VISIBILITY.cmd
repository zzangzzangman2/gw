@echo off
setlocal
chcp 65001 >nul
set "BASE=%~dp0..\.."
powershell -NoProfile -ExecutionPolicy Bypass -File "%BASE%\_restore_tools\scripts\run_maininterface_120_route_skeletongraphic_runtime_mask_stencil_visibility.ps1"
exit /b %errorlevel%
