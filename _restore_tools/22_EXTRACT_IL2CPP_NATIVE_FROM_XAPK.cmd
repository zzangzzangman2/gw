@echo off
setlocal

python "%~dp0scripts\extract_il2cpp_native_from_xapk.py"

echo.
echo Native output:
echo %~dp0..\il2cpp_native
echo.
pause


