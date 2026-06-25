$ErrorActionPreference = "Stop"

$Base = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
$UnityExe = "C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe"
$Project = Join-Path $Base "girlswar_maininterface_unity"
$Reports = Join-Path $Base "reports\maininterface"
$UnityLog = Join-Path $Reports "unity_118_route_skeletongraphic_ui_material.log"
$ClickLog = Join-Path $Project "logs\unity_118_click_validation.log"
$ReportScript = Join-Path $Base "_restore_tools\scripts\maininterface118_route_skeletongraphic_ui_material_report.py"

function Get-UnityReturnCodeFromLog([string]$Path) {
  if (-not (Test-Path -LiteralPath $Path)) { return $null }
  $line = Select-String -LiteralPath $Path -Pattern "Application will terminate with return code ([0-9]+)" | Select-Object -Last 1
  if ($line -and $line.Matches.Count -gt 0) { return [int]$line.Matches[0].Groups[1].Value }
  return $null
}

function Invoke-UnityMethod([string]$Method, [string]$Log) {
  $args = @("-batchmode", "-quit", "-projectPath", $Project, "-executeMethod", $Method, "-logFile", $Log)
  & $UnityExe @args
  $processCode = $LASTEXITCODE
  Start-Sleep -Seconds 2
  $logCode = Get-UnityReturnCodeFromLog $Log
  $code = if ($null -ne $logCode) { $logCode } elseif ($null -ne $processCode) { $processCode } else { 0 }
  if ($code -ne 0) {
    Start-Sleep -Seconds 5
    $logCode = Get-UnityReturnCodeFromLog $Log
    if ($null -ne $logCode) { $code = $logCode }
  }
  return $code
}

if (-not (Test-Path -LiteralPath $UnityExe)) { throw "Unity editor not found: $UnityExe" }
if (-not (Test-Path -LiteralPath $ReportScript)) { throw "Report helper not found: $ReportScript" }
New-Item -ItemType Directory -Force -Path $Reports, (Join-Path $Project "logs") | Out-Null

Write-Host "[GirlsWarRestore][118] Binding route SkeletonGraphic UI material/shader pass from original fields"
$unityExit = Invoke-UnityMethod -Method "GirlsWarRestore.MainInterface118RouteSkeletonGraphicUIMaterialBinder.BindAndCapture" -Log $UnityLog
Start-Sleep -Seconds 5

Write-Host "[GirlsWarRestore][118] Running MainInterface click validation"
$clickExit = Invoke-UnityMethod -Method "GirlsWarRestore.MainInterfaceClickValidator.ValidateMainInterfaceButtonClicks" -Log $ClickLog
if ($clickExit -ne 0) {
  Write-Warning "Click validation failed with exit code $clickExit"
}

Write-Host "[GirlsWarRestore][118] Writing final report"
python $ReportScript
exit $unityExit
