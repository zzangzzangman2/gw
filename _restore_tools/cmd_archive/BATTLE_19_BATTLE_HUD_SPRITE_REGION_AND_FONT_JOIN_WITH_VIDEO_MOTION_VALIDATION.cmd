@echo off
setlocal
cd /d "%~dp0"
python "%~dp0scripts\prepare_battle_hud_sprite_region_font_join.py"
set "UNITY_EXE=C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe"
if exist "%UNITY_EXE%" (
  "%UNITY_EXE%" -batchmode -quit -projectPath "%~dp0..\girlswar_battle_unity" -executeMethod BattleHudSpriteFontJoinEditor.Build -logFile "%~dp0..\reports\battle\BATTLE_19_HUD_SPRITE_FONT_JOIN.log"
)
python "%~dp0scripts\verify_battle_hud_sprite_region_font_join.py"
pause
