@echo off
setlocal
chcp 65001 >nul
set "BASE=C:\Users\godho\Downloads\girlswar"
set "UNITY=C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe"
set "PROJECT=%BASE%\girlswar_battle_unity"
set "LOG=%BASE%\reports\battle\BATTLE_64_TIMELINE_PLAYABLEASSET_COMPATIBILITY_AND_ORIGINAL_BINDING_SOURCE_TRACE_NO_PATCH_UNITY.log"
"%UNITY%" -batchmode -quit -projectPath "%PROJECT%" -executeMethod Battle64TimelinePlayableAssetCompatibilityTraceEditor.Build -logFile "%LOG%"
set "UNITY_EXIT=%errorlevel%"
if not "%UNITY_EXIT%"=="0" exit /b %UNITY_EXIT%
python "%BASE%\_restore_tools\scripts\battle64_timeline_playableasset_compatibility_source_trace.py"
exit /b %errorlevel%
