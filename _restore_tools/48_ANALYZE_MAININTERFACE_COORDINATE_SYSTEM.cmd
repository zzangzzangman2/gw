@echo off
setlocal
cd /d "%~dp0"
python "%~dp0scripts\analyze_maininterface_coordinate_system.py"
pause
