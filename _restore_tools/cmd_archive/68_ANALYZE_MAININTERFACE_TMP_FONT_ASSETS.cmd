@echo off
setlocal
cd /d "%~dp0"

python "%~dp0scripts\analyze_maininterface_tmp_font_assets.py"
set EXITCODE=%ERRORLEVEL%

echo.
echo TMP font asset inventory:
echo %~dp0..\reports\maininterface\MAININTERFACE_TMP_FONT_ASSET_INVENTORY.md
echo.
pause
exit /b %EXITCODE%
