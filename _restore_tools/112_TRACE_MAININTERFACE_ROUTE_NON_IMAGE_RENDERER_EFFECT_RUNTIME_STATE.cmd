@echo off
setlocal

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$Unity='C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe';" ^
  "$Project='C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity';" ^
  "if(!(Test-Path -LiteralPath $Unity)){ throw 'Unity.exe not found: '+$Unity };" ^
  "$steps=@(" ^
  "  @{Name='route non-Image renderer/effect runtime trace precheck'; Method='GirlsWarRestore.MainInterfaceRouteNonImageRendererEffectRuntimeStateTrace.Run'; Log='unity_112_route_non_image_renderer_effect_trace_pre.log'}," ^
  "  @{Name='MainInterface graphics capture'; Method='GirlsWarRestore.MainInterfaceSceneBuilder.CaptureMainInterfaceScene'; Log='unity_112_maininterface_capture.log'}," ^
  "  @{Name='MainInterface click validation'; Method='GirlsWarRestore.MainInterfaceClickValidator.ValidateMainInterfaceButtonClicks'; Log='unity_112_click_validation.log'}," ^
  "  @{Name='route non-Image renderer/effect runtime trace final report'; Method='GirlsWarRestore.MainInterfaceRouteNonImageRendererEffectRuntimeStateTrace.Run'; Log='unity_112_route_non_image_renderer_effect_trace_final.log'}" ^
  ");" ^
  "foreach($s in $steps){" ^
  "  $log=Join-Path $Project ('logs\'+$s.Log);" ^
  "  Write-Host ('Running '+$s.Name+' -> '+$s.Method);" ^
  "  $p=Start-Process -FilePath $Unity -ArgumentList @('-batchmode','-quit','-projectPath',$Project,'-executeMethod',$s.Method,'-logFile',$log) -WindowStyle Hidden -PassThru;" ^
  "  Wait-Process -Id $p.Id;" ^
  "  if($p.ExitCode -ne 0){ throw ($s.Name+' failed with exit code '+$p.ExitCode+'. Log: '+$log) };" ^
  "  Write-Host ('Finished '+$s.Name+'. Log: '+$log);" ^
  "};" ^
  "Write-Host 'Done. Report: C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_ROUTE_NON_IMAGE_RENDERER_EFFECT_RUNTIME_STATE_TRACE_RESULT.md'"

echo.
echo Report:
echo C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_ROUTE_NON_IMAGE_RENDERER_EFFECT_RUNTIME_STATE_TRACE_RESULT.md
echo.
pause
