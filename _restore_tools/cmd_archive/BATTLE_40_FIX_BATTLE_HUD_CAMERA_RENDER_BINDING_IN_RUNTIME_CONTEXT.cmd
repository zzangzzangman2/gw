@echo off
setlocal
chcp 65001 >nul
set "BASE=C:\Users\godho\Downloads\girlswar"
set "UNITY=C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe"
set "PROJECT=%BASE%\girlswar_battle_unity"
set "LOG=%BASE%\reports\battle\BATTLE_40_FIX_BATTLE_HUD_CAMERA_RENDER_BINDING_IN_RUNTIME_CONTEXT.log"

if not exist "%UNITY%" (
  echo Unity not found: %UNITY%
  exit /b 1
)

"%UNITY%" -batchmode -quit -projectPath "%PROJECT%" -executeMethod Battle40FixBattleHudCameraRenderBindingInRuntimeContextEditor.Build -logFile "%LOG%"
set "UNITY_EXIT=%errorlevel%"

python "%BASE%\_restore_tools\scripts\battle40_fix_battle_hud_camera_render_binding_in_runtime_context.py" verify --unity-exit %UNITY_EXIT%
exit /b %UNITY_EXIT%
