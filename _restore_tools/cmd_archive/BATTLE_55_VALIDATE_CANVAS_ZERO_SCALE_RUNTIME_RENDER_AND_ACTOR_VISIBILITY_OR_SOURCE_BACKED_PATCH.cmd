@echo off
setlocal
chcp 65001 >nul
set "BASE=C:\Users\godho\Downloads\girlswar"
set "UNITY=C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe"
set "PROJECT=%BASE%\girlswar_battle_unity"
set "LOG=%BASE%\reports\battle\BATTLE_55_VALIDATE_CANVAS_ZERO_SCALE_RUNTIME_RENDER_AND_ACTOR_VISIBILITY_OR_SOURCE_BACKED_PATCH_UNITY.log"

if not exist "%UNITY%" (
  echo Unity not found: %UNITY%
  exit /b 1
)

"%UNITY%" -batchmode -quit -projectPath "%PROJECT%" -executeMethod Battle55ValidateCanvasZeroScaleRuntimeRenderActorVisibilityEditor.Build -logFile "%LOG%"
set "UNITY_EXIT=%errorlevel%"

python "%BASE%\_restore_tools\scripts\battle55_validate_canvas_zero_scale_runtime_render_actor_visibility.py" verify --unity-exit %UNITY_EXIT%
exit /b %errorlevel%
