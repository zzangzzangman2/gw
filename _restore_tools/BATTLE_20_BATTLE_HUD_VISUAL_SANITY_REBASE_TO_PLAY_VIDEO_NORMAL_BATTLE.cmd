@echo off
setlocal
cd /d "%~dp0"
python "%~dp0scripts\prepare_battle_hud_visual_sanity_reference.py"
set "UNITY_EXE=C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe"
if exist "%UNITY_EXE%" (
  "%UNITY_EXE%" -batchmode -quit -projectPath "%~dp0..\girlswar_battle_unity" -executeMethod BattleHudVisualSanityEditor.Build -logFile "%~dp0..\reports\battle\BATTLE_20_HUD_VISUAL_SANITY.log"
)
python "%~dp0scripts\verify_battle_hud_visual_sanity.py"
pause
