@echo off
setlocal
cd /d "%~dp0"

python "%~dp0scripts\verify_source_disposal_readiness.py"

echo.
echo Source cleanup report:
echo %~dp0..\reports\source_cleanup\SOURCE_DISPOSAL_READINESS.md
echo.
pause
