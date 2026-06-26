@echo off
setlocal
chcp 65001 >nul
set "BASE=C:\Users\godho\Downloads\girlswar"
set "UNITY=C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe"
set "PROJECT=%BASE%\girlswar_battle_unity"
set "LOG=%BASE%\reports\battle\BATTLE_56_TRACE_ACTOR_PREFAB_MESH_MATERIAL_SHADER_SOURCE_IMPORT_GAP_OR_SOURCE_BACKED_PATCH_UNITY.log"

if not exist "%UNITY%" (
  echo Unity not found: %UNITY%
  exit /b 1
)

"%UNITY%" -batchmode -quit -projectPath "%PROJECT%" -executeMethod Battle56TraceActorPrefabMeshMaterialShaderSourceImportGapEditor.Build -logFile "%LOG%"
set "UNITY_EXIT=%errorlevel%"

python "%BASE%\_restore_tools\scripts\battle56_trace_actor_prefab_mesh_material_shader_source_import_gap.py" verify --unity-exit %UNITY_EXIT%
exit /b %errorlevel%
