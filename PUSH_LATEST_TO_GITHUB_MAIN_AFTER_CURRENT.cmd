@echo off
setlocal EnableExtensions
cd /d "%~dp0"
if not exist "_restore_tools\logs" mkdir "_restore_tools\logs"
set LOG=_restore_tools\logs\github_push_followup_main.log
echo [%DATE% %TIME%] followup push wait start > "%LOG%"

:wait_git
tasklist /FI "IMAGENAME eq git-lfs.exe" 2>nul | find /I "git-lfs.exe" >nul
if not errorlevel 1 (
  echo [%DATE% %TIME%] waiting for existing git-lfs.exe >> "%LOG%"
  timeout /t 30 /nobreak >nul
  goto wait_git
)
tasklist /FI "IMAGENAME eq git-remote-https.exe" 2>nul | find /I "git-remote-https.exe" >nul
if not errorlevel 1 (
  echo [%DATE% %TIME%] waiting for existing git-remote-https.exe >> "%LOG%"
  timeout /t 30 /nobreak >nul
  goto wait_git
)

echo [%DATE% %TIME%] followup push start >> "%LOG%"
git lfs install >> "%LOG%" 2>&1
git status --short --branch >> "%LOG%" 2>&1
git add -A >> "%LOG%" 2>&1
git diff --cached --quiet
if not errorlevel 1 (
  echo [%DATE% %TIME%] no staged changes to commit >> "%LOG%"
) else (
  git commit -m "Update girlswar restore workspace" >> "%LOG%" 2>&1
)
git push -u origin main >> "%LOG%" 2>&1
set EXITCODE=%ERRORLEVEL%
echo [%DATE% %TIME%] followup push exit %EXITCODE% >> "%LOG%"
type "%LOG%"
exit /b %EXITCODE%
