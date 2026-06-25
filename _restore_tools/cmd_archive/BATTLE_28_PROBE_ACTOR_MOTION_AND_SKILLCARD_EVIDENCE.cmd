@echo off
setlocal
chcp 65001 >nul
set "BASE=C:\Users\godho\Downloads\girlswar"

python "%BASE%\_restore_tools\scripts\probe_battle28_actor_motion_skillcard_evidence.py"
exit /b %errorlevel%
