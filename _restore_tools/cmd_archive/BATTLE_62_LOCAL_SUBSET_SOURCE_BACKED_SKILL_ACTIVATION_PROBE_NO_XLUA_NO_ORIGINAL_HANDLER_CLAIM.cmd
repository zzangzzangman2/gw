@echo off
setlocal
chcp 65001 >nul
set "BASE=C:\Users\godho\Downloads\girlswar"
set "UNITY=C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe"
set "PROJECT=%BASE%\girlswar_battle_unity"
set "LOG=%BASE%\reports\battle\BATTLE_62_LOCAL_SUBSET_SOURCE_BACKED_SKILL_ACTIVATION_PROBE_NO_XLUA_NO_ORIGINAL_HANDLER_CLAIM_UNITY.log"

if not exist "%UNITY%" (
  echo Unity not found: %UNITY%
  exit /b 1
)

"%UNITY%" -batchmode -quit -projectPath "%PROJECT%" -executeMethod Battle62LocalSubsetSourceBackedSkillActivationProbeEditor.Build -logFile "%LOG%"
set "UNITY_EXIT=%errorlevel%"

python "%BASE%\_restore_tools\scripts\battle62_local_subset_source_backed_skill_activation_probe.py"
exit /b %errorlevel%
