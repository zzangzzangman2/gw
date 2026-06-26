@echo off
setlocal

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$Unity='C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe';" ^
  "$Project='C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity';" ^
  "$Log=Join-Path $Project 'logs\unity_149_reference_aspect_audit_and_safe_capture.log';" ^
  "if(!(Test-Path -LiteralPath $Unity)){ throw 'Unity.exe not found: '+$Unity };" ^
  "New-Item -ItemType Directory -Force -Path (Split-Path $Log) | Out-Null;" ^
  "$p=Start-Process -FilePath $Unity -ArgumentList @('-batchmode','-quit','-projectPath',$Project,'-executeMethod','GirlsWarRestore.MainInterface149ReferenceAuditAndAspectCapture.Run','-logFile',$Log) -WindowStyle Hidden -PassThru;" ^
  "$p.WaitForExit();" ^
  "Write-Host 'Unity exit code:' $p.ExitCode;" ^
  "Write-Host 'Log:' $Log;" ^
  "exit $p.ExitCode"
