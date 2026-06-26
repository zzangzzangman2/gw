@echo off
setlocal
chcp 65001 >nul
set "BASE=C:\Users\godho\Downloads\girlswar"
set "UNITY=C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe"
set "PROJECT=%BASE%\girlswar_battle_unity"
set "LOG=%BASE%\reports\battle\BATTLE_58_TRACE_XLUA_GAMEENTRY_MODULESINIT_HANDLER_BINDING_WITH_BATTLE57_ACTORS_NO_FAKE_HANDLER_UNITY.log"

if not exist "%UNITY%" (
  echo Unity not found: %UNITY%
  exit /b 1
)

"%UNITY%" -batchmode -quit -projectPath "%PROJECT%" -executeMethod Battle58TraceXluaGameEntryModulesInitHandlerBindingEditor.Build -logFile "%LOG%"
set "UNITY_EXIT=%errorlevel%"

python "%BASE%\_restore_tools\scripts\battle58_trace_xlua_gameentry_modulesinit_handler_binding.py" verify --unity-exit %UNITY_EXIT%
exit /b %errorlevel%
