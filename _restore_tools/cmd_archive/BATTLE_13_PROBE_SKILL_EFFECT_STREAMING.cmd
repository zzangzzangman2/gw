@echo off
setlocal
cd /d "%~dp0"
python "%~dp0scripts\prepare_skill_effect_streaming_probe.py"
set "UNITY_EXE=C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe"
if exist "%UNITY_EXE%" (
  "%UNITY_EXE%" -batchmode -quit -projectPath "%~dp0..\girlswar_battle_unity" -executeMethod BattleSkillEffectStreamingProbeEditor.Build -logFile "%~dp0..\reports\battle\BATTLE_13_UNITY_SKILL_EFFECT_STREAMING.log"
)
python "%~dp0scripts\verify_skill_effect_streaming_probe.py"
pause
