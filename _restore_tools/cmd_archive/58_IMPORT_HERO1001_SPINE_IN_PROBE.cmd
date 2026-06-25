@echo off
setlocal
cd /d "%~dp0"

echo [GirlsWarRestore] Import Hero 1001 Spine assets inside isolated probe
echo [GirlsWarRestore] This does not modify the main Unity restore project.
echo.

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\run_spine40_hero1001_import.ps1"
set EXITCODE=%ERRORLEVEL%

echo.
echo [GirlsWarRestore] Hero 1001 probe import exit code: %EXITCODE%
echo [GirlsWarRestore] Run 59_ANALYZE_HERO1001_SPINE_PROBE_IMPORT.cmd next.
pause
exit /b %EXITCODE%
