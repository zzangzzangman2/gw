@echo off
setlocal
cd /d "%~dp0"
set "UNITY_EXE=C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe"
if exist "%UNITY_EXE%" (
  "%UNITY_EXE%" -batchmode -quit -projectPath "%~dp0..\girlswar_battle_unity" -executeMethod BattleHudRuntimeBindingSpritePptrTraceEditor.Build -logFile "%~dp0..\reports\battle\BATTLE_21_HUD_RUNTIME_BINDING_SPRITE_PPTR_TRACE.log"
)
python "%~dp0scripts\verify_battle_hud_runtime_binding_sprite_pptr_trace.py"
pause
