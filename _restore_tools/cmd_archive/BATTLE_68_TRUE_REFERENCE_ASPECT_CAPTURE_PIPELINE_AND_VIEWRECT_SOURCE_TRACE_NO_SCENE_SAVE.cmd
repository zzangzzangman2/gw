@echo off
setlocal
chcp 65001 >nul
set "BASE=C:\Users\godho\Downloads\girlswar"
set "UNITY=C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe"
set "PROJECT=%BASE%\girlswar_battle_unity"
set "LOG=%BASE%\reports\battle\BATTLE_68_TRUE_REFERENCE_ASPECT_CAPTURE_PIPELINE_AND_VIEWRECT_SOURCE_TRACE_NO_SCENE_SAVE_UNITY.log"

if not exist "%UNITY%" (
  echo Unity not found: %UNITY%
  exit /b 1
)

"%UNITY%" -batchmode -quit -projectPath "%PROJECT%" -executeMethod Battle68TrueReferenceAspectCaptureNoSceneSaveEditor.Build -logFile "%LOG%"
set "UNITY_EXIT=%errorlevel%"

cd /d "%BASE%"
python _restore_tools\scripts\battle68_true_reference_aspect_capture_pipeline_trace.py --unity-exit %UNITY_EXIT%
