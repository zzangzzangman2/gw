@echo off
setlocal
cd /d "%~dp0.."
python "_restore_tools\scripts\analyze_play_reference_video_motion.py"
endlocal
