@echo off
setlocal
cd /d "%~dp0"
set "UNITY_EXE=C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe"
python "%~dp0scripts\prepare_battle_hud_external_dependency_load_manifest.py"
if exist "%UNITY_EXE%" (
  "%UNITY_EXE%" -batchmode -quit -projectPath "%~dp0..\girlswar_battle_unity" -executeMethod BattleHudExternalDependencyLoadClip05Editor.Build -logFile "%~dp0..\reports\battle\BATTLE_23_HUD_EXTERNAL_DEPENDENCY_LOAD_CLIP05_VISUAL.log"
)
python "%~dp0scripts\verify_battle_hud_external_dependency_load_clip05_visual.py"
pause
