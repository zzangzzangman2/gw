@echo off
setlocal
cd /d "%~dp0"
python "%~dp0scripts\scan_decoded_lua_handlers.py"
pause


