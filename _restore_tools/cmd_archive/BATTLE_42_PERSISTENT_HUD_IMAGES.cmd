@echo off
setlocal
chcp 65001 >nul
set "BASE=C:\Users\godho\Downloads\girlswar"
set "UNITY=C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe"
set "PROJECT=%BASE%\girlswar_battle_unity"
set "LOG=%BASE%\reports\battle\BATTLE_42_REBUILD_PERSISTENT_BATTLE_HUD_IMAGE_COMPONENTS_FROM_ORIGINAL_PREFAB_PPTR_AND_SPRITES.log"

if not exist "%UNITY%" (
  echo Unity not found: %UNITY%
  exit /b 1
)

"%UNITY%" -batchmode -quit -projectPath "%PROJECT%" -executeMethod Battle42RebuildPersistentBattleHudImageComponentsFromOriginalPrefabPptrAndSpritesEditor.Build -logFile "%LOG%"
set "UNITY_EXIT=%errorlevel%"

python "%BASE%\_restore_tools\scripts\battle42_persistent_hud_images.py" verify --unity-exit %UNITY_EXIT%
exit /b %UNITY_EXIT%

