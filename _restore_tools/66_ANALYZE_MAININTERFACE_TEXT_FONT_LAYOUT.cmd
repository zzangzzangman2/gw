@echo off
setlocal
cd /d "%~dp0"

python "%~dp0scripts\analyze_maininterface_text_font_layout.py"
set EXITCODE=%ERRORLEVEL%

echo.
echo Text/font/layout report:
echo %~dp0..\reports\maininterface\MAININTERFACE_TEXT_FONT_LAYOUT_ANALYSIS.md
echo.
pause
exit /b %EXITCODE%
