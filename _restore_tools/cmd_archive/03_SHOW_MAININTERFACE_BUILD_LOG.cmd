@echo off
setlocal
set LOG=C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\logs\unity_maininterface_build.log
if not exist "%LOG%" (
  echo Log not found: %LOG%
  pause
  exit /b 1
)
powershell -NoProfile -ExecutionPolicy Bypass -Command "Get-Content -LiteralPath '%LOG%' -Tail 160"
pause


