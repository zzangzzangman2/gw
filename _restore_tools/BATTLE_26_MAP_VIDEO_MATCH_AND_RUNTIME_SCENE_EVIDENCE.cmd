@echo off
setlocal
chcp 65001 >nul
set "BASE=C:\Users\godho\Downloads\girlswar"
python "%BASE%\_restore_tools\scripts\probe_battle26_map_video_match_and_runtime_scene_evidence.py"
exit /b %errorlevel%
