@echo off
setlocal
cd /d "%~dp0..\.."
python _restore_tools\scripts\battle66_aspect_correct_viewrect_layout_validation.py
