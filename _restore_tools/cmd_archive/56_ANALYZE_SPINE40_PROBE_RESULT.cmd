@echo off
setlocal
cd /d "%~dp0"

echo [GirlsWarRestore] Analyze Spine 4.0 probe result
echo.

python "%~dp0scripts\analyze_spine40_probe_result.py"
if errorlevel 1 (
  echo.
  echo [GirlsWarRestore] FAILED
  pause
  exit /b 1
)

echo.
echo [GirlsWarRestore] Done.
pause
