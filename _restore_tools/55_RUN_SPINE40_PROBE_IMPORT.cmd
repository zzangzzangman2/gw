@echo off
setlocal
cd /d "%~dp0"

echo [GirlsWarRestore] Run isolated Spine 4.0 Unity 6000 probe import
echo [GirlsWarRestore] This does not modify the main Unity restore project.
echo.

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\run_spine40_probe_import.ps1"
set EXITCODE=%ERRORLEVEL%

echo.
echo [GirlsWarRestore] Probe import exit code: %EXITCODE%
echo [GirlsWarRestore] Run 56_ANALYZE_SPINE40_PROBE_RESULT.cmd next.
pause
exit /b %EXITCODE%
