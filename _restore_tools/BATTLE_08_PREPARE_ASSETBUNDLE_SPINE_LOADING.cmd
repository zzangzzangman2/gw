@echo off
setlocal
cd /d "%~dp0"
python "%~dp0scripts\prepare_assetbundle_spine_loading.py"
pause
