@echo off
setlocal
cd /d "%~dp0"
python "%~dp0scripts\prepare_assetbundle_streaming_probe.py"
set "UNITY_EXE=C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe"
if exist "%UNITY_EXE%" (
  "%UNITY_EXE%" -batchmode -quit -projectPath "%~dp0..\girlswar_battle_unity" -executeMethod BattleAssetBundleStreamingProbeEditor.Build -logFile "%~dp0..\reports\battle\BATTLE_10_UNITY_ASSETBUNDLE_STREAMING.log"
)
python "%~dp0scripts\verify_assetbundle_streaming_probe.py"
pause
