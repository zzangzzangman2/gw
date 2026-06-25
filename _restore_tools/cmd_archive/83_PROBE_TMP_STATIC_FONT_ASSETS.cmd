@echo off
setlocal

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$Unity='C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe';" ^
  "$Project='C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity';" ^
  "$Log=Join-Path $Project 'logs\unity_tmp_static_font_probe.log';" ^
  "if(!(Test-Path -LiteralPath $Unity)){ throw 'Unity.exe not found: '+$Unity };" ^
  "$p=Start-Process -FilePath $Unity -ArgumentList @('-batchmode','-quit','-projectPath',$Project,'-executeMethod','GirlsWarRestore.TmpStaticFontAssetProbe.Run','-logFile',$Log) -WindowStyle Hidden -PassThru;" ^
  "Write-Host 'Started TMP static font probe PID=' $p.Id 'Log:' $Log;" ^
  "Wait-Process -Id $p.Id;" ^
  "Write-Host 'TMP static font probe finished. Log:' $Log"

echo.
echo Report:
echo C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_TMP_STATIC_FONT_PROBE_RESULT.md
echo.
pause
