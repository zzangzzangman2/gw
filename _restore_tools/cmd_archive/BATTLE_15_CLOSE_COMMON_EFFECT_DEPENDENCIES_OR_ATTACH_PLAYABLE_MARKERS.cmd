@echo off
setlocal
cd /d "%~dp0"
python "%~dp0scripts\prepare_common_effect_dependency_closure.py"
set "UNITY_EXE=C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe"
if exist "%UNITY_EXE%" (
  "%UNITY_EXE%" -batchmode -quit -projectPath "%~dp0..\girlswar_battle_unity" -executeMethod BattleCommonEffectClosureEditor.Build -logFile "%~dp0..\reports\battle\BATTLE_15_UNITY_COMMON_EFFECT_CLOSURE.log"
)
python "%~dp0scripts\verify_common_effect_dependency_closure.py"
pause
