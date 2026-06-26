@echo off
setlocal
chcp 65001 >nul
set "BASE=C:\Users\godho\Downloads\girlswar"
set "UNITY=C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe"
set "PROJECT=%BASE%\girlswar_battle_unity"
set "LOG=%BASE%\reports\battle\BATTLE_44_TRACE_ORIGINAL_BUTTON_MONOSCRIPT_AND_TARGET_GRAPHIC_SERIALIZATION.log"

if not exist "%UNITY%" (
  echo Unity not found: %UNITY%
  exit /b 1
)

python "%BASE%\_restore_tools\scripts\battle44_trace_original_button_target_graphic.py" prepare
if errorlevel 1 exit /b %errorlevel%

"%UNITY%" -batchmode -quit -projectPath "%PROJECT%" -executeMethod Battle44TraceOriginalButtonMonoScriptAndTargetGraphicSerializationEditor.Build -logFile "%LOG%"
set "UNITY_EXIT=%errorlevel%"

python "%BASE%\_restore_tools\scripts\battle44_trace_original_button_target_graphic.py" verify --unity-exit %UNITY_EXIT%
exit /b %UNITY_EXIT%
