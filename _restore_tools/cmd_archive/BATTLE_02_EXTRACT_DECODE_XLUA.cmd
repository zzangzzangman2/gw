@echo off
setlocal
cd /d "%~dp0"
python "%~dp0scripts\battle_extract_decode_xlua.py"
pause
