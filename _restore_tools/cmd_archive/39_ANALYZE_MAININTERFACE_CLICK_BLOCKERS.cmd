@echo off
setlocal
cd /d "%~dp0"
python "%~dp0scripts\analyze_maininterface_click_blockers.py"
pause


