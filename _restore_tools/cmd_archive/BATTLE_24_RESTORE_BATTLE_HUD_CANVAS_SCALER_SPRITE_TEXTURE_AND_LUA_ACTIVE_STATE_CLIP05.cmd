@echo off
setlocal
cd /d "%~dp0"
set "UNITY_EXE=C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe"
if exist "%UNITY_EXE%" (
  "%UNITY_EXE%" -batchmode -quit -projectPath "%~dp0..\girlswar_battle_unity" -executeMethod BattleHudCanvasScalerSpriteTextureLuaStateClip05Editor.Build -logFile "%~dp0..\reports\battle\BATTLE_24_CANVAS_SCALER_SPRITE_TEXTURE_LUA_STATE_CLIP05.log"
)
python "%~dp0scripts\verify_battle_hud_canvas_scaler_sprite_texture_lua_state_clip05.py"
pause
