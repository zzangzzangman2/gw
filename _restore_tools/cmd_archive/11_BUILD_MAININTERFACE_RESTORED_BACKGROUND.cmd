@echo off
setlocal

powershell -NoProfile -ExecutionPolicy Bypass -File "C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\tools\run_build_maininterface_scene.ps1"

echo.
echo Background restored-scene build started. Check:
echo C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\logs\unity_maininterface_build.log
echo.
echo After it finishes, run 04_VERIFY_MAININTERFACE_OUTPUTS.cmd

pause


