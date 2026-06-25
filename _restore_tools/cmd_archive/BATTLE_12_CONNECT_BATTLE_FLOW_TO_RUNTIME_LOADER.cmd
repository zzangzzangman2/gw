@echo off
setlocal
cd /d "%~dp0"
python "%~dp0scripts\connect_battle_flow_to_runtime_loader.py"
set "UNITY_EXE=C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe"
if exist "%UNITY_EXE%" (
  "%UNITY_EXE%" -batchmode -quit -projectPath "%~dp0..\girlswar_battle_unity" -executeMethod BattleRuntimeFlowPrototypeEditor.Build -logFile "%~dp0..\reports\battle\BATTLE_12_UNITY_RUNTIME_FLOW.log"
)
python "%~dp0scripts\verify_battle_runtime_flow_link.py"
pause
