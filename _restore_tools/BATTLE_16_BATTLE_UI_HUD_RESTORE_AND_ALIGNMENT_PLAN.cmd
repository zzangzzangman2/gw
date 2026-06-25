@echo off
setlocal
cd /d "%~dp0"
python "%~dp0scripts\prepare_battle_ui_hud_candidates.py"
set "UNITY_EXE=C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe"
if exist "%UNITY_EXE%" (
  "%UNITY_EXE%" -batchmode -quit -projectPath "%~dp0..\girlswar_battle_unity" -executeMethod BattleUIHudEvidenceProbeEditor.Build -logFile "%~dp0..\reports\battle\BATTLE_16_UNITY_UI_HUD_PROBE.log"
)
python "%~dp0scripts\verify_battle_ui_hud_plan.py"
pause
