@echo off
setlocal

powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\tools\run_capture_maininterface_scene.ps1"

echo.
echo Background capture started. Check:
echo C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\logs\unity_maininterface_capture.log
echo.
echo After it finishes, run 15_VERIFY_MAININTERFACE_CAPTURE.cmd

pause


