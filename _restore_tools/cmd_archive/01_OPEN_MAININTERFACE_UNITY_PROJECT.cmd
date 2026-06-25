@echo off
setlocal
if not exist "C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe" (
  echo Unity.exe not found:
  echo C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe
  pause
  exit /b 1
)
start "" "C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe" -projectPath "C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity"


