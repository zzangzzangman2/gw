@echo off
setlocal

set "UNITY_EXE=C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe"
set "PROJECT_DIR=C:\Users\godho\Downloads\girlswar\girlswar_battle_unity"
set "METHOD=GirlsWar.Battle90PlayModeLuaBootstrapEditor.OpenRosterExpansionManualPlay"

if not exist "%UNITY_EXE%" (
  echo Unity not found: %UNITY_EXE%
  pause
  exit /b 1
)

if not exist "%PROJECT_DIR%\Assets" (
  echo Project not found: %PROJECT_DIR%
  pause
  exit /b 1
)

start "" "%UNITY_EXE%" -projectPath "%PROJECT_DIR%" -executeMethod %METHOD%
