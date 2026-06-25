@echo off
setlocal

python "%~dp0scripts\analyze_maininterface_button_handlers.py"

echo.
echo Report:
echo %~dp0..\reports\maininterface\MAININTERFACE_BUTTON_HANDLER_CANDIDATES.md
echo.
pause


