@echo off
setlocal

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$Unity='C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe';" ^
  "$Project='C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity';" ^
  "if(!(Test-Path -LiteralPath $Unity)){ throw 'Unity.exe not found: '+$Unity };" ^
  "$steps=@(" ^
  "  @{Name='route label rect override revalidation'; Method='GirlsWarRestore.MainInterfaceRouteLabelRectOverrideRevalidation.Run'; Log='unity_111_route_label_rect_override_revalidation.log'}," ^
  "  @{Name='MainInterface graphics capture'; Method='GirlsWarRestore.MainInterfaceSceneBuilder.CaptureMainInterfaceScene'; Log='unity_111_maininterface_capture.log'}," ^
  "  @{Name='MainInterface click validation'; Method='GirlsWarRestore.MainInterfaceClickValidator.ValidateMainInterfaceButtonClicks'; Log='unity_111_click_validation.log'}" ^
  ");" ^
  "foreach($s in $steps){" ^
  "  $log=Join-Path $Project ('logs\'+$s.Log);" ^
  "  Write-Host ('Running '+$s.Name+' -> '+$s.Method);" ^
  "  $p=Start-Process -FilePath $Unity -ArgumentList @('-batchmode','-quit','-projectPath',$Project,'-executeMethod',$s.Method,'-logFile',$log) -WindowStyle Hidden -PassThru;" ^
  "  Wait-Process -Id $p.Id;" ^
  "  if($p.ExitCode -ne 0){ throw ($s.Name+' failed with exit code '+$p.ExitCode+'. Log: '+$log) };" ^
  "  Write-Host ('Finished '+$s.Name+'. Log: '+$log);" ^
  "};" ^
  "Write-Host 'Done. Report: C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_ROUTE_LABEL_RECT_OVERRIDE_REVALIDATION_RESULT.md'"

echo.
echo Report:
echo C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_ROUTE_LABEL_RECT_OVERRIDE_REVALIDATION_RESULT.md
echo.
pause
