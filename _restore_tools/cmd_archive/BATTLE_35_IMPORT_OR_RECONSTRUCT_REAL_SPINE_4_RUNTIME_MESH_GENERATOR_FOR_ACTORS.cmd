@echo off
setlocal
chcp 65001 >nul
set "BASE=C:\Users\godho\Downloads\girlswar"
set "UNITY=C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe"
set "PROJECT=%BASE%\girlswar_battle_unity"
set "LOG=%BASE%\reports\battle\BATTLE_35_IMPORT_OR_RECONSTRUCT_REAL_SPINE_4_RUNTIME_MESH_GENERATOR_FOR_ACTORS.log"

if not exist "%UNITY%" (
  echo Unity not found: %UNITY%
  exit /b 1
)

python "%BASE%\_restore_tools\scripts\battle35_import_or_reconstruct_real_spine_runtime.py" prepare
if errorlevel 1 exit /b %errorlevel%

"%UNITY%" -batchmode -quit -projectPath "%PROJECT%" -executeMethod Battle35RealSpineRuntimeMeshGeneratorProbeEditor.Build -logFile "%LOG%"
set "UNITY_EXIT=%errorlevel%"

python "%BASE%\_restore_tools\scripts\battle35_import_or_reconstruct_real_spine_runtime.py" verify --unity-exit %UNITY_EXIT%
exit /b %UNITY_EXIT%
