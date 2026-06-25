$ErrorActionPreference = "Stop"

$Base = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
$Tools = Join-Path $Base "_restore_tools"
$SourceProject = Join-Path $Base "girlswar_maininterface_unity"
$WorkRoot = Join-Path $Tools "work"
$VendorPackage = Join-Path $Tools "vendor\spine-unity-4.0-2024-08-21.unitypackage"
$Reports = Join-Path $Base "reports\maininterface"
$UnityExe = "C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe"

$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$ProbeProject = Join-Path $WorkRoot "spine40_unity6000_probe_$Stamp"
$LatestProbeFile = Join-Path $WorkRoot "spine40_unity6000_probe_latest.txt"
$LatestResultFile = Join-Path $WorkRoot "spine40_unity6000_probe_latest_result.json"
$LatestLog = Join-Path $Reports "spine40_unity6000_probe_import_latest.log"

New-Item -ItemType Directory -Force -Path $WorkRoot, $Reports | Out-Null

$BaseResolved = (Resolve-Path $Base).Path
$ProbeParent = (Resolve-Path $WorkRoot).Path
if (-not $ProbeParent.StartsWith($BaseResolved, [System.StringComparison]::OrdinalIgnoreCase)) {
  throw "Probe work root is outside base folder: $ProbeParent"
}

if (-not (Test-Path -LiteralPath $SourceProject)) {
  throw "Source Unity project not found: $SourceProject"
}
if (-not (Test-Path -LiteralPath $VendorPackage)) {
  throw "Spine unitypackage not found: $VendorPackage"
}
if (-not (Test-Path -LiteralPath $UnityExe)) {
  throw "Unity editor not found: $UnityExe"
}

Write-Host "[GirlsWarRestore] Source project: $SourceProject"
Write-Host "[GirlsWarRestore] Probe project:  $ProbeProject"
Write-Host "[GirlsWarRestore] Package:        $VendorPackage"
Write-Host "[GirlsWarRestore] Unity:          $UnityExe"
Write-Host "[GirlsWarRestore] Log:            $LatestLog"

New-Item -ItemType Directory -Force -Path $ProbeProject | Out-Null

& robocopy $SourceProject $ProbeProject /E /XD Library Temp obj Logs .vs /XF *.csproj *.sln /NFL /NDL /NJH /NJS /NP
$CopyCode = $LASTEXITCODE
if ($CopyCode -gt 7) {
  throw "Robocopy failed with exit code $CopyCode"
}

Set-Content -LiteralPath $LatestProbeFile -Value $ProbeProject -Encoding UTF8

$UnityProcessCode = 0
& $UnityExe `
  -batchmode `
  -nographics `
  -quit `
  -accept-apiupdate `
  -projectPath $ProbeProject `
  -importPackage $VendorPackage `
  -logFile $LatestLog

$UnityProcessCode = $LASTEXITCODE
$UnityLogReturnCode = $null
if (Test-Path -LiteralPath $LatestLog) {
  $ReturnLine = Select-String -LiteralPath $LatestLog -Pattern "Application will terminate with return code ([0-9]+)" | Select-Object -Last 1
  if ($ReturnLine -and $ReturnLine.Matches.Count -gt 0) {
    $UnityLogReturnCode = [int]$ReturnLine.Matches[0].Groups[1].Value
  }
}
$EffectiveUnityCode = if ($null -ne $UnityLogReturnCode) { $UnityLogReturnCode } else { $UnityProcessCode }
$Result = [ordered]@{
  generated_at = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
  base = $Base
  source_project = $SourceProject
  probe_project = $ProbeProject
  unity_exe = $UnityExe
  unitypackage = $VendorPackage
  log = $LatestLog
  robocopy_exit_code = $CopyCode
  unity_process_exit_code = $UnityProcessCode
  unity_log_return_code = $UnityLogReturnCode
  unity_exit_code = $EffectiveUnityCode
}
$Result | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath $LatestResultFile -Encoding UTF8

Write-Host "[GirlsWarRestore] Probe import finished with Unity process exit code $UnityProcessCode"
Write-Host "[GirlsWarRestore] Probe import log return code $UnityLogReturnCode"
Write-Host "[GirlsWarRestore] Effective Unity exit code $EffectiveUnityCode"
Write-Host "[GirlsWarRestore] Result: $LatestResultFile"
exit $EffectiveUnityCode
