$ErrorActionPreference = "Stop"

$Base = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
$UnityExe = "C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe"
$Project = Join-Path $Base "girlswar_maininterface_unity"
$Reports = Join-Path $Base "reports\maininterface"
$Script = Join-Path $Base "_restore_tools\scripts\maininterface116_import_real_spine4_runtime_bridge.py"
$UnityLog = Join-Path $Reports "unity_116_import_real_spine4_runtime_bridge.log"
$ClickLog = Join-Path $Project "logs\unity_116_click_validation.log"

function Get-UnityReturnCodeFromLog([string]$Path) {
  if (-not (Test-Path -LiteralPath $Path)) { return $null }
  $line = Select-String -LiteralPath $Path -Pattern "Application will terminate with return code ([0-9]+)" | Select-Object -Last 1
  if ($line -and $line.Matches.Count -gt 0) { return [int]$line.Matches[0].Groups[1].Value }
  return $null
}

function Invoke-UnityMethod([string]$Method, [string]$Log, [switch]$NoGraphics) {
  $args = @("-batchmode", "-quit", "-projectPath", $Project, "-executeMethod", $Method, "-logFile", $Log)
  if ($NoGraphics) { $args = @("-batchmode", "-nographics", "-quit", "-projectPath", $Project, "-executeMethod", $Method, "-logFile", $Log) }
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
if (-not (Test-Path -LiteralPath $Script)) { throw "Python helper not found: $Script" }
New-Item -ItemType Directory -Force -Path $Reports, (Join-Path $Project "logs") | Out-Null

Write-Host "[GirlsWarRestore][116] Preparing Spine runtime bridge import"
python $Script prepare
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host "[GirlsWarRestore][116] Running MainInterface route Spine runtime bridge replay probe"
$unityExit = Invoke-UnityMethod -Method "GirlsWarRestore.MainInterface116RouteSpineRuntimeBridgeReplay.BuildAndCapture" -Log $UnityLog
Start-Sleep -Seconds 10

Write-Host "[GirlsWarRestore][116] Running click validation"
$clickExit = Invoke-UnityMethod -Method "GirlsWarRestore.MainInterfaceClickValidator.ValidateMainInterfaceButtonClicks" -Log $ClickLog -NoGraphics
if ($clickExit -ne 0) {
  Write-Warning "Click validation failed with exit code $clickExit"
}

Write-Host "[GirlsWarRestore][116] Writing final report"
python $Script report --unity-exit $unityExit
exit $unityExit
