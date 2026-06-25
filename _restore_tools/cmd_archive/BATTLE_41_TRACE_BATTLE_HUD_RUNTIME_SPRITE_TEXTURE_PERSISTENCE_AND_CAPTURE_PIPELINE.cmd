@echo off
setlocal
chcp 65001 >nul
set "BASE=C:\Users\godho\Downloads\girlswar"
set "UNITY=C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe"
set "PROJECT=%BASE%\girlswar_battle_unity"
set "LOG=%BASE%\reports\battle\BATTLE_41_TRACE_BATTLE_HUD_RUNTIME_SPRITE_TEXTURE_PERSISTENCE_AND_CAPTURE_PIPELINE.log"

if not exist "%UNITY%" (
  echo Unity not found: %UNITY%
  exit /b 1
)

"%UNITY%" -batchmode -quit -projectPath "%PROJECT%" -executeMethod Battle41TraceBattleHudRuntimeSpriteTexturePersistenceAndCapturePipelineEditor.Build -logFile "%LOG%"
set "UNITY_EXIT=%errorlevel%"

python "%BASE%\_restore_tools\scripts\battle41_trace_battle_hud_runtime_sprite_texture_persistence_and_capture_pipeline.py" verify --unity-exit %UNITY_EXIT%
exit /b %UNITY_EXIT%
