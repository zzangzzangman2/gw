@echo off
setlocal
cd /d "%~dp0"
python "%~dp0scripts\verify_hero_card_runtime_layout_and_actor_animation_trace.py"
pause
