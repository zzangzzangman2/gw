@echo off
setlocal
cd /d "%~dp0"
python "%~dp0scripts\build_battle_prototype_manifest.py"
pause
