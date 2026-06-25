@echo off
setlocal

python "%~dp0scripts\analyze_maininterface_xlua_bindings.py"

echo.
echo Report:
echo %~dp0..\reports\maininterface\MAININTERFACE_XLUA_LOADER_ANALYSIS.md
echo.
pause


