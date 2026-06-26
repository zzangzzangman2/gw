@echo off
setlocal
cd /d "%~dp0..\.."
set "UNITY_EXE=C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe"
set "PROJECT=%CD%\girlswar_battle_unity"
set "LOG=%CD%\reports\battle\BATTLE_73_ROUTE_HUD_RIGHT_RAIL_RUNTIME_STATE_SIBLING_MASK_TMP_AUDIT_AFTER_PERSISTED_MAP_REPROJECTION_NO_PATCH_UNITY.log"
if not exist "%UNITY_EXE%" (
  echo Unity.exe not found: %UNITY_EXE%
  exit /b 1
)
"%UNITY_EXE%" -batchmode -quit -projectPath "%PROJECT%" -executeMethod Battle73RouteHudRightRailAuditEditor.Build -logFile "%LOG%"
python _restore_tools\scripts\battle73_route_hud_right_rail_audit.py
