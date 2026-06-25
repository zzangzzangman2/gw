@echo off
setlocal
cd /d "%~dp0"
python "%~dp0scripts\prepare_battle_ui_component_type_reconstruction.py"
set "UNITY_EXE=C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe"
if exist "%UNITY_EXE%" (
  "%UNITY_EXE%" -batchmode -quit -projectPath "%~dp0..\girlswar_battle_unity" -executeMethod BattleUIComponentTypeReconstructionEditor.Build -logFile "%~dp0..\reports\battle\BATTLE_18_COMPONENT_TYPE_RECONSTRUCTION.log"
)
python "%~dp0scripts\verify_battle_ui_component_type_reconstruction.py"
pause
