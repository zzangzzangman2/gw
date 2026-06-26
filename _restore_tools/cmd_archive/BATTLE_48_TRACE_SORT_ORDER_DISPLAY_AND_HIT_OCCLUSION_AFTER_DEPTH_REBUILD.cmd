@echo off
setlocal
chcp 65001 >nul
set "BASE=C:\Users\godho\Downloads\girlswar"
set "UNITY=C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe"
set "PROJECT=%BASE%\girlswar_battle_unity"
set "LOG=%BASE%\reports\battle\BATTLE_48_TRACE_SORT_ORDER_DISPLAY_AND_HIT_OCCLUSION_AFTER_DEPTH_REBUILD.log"

if not exist "%UNITY%" (
  echo Unity not found: %UNITY%
  exit /b 1
)

"%UNITY%" -batchmode -quit -projectPath "%PROJECT%" -executeMethod Battle48TraceSortOrderDisplayAndHitOcclusionAfterDepthRebuildEditor.Build -logFile "%LOG%"
set "UNITY_EXIT=%errorlevel%"

python "%BASE%\_restore_tools\scripts\battle48_sort_display_hit_occlusion_verify.py" verify --unity-exit %UNITY_EXIT%
exit /b %UNITY_EXIT%
