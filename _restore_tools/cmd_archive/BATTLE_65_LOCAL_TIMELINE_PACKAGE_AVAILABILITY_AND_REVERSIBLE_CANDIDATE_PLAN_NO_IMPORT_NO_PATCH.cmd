@echo off
setlocal
chcp 65001 >nul
set "BASE=C:\Users\godho\Downloads\girlswar"
python "%BASE%\_restore_tools\scripts\battle65_local_timeline_package_availability_plan.py"
exit /b %errorlevel%
