@echo off
setlocal
cd /d "%~dp0"

python "%~dp0scripts\import_tmp_essential_resources.py"
set EXITCODE=%ERRORLEVEL%

echo.
echo TMP Essential Resources import report:
echo %~dp0..\reports\maininterface\MAININTERFACE_TMP_ESSENTIAL_RESOURCES_IMPORT.md
echo.
pause
exit /b %EXITCODE%
