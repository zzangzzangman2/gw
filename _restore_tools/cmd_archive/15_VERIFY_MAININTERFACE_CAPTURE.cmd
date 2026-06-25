@echo off
setlocal

powershell -NoProfile -ExecutionPolicy Bypass -Command ^
  "$p='C:\Users\godho\Downloads\girlswar\girlswar_maininterface_unity';" ^
  "$capture=Join-Path $p 'Assets\RestoreCaptures\maininterface_restored_1680x720.png';" ^
  "$result=Join-Path $p 'Assets\RestoreCaptures\maininterface_capture_result.json';" ^
  "$log=Join-Path $p 'logs\unity_maininterface_capture.log';" ^
  "Write-Host 'Capture exists:' (Test-Path -LiteralPath $capture);" ^
  "if(Test-Path -LiteralPath $capture) { Get-Item -LiteralPath $capture | Format-List FullName,Length,LastWriteTime };" ^
  "Write-Host 'Capture result:';" ^
  "if(Test-Path -LiteralPath $result) { Get-Content -LiteralPath $result -Raw } else { Write-Host 'missing' };" ^
  "Write-Host 'Capture log key lines:';" ^
  "if(Test-Path -LiteralPath $log) { Select-String -LiteralPath $log -Pattern 'MainInterface capture saved|return code|Exception|error CS' | ForEach-Object { $_.Line } } else { Write-Host 'missing' };"

pause


