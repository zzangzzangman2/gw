@echo off
setlocal
chcp 65001 >nul
set "BASE=C:\Users\godho\Downloads\girlswar"
set "UNITY=C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe"
set "PROJECT=%BASE%\girlswar_battle_unity"
set "LOG=%BASE%\reports\battle\BATTLE_63_SKILL_TIMELINE_PLAYABLEDIRECTOR_BINDING_REQUIREMENTS_TRACE_NO_XLUA_NO_HANDLER_PATCH_UNITY.log"
"%UNITY%" -batchmode -quit -projectPath "%PROJECT%" -executeMethod Battle63SkillTimelinePlayableDirectorBindingTraceEditor.Build -logFile "%LOG%"
set "UNITY_EXIT=%errorlevel%"
if not "%UNITY_EXIT%"=="0" exit /b %UNITY_EXIT%
python "%BASE%\_restore_tools\scripts\battle63_skill_timeline_playabledirector_binding_trace.py"
exit /b %errorlevel%
