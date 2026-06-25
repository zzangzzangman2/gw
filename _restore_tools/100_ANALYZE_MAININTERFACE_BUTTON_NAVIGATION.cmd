@echo off
setlocal
cd /d "%~dp0.."
python "_restore_tools\scripts\analyze_maininterface_button_navigation.py"
endlocal
