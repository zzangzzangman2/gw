@echo off
setlocal
chcp 65001 >nul
set "BASE=C:\Users\godho\Downloads\girlswar"
set "UNITY=C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe"
set "PROJECT=%BASE%\girlswar_battle_unity"
set "LOG=%BASE%\reports\battle\BATTLE_60_VALIDATE_LOADABLE_LOCAL_SUBSET_SKILL_TIMELINE_ASSETBUNDLE_CHAIN_NO_XLUA_NO_HANDLER_PATCH_UNITY.log"

if not exist "%UNITY%" (
  echo Unity not found: %UNITY%
  exit /b 1
)

"%UNITY%" -batchmode -quit -projectPath "%PROJECT%" -executeMethod Battle60ValidateLoadableLocalSubsetSkillTimelineEditor.Build -logFile "%LOG%"
set "UNITY_EXIT=%errorlevel%"

python "%BASE%\_restore_tools\scripts\battle60_validate_loadable_local_subset_skill_timeline.py"
exit /b %errorlevel%
