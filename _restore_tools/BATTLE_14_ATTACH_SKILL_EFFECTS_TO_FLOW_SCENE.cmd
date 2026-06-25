@echo off
setlocal
cd /d "%~dp0"
python "%~dp0scripts\prepare_skill_effect_attach_manifest.py"
set "UNITY_EXE=C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe"
if exist "%UNITY_EXE%" (
  "%UNITY_EXE%" -batchmode -quit -projectPath "%~dp0..\girlswar_battle_unity" -executeMethod BattleSkillEffectAttachEditor.Build -logFile "%~dp0..\reports\battle\BATTLE_14_UNITY_SKILL_EFFECT_ATTACH.log"
)
python "%~dp0scripts\verify_skill_effect_attach.py"
pause
