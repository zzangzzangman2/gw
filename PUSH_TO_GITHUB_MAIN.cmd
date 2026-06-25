@echo off
setlocal
cd /d "%~dp0"
if not exist "_restore_tools\logs" mkdir "_restore_tools\logs"
set LOG=_restore_tools\logs\github_push_main.log
echo [%DATE% %TIME%] push start > "%LOG%"
git lfs install >> "%LOG%" 2>&1
git status --short --branch >> "%LOG%" 2>&1
git push -u origin main >> "%LOG%" 2>&1
set EXITCODE=%ERRORLEVEL%
echo [%DATE% %TIME%] push exit %EXITCODE% >> "%LOG%"
type "%LOG%"
exit /b %EXITCODE%
