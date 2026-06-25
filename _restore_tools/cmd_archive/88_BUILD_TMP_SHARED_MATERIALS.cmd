@echo off
setlocal

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$Unity='C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe';" ^
  "$Project='C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity';" ^
  "$Log=Join-Path $Project 'logs\unity_tmp_shared_material_build.log';" ^
  "if(!(Test-Path -LiteralPath $Unity)){ throw 'Unity.exe not found: '+$Unity };" ^
  "$p=Start-Process -FilePath $Unity -ArgumentList @('-batchmode','-quit','-projectPath',$Project,'-executeMethod','GirlsWarRestore.TmpSharedMaterialBuilder.Run','-logFile',$Log) -WindowStyle Hidden -PassThru;" ^
  "Write-Host 'Started TMP shared material build PID=' $p.Id 'Log:' $Log;" ^
  "Wait-Process -Id $p.Id;" ^
  "Write-Host 'TMP shared material build finished. Log:' $Log"

echo.
echo Report:
echo C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_TMP_SHARED_MATERIAL_APPLY_RESULT.md
echo.
pause
