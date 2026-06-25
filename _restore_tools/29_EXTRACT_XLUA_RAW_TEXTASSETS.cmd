@echo off
setlocal
cd /d "%~dp0"
python "%~dp0scripts\extract_maininterface_xlua_raw_textassets.py"
pause


