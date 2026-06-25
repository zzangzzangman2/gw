@echo off
setlocal
cd /d "%~dp0"

echo [GirlsWarRestore] Analyze MainInterface Hero 1001 Spine source
echo.

python "%~dp0scripts\analyze_maininterface_hero_spine_1001.py"
if errorlevel 1 (
  echo.
  echo [GirlsWarRestore] FAILED
  pause
  exit /b 1
)

echo.
echo [GirlsWarRestore] Done.
pause
