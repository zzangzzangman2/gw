@echo off
setlocal

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$Unity='C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe';" ^
  "$Project='C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity';" ^
  "$Log=Join-Path $Project 'logs\unity_maininterface_click_validation.log';" ^
  "if(!(Test-Path -LiteralPath $Unity)){ throw 'Unity.exe not found: '+$Unity };" ^
  "Start-Process -FilePath $Unity -ArgumentList @('-batchmode','-quit','-projectPath',$Project,'-executeMethod','GirlsWarRestore.MainInterfaceClickValidator.ValidateMainInterfaceButtonClicks','-logFile',$Log) -WindowStyle Hidden;" ^
  "Write-Host 'Started MainInterface click validation. Log:' $Log"

echo.
echo After it finishes, run:
echo 04_VERIFY_MAININTERFACE_OUTPUTS.cmd
echo 38_OPEN_MAININTERFACE_CLICK_VALIDATION_REPORT.cmd
echo.
pause


