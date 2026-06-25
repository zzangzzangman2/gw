@echo off
setlocal
cd /d "%~dp0"
python "%~dp0scripts\scan_decoded_lua_handlers.py"
if errorlevel 1 goto done
python "%~dp0scripts\join_buttons_with_lua_handlers.py"
:done
pause


