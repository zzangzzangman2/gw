@echo off
setlocal
cd /d "%~dp0"

powershell -NoProfile -ExecutionPolicy Bypass -File "%~dp0scripts\run_tmp_compile_probe.ps1"
set EXITCODE=%ERRORLEVEL%

echo.
echo TMP compile probe report:
echo %~dp0..\reports\maininterface\MAININTERFACE_TMP_COMPILE_PROBE_RESULT.md
echo.
pause
exit /b %EXITCODE%
