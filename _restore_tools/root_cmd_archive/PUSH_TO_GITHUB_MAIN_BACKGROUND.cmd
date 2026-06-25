@echo off
setlocal
cd /d "%~dp0"
if not exist "_restore_tools\logs" mkdir "_restore_tools\logs"
powershell -NoProfile -ExecutionPolicy Bypass -Command "Start-Process -FilePath 'cmd.exe' -ArgumentList '/c','\"%CD%\PUSH_TO_GITHUB_MAIN.cmd\"' -WorkingDirectory '%CD%' -WindowStyle Hidden"
echo Background push started.
echo Check _restore_tools\logs\github_push_main.log or run SHOW_GIT_PUSH_STATUS.cmd.
