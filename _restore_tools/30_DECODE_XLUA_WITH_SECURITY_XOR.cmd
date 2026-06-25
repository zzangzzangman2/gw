@echo off
setlocal
cd /d "%~dp0"
python "%~dp0scripts\extract_maininterface_xlua_raw_textassets.py"
if errorlevel 1 goto done
python "%~dp0scripts\try_maininterface_xlua_decode.py"
:done
pause


