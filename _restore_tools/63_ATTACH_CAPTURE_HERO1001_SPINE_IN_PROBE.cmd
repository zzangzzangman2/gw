@echo off
setlocal
cd /d "%~dp0"

echo [GirlsWarRestore] Attach and capture Hero 1001 Spine inside isolated probe
echo [GirlsWarRestore] This does not modify the main Unity restore project.
echo.

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\run_spine40_hero1001_attach_capture.ps1"
set EXITCODE=%ERRORLEVEL%

echo.
echo [GirlsWarRestore] Hero 1001 probe attach/capture exit code: %EXITCODE%
echo [GirlsWarRestore] Open the result with 64_OPEN_HERO1001_SPINE_PROBE_CAPTURE_REPORT.cmd
echo [GirlsWarRestore] Open the capture images with 65_OPEN_HERO1001_SPINE_PROBE_CAPTURE_IMAGES.cmd
pause
exit /b %EXITCODE%
