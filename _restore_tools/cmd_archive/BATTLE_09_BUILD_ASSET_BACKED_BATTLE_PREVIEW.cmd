@echo off
setlocal
cd /d "%~dp0"
python "%~dp0scripts\build_asset_backed_battle_preview.py"
set "UNITY_EXE=C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe"
if exist "%UNITY_EXE%" (
  "%UNITY_EXE%" -batchmode -quit -projectPath "%~dp0..\girlswar_battle_unity" -executeMethod BattleAssetBackedPreviewSceneBuilder.Build -logFile "%~dp0..\reports\battle\BATTLE_09_UNITY_ASSET_BACKED_PREVIEW.log"
)
python "%~dp0scripts\verify_asset_backed_battle_preview.py"
pause
