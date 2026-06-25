@echo off
setlocal
cd /d "%~dp0"
if not exist "_restore_tools\logs" mkdir "_restore_tools\logs"
powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath 'cmd.exe' -ArgumentList '/c','\"%CD%\PUSH_LATEST_TO_GITHUB_MAIN_AFTER_CURRENT.cmd\"' -WorkingDirectory '%CD%' -WindowStyle Hidden"
echo Followup background push watcher started.
echo It waits for the current git-lfs upload, then commits and pushes latest changes.
echo Check _restore_tools\logs\github_push_followup_main.log or run SHOW_GIT_PUSH_STATUS.cmd.
