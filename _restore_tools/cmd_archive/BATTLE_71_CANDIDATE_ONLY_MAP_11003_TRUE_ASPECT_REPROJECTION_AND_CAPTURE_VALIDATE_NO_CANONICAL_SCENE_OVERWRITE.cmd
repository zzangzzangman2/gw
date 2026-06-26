@echo off
setlocal
cd /d "%~dp0..\.."
set "UNITY_EXE=C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe"
set "PROJECT=%CD%\girlswar_battle_unity"
set "LOG=%CD%\reports\battle\BATTLE_71_CANDIDATE_ONLY_MAP_11003_TRUE_ASPECT_REPROJECTION_AND_CAPTURE_VALIDATE_NO_CANONICAL_SCENE_OVERWRITE_UNITY.log"
if not exist "%UNITY_EXE%" (
  echo Unity.exe not found: %UNITY_EXE%
  exit /b 1
)
"%UNITY_EXE%" -batchmode -quit -projectPath "%PROJECT%" -executeMethod Battle71Map11003TrueAspectReprojectionEditor.Build -logFile "%LOG%"
python _restore_tools\scripts\battle71_candidate_map_reprojection_validate.py
