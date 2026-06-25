@echo off
setlocal

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$Unity='C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe';" ^
  "$Project='C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity';" ^
  "if(!(Test-Path -LiteralPath $Unity)){ throw 'Unity.exe not found: '+$Unity };" ^
  "$steps=@(" ^
  "  @{Name='active TMP variant font probe'; Method='GirlsWarRestore.TmpStaticFontAssetProbe.RunActiveVariants'; Log='unity_110_active_tmp_variant_probe.log'}," ^
  "  @{Name='TMP shared material rebuild'; Method='GirlsWarRestore.TmpSharedMaterialBuilder.Run'; Log='unity_110_tmp_shared_material_rebuild.log'}," ^
  "  @{Name='route TMP variant material audit'; Method='GirlsWarRestore.MainInterfaceRouteTmpVariantMaterialAudit.Run'; Log='unity_110_route_tmp_variant_material_audit.log'}," ^
  "  @{Name='MainInterface graphics capture'; Method='GirlsWarRestore.MainInterfaceSceneBuilder.CaptureMainInterfaceScene'; Log='unity_110_maininterface_capture.log'}," ^
  "  @{Name='MainInterface click validation'; Method='GirlsWarRestore.MainInterfaceClickValidator.ValidateMainInterfaceButtonClicks'; Log='unity_110_click_validation.log'}" ^
  ");" ^
  "foreach($s in $steps){" ^
  "  $log=Join-Path $Project ('logs\'+$s.Log);" ^
  "  Write-Host ('Running '+$s.Name+' -> '+$s.Method);" ^
  "  $p=Start-Process -FilePath $Unity -ArgumentList @('-batchmode','-quit','-projectPath',$Project,'-executeMethod',$s.Method,'-logFile',$log) -WindowStyle Hidden -PassThru;" ^
  "  Wait-Process -Id $p.Id;" ^
  "  if($p.ExitCode -ne 0){ throw ($s.Name+' failed with exit code '+$p.ExitCode+'. Log: '+$log) };" ^
  "  Write-Host ('Finished '+$s.Name+'. Log: '+$log);" ^
  "};" ^
  "Write-Host 'Done. Report: C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_ROUTE_TMP_VARIANT_MATERIAL_AUDIT_RESULT.md'"

echo.
echo Report:
echo C:\Users\godho\Downloads\girlswar\reports\maininterface\MAININTERFACE_ROUTE_TMP_VARIANT_MATERIAL_AUDIT_RESULT.md
echo.
pause
