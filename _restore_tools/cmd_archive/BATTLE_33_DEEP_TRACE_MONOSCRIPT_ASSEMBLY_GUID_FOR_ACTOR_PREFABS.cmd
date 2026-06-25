@echo off
setlocal
chcp 65001 >nul
set "BASE=C:\Users\godho\Downloads\girlswar"
set "UNITY=C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe"
set "PROJECT=%BASE%\girlswar_battle_unity"
set "LOG=%BASE%\reports\battle\BATTLE_33_MONOSCRIPT_ASSEMBLY_GUID_ACTOR_PREFABS.log"

if not exist "%UNITY%" (
  echo Unity not found: %UNITY%
  exit /b 1
)

"%UNITY%" -batchmode -quit -projectPath "%PROJECT%" -executeMethod BattleActorSpineRuntimeClassIdleMotionReplayEditor.Build -logFile "%LOG%"
if errorlevel 1 exit /b %errorlevel%

python "%BASE%\_restore_tools\scripts\trace_battle33_monoscript_assembly_guid_actor_prefabs.py"
exit /b %errorlevel%
