@echo off
setlocal

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$p='C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity\Assets\RestoreData';" ^
  "$summary=Join-Path $p 'maininterface_sprite_summary.json';" ^
  "$deps=Join-Path $p 'maininterface_external_dependencies.csv';" ^
  "$map=Join-Path $p 'maininterface_sprite_map.csv';" ^
  "Write-Host 'Sprite summary:';" ^
  "if(Test-Path -LiteralPath $summary) { Get-Content -LiteralPath $summary -Raw } else { Write-Host 'missing' };" ^
  "Write-Host 'External dependency CSV:' $deps;" ^
  "Write-Host 'Sprite map CSV:' $map;" ^
  "Write-Host 'Top non-ready rows:';" ^
  "if(Test-Path -LiteralPath $map) { Import-Csv -LiteralPath $map | Where-Object { $_.status -ne 'ready' } | Select-Object -First 20 game_object_name,sprite_ref,cab_name,status | Format-Table -AutoSize }"

pause


