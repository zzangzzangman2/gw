@echo off
setlocal
cd /d "%~dp0"

echo [GirlsWarRestore] Analyze Spine runtime compatibility
echo.

python "%~dp0scripts\analyze_spine_runtime_compatibility.py"
if errorlevel 1 (
  echo.
  echo [GirlsWarRestore] FAILED
  pause
  exit /b 1
)

echo.
echo [GirlsWarRestore] Done.
pause
