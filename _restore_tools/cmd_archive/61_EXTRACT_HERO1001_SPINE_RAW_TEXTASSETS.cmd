@echo off
setlocal
cd /d "%~dp0"

echo [GirlsWarRestore] Extract Hero 1001 raw Spine TextAssets
echo.

python "%~dp0scripts\extract_hero1001_spine_raw_textassets.py"
if errorlevel 1 (
  echo.
  echo [GirlsWarRestore] FAILED
  pause
  exit /b 1
)

echo.
echo [GirlsWarRestore] Done.
pause
