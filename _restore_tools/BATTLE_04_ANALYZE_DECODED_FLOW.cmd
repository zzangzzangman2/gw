@echo off
setlocal
cd /d "%~dp0"
python "%~dp0scripts\analyze_battle_decoded_flow.py"
pause
