@echo off
setlocal
cd /d "%~dp0\.."
call "PUSH_LATEST_TO_GITHUB_MAIN_AFTER_CURRENT.cmd"
