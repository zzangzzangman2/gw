@echo off
setlocal
chcp 65001 >nul
set "BASE=C:\Users\godho\Downloads\girlswar"
set "UNITY=C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe"
set "PROJECT=%BASE%\girlswar_battle_unity"
set "LOG=%BASE%\reports\battle\BATTLE_25_SPRITE_ATLAS_TEXTURE_RUNTIME_BINDING_CLIP05.log"

if not exist "%UNITY%" (
  echo Unity not found: %UNITY%
  exit /b 1
)

"%UNITY%" -batchmode -quit -projectPath "%PROJECT%" -executeMethod BattleHudSpriteAtlasTextureRuntimeBindingClip05Editor.Build -logFile "%LOG%"
if errorlevel 1 exit /b %errorlevel%

python "%BASE%\_restore_tools\scripts\verify_battle_hud_sprite_atlas_texture_runtime_binding_clip05.py"
exit /b %errorlevel%
