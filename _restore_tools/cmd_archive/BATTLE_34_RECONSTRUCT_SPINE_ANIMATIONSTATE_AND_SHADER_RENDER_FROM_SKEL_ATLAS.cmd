@echo off
setlocal
chcp 65001 >nul
set "BASE=C:\Users\godho\Downloads\girlswar"
set "UNITY=C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe"
set "PROJECT=%BASE%\girlswar_battle_unity"
set "LOG=%BASE%\reports\battle\BATTLE_34_RECONSTRUCT_SPINE_ANIMATIONSTATE_AND_SHADER_RENDER_FROM_SKEL_ATLAS.log"

if not exist "%UNITY%" (
  echo Unity not found: %UNITY%
  exit /b 1
)

"%UNITY%" -batchmode -quit -projectPath "%PROJECT%" -executeMethod Battle34SpineAnimationStateShaderRenderProbeEditor.Build -logFile "%LOG%"
if errorlevel 1 exit /b %errorlevel%

python "%BASE%\_restore_tools\scripts\verify_battle34_reconstruct_spine_animationstate_shader_render.py"
exit /b %errorlevel%
