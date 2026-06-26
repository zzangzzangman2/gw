@echo off
setlocal
cd /d "%~dp0..\.."
set "UNITY_EXE=C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe"
set "PROJECT=%CD%\girlswar_battle_unity"
set "LOG=%CD%\reports\battle\BATTLE_72_PERSIST_VALIDATED_MAP_11003_TRUE_ASPECT_REPROJECTION_IN_CANDIDATE_BUILDER_AND_RERUN_VALIDATION_NO_CANONICAL_OVERWRITE_UNITY.log"
if not exist "%UNITY_EXE%" (
  echo Unity.exe not found: %UNITY_EXE%
  exit /b 1
)
"%UNITY_EXE%" -batchmode -quit -projectPath "%PROJECT%" -executeMethod Battle72PersistMap11003TrueAspectReprojectionEditor.Build -logFile "%LOG%"
python _restore_tools\scripts\battle72_persist_map_reprojection_validate.py
