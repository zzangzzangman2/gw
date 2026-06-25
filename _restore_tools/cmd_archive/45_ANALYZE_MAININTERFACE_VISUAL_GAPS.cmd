@echo off
setlocal
cd /d "%~dp0"

python "%~dp0scripts\analyze_maininterface_visual_gaps.py"

echo.
echo Visual gap report:
echo %~dp0..\reports\maininterface\MAININTERFACE_VISUAL_GAP_ANALYSIS.md
echo.
pause
