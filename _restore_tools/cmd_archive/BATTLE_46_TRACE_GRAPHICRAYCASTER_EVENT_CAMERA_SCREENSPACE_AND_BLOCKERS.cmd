@echo off
setlocal
chcp 65001 >nul
set "BASE=C:\Users\godho\Downloads\girlswar"
set "UNITY=C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe"
set "PROJECT=%BASE%\girlswar_battle_unity"
set "LOG=%BASE%\reports\battle\BATTLE_46_TRACE_GRAPHICRAYCASTER_EVENT_CAMERA_SCREENSPACE_AND_BLOCKERS.log"

if not exist "%UNITY%" (
  echo Unity not found: %UNITY%
  exit /b 1
)

"%UNITY%" -batchmode -quit -projectPath "%PROJECT%" -executeMethod Battle46TraceGraphicRaycasterEventCameraScreenSpaceAndBlockersEditor.Build -logFile "%LOG%"
set "UNITY_EXIT=%errorlevel%"

python "%BASE%\_restore_tools\scripts\battle46_graphicraycaster_event_camera_screenspace_verify.py" verify --unity-exit %UNITY_EXIT%
exit /b %UNITY_EXIT%
