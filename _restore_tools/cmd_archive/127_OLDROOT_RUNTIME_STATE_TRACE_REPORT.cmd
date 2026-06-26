@echo off
setlocal
cd /d "%~dp0..\.."
python _restore_tools\scripts\maininterface127_oldroot_runtime_state_trace.py
endlocal
