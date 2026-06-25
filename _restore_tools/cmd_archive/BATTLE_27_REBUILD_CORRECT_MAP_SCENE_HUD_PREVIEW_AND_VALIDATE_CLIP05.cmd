@echo off
setlocal
chcp 65001 >nul
set "BASE=C:\Users\godho\Downloads\girlswar"
set "UNITY=C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe"
set "PROJECT=%BASE%\girlswar_battle_unity"
set "LOG=%BASE%\reports\battle\BATTLE_27_CORRECT_MAP_SCENE_HUD_PREVIEW_CLIP05.log"

if not exist "%UNITY%" (
  echo Unity not found: %UNITY%
  exit /b 1
)

"%UNITY%" -batchmode -quit -projectPath "%PROJECT%" -executeMethod BattleCorrectMapSceneHudPreviewClip05Editor.Build -logFile "%LOG%"
if errorlevel 1 exit /b %errorlevel%

python "%BASE%\_restore_tools\scripts\verify_battle27_correct_map_scene_hud_preview_clip05.py"
exit /b %errorlevel%
