@echo off
setlocal
cd /d "%~dp0"

python "%~dp0scripts\export_maininterface_tmp_text_details.py"
set EXITCODE=%ERRORLEVEL%

echo.
echo TMP text details report:
echo %~dp0..\reports\maininterface\MAININTERFACE_TMP_TEXT_DETAILS.md
echo.
pause
exit /b %EXITCODE%
