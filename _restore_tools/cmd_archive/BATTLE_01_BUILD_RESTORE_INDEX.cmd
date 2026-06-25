@echo off
setlocal
cd /d "%~dp0"
python "%~dp0scripts\build_battle_restore_index.py"
pause
