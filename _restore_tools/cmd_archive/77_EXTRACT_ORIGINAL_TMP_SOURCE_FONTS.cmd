@echo off
setlocal
cd /d "%~dp0"

python "%~dp0scripts\extract_original_tmp_source_fonts.py"
set EXITCODE=%ERRORLEVEL%

echo.
echo Original TMP source font report:
echo %~dp0..\reports\maininterface\MAININTERFACE_ORIGINAL_TMP_SOURCE_FONTS.md
echo.
pause
exit /b %EXITCODE%
