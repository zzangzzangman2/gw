@echo off
setlocal
cd /d "%~dp0"

echo [GirlsWarRestore] Analyze Hero 1001 Spine probe import
echo.

python "%~dp0scripts\analyze_spine40_hero1001_import_result.py"
if errorlevel 1 (
  echo.
  echo [GirlsWarRestore] FAILED
  pause
  exit /b 1
)

echo.
echo [GirlsWarRestore] Done.
pause
