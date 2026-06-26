@echo off
setlocal
chcp 65001 >nul
set "BASE=C:\Users\godho\Downloads\girlswar"
set "UNITY=C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe"
set "PROJECT=%BASE%\girlswar_battle_unity"
set "LOG=%BASE%\reports\battle\BATTLE_57_REHYDRATE_SOURCE_BACKED_ASSETBUNDLE_ACTORS_IN_CANDIDATE_BUILDER_AND_CAPTURE_VALIDATE_NO_FAKE_MESH_UNITY.log"

if not exist "%UNITY%" (
  echo Unity not found: %UNITY%
  exit /b 1
)

"%UNITY%" -batchmode -quit -projectPath "%PROJECT%" -executeMethod Battle57RehydrateSourceBackedAssetBundleActorsEditor.Build -logFile "%LOG%"
set "UNITY_EXIT=%errorlevel%"

python "%BASE%\_restore_tools\scripts\battle57_rehydrate_source_backed_assetbundle_actors.py" verify --unity-exit %UNITY_EXIT%
exit /b %errorlevel%
