@echo off
setlocal
cd /d "%~dp0"
python "%~dp0scripts\build_minimal_battle_scene.py"
set "UNITY_EXE=C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe"
if exist "%UNITY_EXE%" (
  "%UNITY_EXE%" -batchmode -quit -projectPath "%~dp0..\girlswar_battle_unity" -executeMethod BattlePrototypeSceneBuilder.Build -logFile "%~dp0..\reports\battle\BATTLE_07_UNITY_BATCHMODE.log"
)
python "%~dp0scripts\verify_minimal_battle_scene.py"
pause
