@echo off
setlocal
cd /d "%~dp0.."
python "_restore_tools\scripts\analyze_maininterface_route_renderers.py"
endlocal
