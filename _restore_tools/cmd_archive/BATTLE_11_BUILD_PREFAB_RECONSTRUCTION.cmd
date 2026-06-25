@echo off
setlocal
cd /d "%~dp0"
python "%~dp0scripts\prepare_prefab_reconstruction.py"
set "UNITY_EXE=C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe"
if exist "%UNITY_EXE%" (
  "%UNITY_EXE%" -batchmode -quit -projectPath "%~dp0..\girlswar_battle_unity" -executeMethod BattlePrefabReconstructionEditor.Build -logFile "%~dp0..\reports\battle\BATTLE_11_UNITY_PREFAB_RECONSTRUCTION.log"
)
python "%~dp0scripts\verify_prefab_reconstruction.py"
pause
