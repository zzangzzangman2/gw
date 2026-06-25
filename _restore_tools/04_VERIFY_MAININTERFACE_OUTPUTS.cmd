@echo off
setlocal

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$p='C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity';" ^
  "$scene=Join-Path $p 'Assets\Scenes\MainInterface_Wireframe.unity';" ^
  "$result=Join-Path $p 'Assets\RestoreData\maininterface_build_result.json';" ^
  "$summary=Join-Path $p 'Assets\RestoreData\maininterface_component_summary.json';" ^
  "$spriteSummary=Join-Path $p 'Assets\RestoreData\maininterface_sprite_summary.json';" ^
  "$captureResult=Join-Path $p 'Assets\RestoreCaptures\maininterface_capture_result.json';" ^
  "$interactionSummary=Join-Path $p 'Assets\RestoreData\reports\maininterface_root_interaction_summary.json';" ^
  "$handlerSummary=Join-Path $p 'Assets\RestoreData\reports\maininterface_button_handler_summary.json';" ^
  "$xluaSummary=Join-Path $p 'Assets\RestoreData\reports\maininterface_xlua_loader_summary.json';" ^
  "$disasmSummary=Join-Path $p 'Assets\RestoreData\reports\maininterface_il2cpp_xlua_disassembly_summary.json';" ^
  "$xxteaSummary=Join-Path $p 'Assets\RestoreData\reports\maininterface_xxtea_static_arrays_summary.json';" ^
  "$rawXluaSummary=Join-Path $p 'Assets\RestoreData\reports\maininterface_xlua_textasset_raw_summary.json';" ^
  "$decodeSummary=Join-Path $p 'Assets\RestoreData\reports\maininterface_xlua_decode_summary.json';" ^
  "$luaHandlerSummary=Join-Path $p 'Assets\RestoreData\reports\maininterface_decoded_lua_handler_summary.json';" ^
  "$buttonLuaJoinSummary=Join-Path $p 'Assets\RestoreData\reports\maininterface_button_lua_handler_join_summary.json';" ^
  "$clickValidationSummary=Join-Path $p 'Assets\RestoreData\reports\maininterface_click_validation_summary.json';" ^
  "$clickBlockerSummary=Join-Path $p 'Assets\RestoreData\reports\maininterface_click_blocker_analysis_summary.json';" ^
  "$decodedXluaDir='C:\Users\godho\Downloads\girlswar\girlswar_merged_extracted\decoded\xlua';" ^
  "$spriteMap=Join-Path $p 'Assets\RestoreData\maininterface_sprite_map.csv';" ^
  "$spriteDir=Join-Path $p 'Assets\RestoredSprites\maininterface';" ^
  "Write-Host 'Unity project:' $p;" ^
  "Write-Host 'Scene exists:' (Test-Path -LiteralPath $scene);" ^
  "if(Test-Path -LiteralPath $scene) { Get-Item -LiteralPath $scene | Format-List FullName,Length,LastWriteTime };" ^
  "Write-Host 'Build result:';" ^
  "if(Test-Path -LiteralPath $result) { Get-Content -LiteralPath $result -Raw } else { Write-Host 'missing' };" ^
  "Write-Host 'Sprite summary:';" ^
  "if(Test-Path -LiteralPath $spriteSummary) { Get-Content -LiteralPath $spriteSummary -Raw } else { Write-Host 'missing' };" ^
  "Write-Host 'Copied sprite PNG count:';" ^
  "if(Test-Path -LiteralPath $spriteDir) { (Get-ChildItem -LiteralPath $spriteDir -Recurse -Filter '*.png' | Measure-Object).Count } else { Write-Host 'missing' };" ^
  "Write-Host 'Capture result:';" ^
  "if(Test-Path -LiteralPath $captureResult) { Get-Content -LiteralPath $captureResult -Raw } else { Write-Host 'missing' };" ^
  "Write-Host 'Sprite map:' $spriteMap;" ^
  "Write-Host 'Component summary:';" ^
  "if(Test-Path -LiteralPath $summary) { Get-Content -LiteralPath $summary -Raw } else { Write-Host 'missing' };" ^
  "Write-Host 'Interaction summary:';" ^
  "if(Test-Path -LiteralPath $interactionSummary) { Get-Content -LiteralPath $interactionSummary -Raw } else { Write-Host 'missing' };" ^
  "Write-Host 'Button handler summary:';" ^
  "if(Test-Path -LiteralPath $handlerSummary) { Get-Content -LiteralPath $handlerSummary -Raw } else { Write-Host 'missing' };" ^
  "Write-Host 'XLua loader summary:';" ^
  "if(Test-Path -LiteralPath $xluaSummary) { Get-Content -LiteralPath $xluaSummary -Raw } else { Write-Host 'missing' };" ^
  "Write-Host 'IL2CPP xLua disassembly summary:';" ^
  "if(Test-Path -LiteralPath $disasmSummary) { Get-Content -LiteralPath $disasmSummary -Raw } else { Write-Host 'missing' };" ^
  "Write-Host 'XXTEA static array summary:';" ^
  "if(Test-Path -LiteralPath $xxteaSummary) { Get-Content -LiteralPath $xxteaSummary -Raw } else { Write-Host 'missing' };" ^
  "Write-Host 'Raw xLua TextAsset extraction summary:';" ^
  "if(Test-Path -LiteralPath $rawXluaSummary) { Get-Content -LiteralPath $rawXluaSummary -Raw } else { Write-Host 'missing' };" ^
  "Write-Host 'xLua decode attempt summary:';" ^
  "if(Test-Path -LiteralPath $decodeSummary) { Get-Content -LiteralPath $decodeSummary -Raw } else { Write-Host 'missing' };" ^
  "Write-Host 'Decoded xLua .lua count:';" ^
  "if(Test-Path -LiteralPath $decodedXluaDir) { (Get-ChildItem -LiteralPath $decodedXluaDir -Filter '*.lua' | Measure-Object).Count } else { Write-Host 'missing' };" ^
  "Write-Host 'Decoded Lua handler scan summary:';" ^
  "if(Test-Path -LiteralPath $luaHandlerSummary) { Get-Content -LiteralPath $luaHandlerSummary -Raw } else { Write-Host 'missing' };" ^
  "Write-Host 'Button to Lua handler join summary:';" ^
  "if(Test-Path -LiteralPath $buttonLuaJoinSummary) { Get-Content -LiteralPath $buttonLuaJoinSummary -Raw } else { Write-Host 'missing' };" ^
  "Write-Host 'Button click validation summary:';" ^
  "if(Test-Path -LiteralPath $clickValidationSummary) { Get-Content -LiteralPath $clickValidationSummary -Raw } else { Write-Host 'missing' };" ^
  "Write-Host 'Button click blocker analysis summary:';" ^
  "if(Test-Path -LiteralPath $clickBlockerSummary) { Get-Content -LiteralPath $clickBlockerSummary -Raw } else { Write-Host 'missing' };"

pause


