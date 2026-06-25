$ErrorActionPreference = "Stop"

$Base = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
$Tools = Join-Path $Base "_restore_tools"
$WorkRoot = Join-Path $Tools "work"
$LatestProbeFile = Join-Path $WorkRoot "spine40_unity6000_probe_latest.txt"
$LatestResultFile = Join-Path $WorkRoot "spine40_hero1001_import_latest_result.json"
$Reports = Join-Path $Base "reports\maininterface"
$LatestLog = Join-Path $Reports "spine40_hero1001_import_latest.log"
$Template = Join-Path $Tools "templates\GirlsWarSpineProbeHeroImporter.cs"
$UnityExe = "C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe"
$RawSource = Join-Path $Base "girlswar_maininterface_unity\Assets\RestoreData\hero1001_spine_source_raw"

if (-not (Test-Path -LiteralPath $LatestProbeFile)) {
  throw "Probe project pointer not found. Run 55_RUN_SPINE40_PROBE_IMPORT.cmd first."
}
if (-not (Test-Path -LiteralPath $Template)) {
  throw "Probe importer template not found: $Template"
}
if (-not (Test-Path -LiteralPath $UnityExe)) {
  throw "Unity editor not found: $UnityExe"
}
if (-not (Test-Path -LiteralPath $RawSource)) {
  throw "Raw hero source not found. Run 61_EXTRACT_HERO1001_SPINE_RAW_TEXTASSETS.cmd first: $RawSource"
}

$ProbeProject = (Get-Content -LiteralPath $LatestProbeFile -Encoding UTF8).Trim([char]0xFEFF).Trim()
if (-not (Test-Path -LiteralPath $ProbeProject)) {
  throw "Probe project not found: $ProbeProject"
}

$BaseResolved = (Resolve-Path $Base).Path
$ProbeResolved = (Resolve-Path $ProbeProject).Path
if (-not $ProbeResolved.StartsWith($BaseResolved, [System.StringComparison]::OrdinalIgnoreCase)) {
  throw "Probe project is outside base folder: $ProbeResolved"
}

$EditorDir = Join-Path $ProbeProject "Assets\Editor"
$ProbeImporter = Join-Path $EditorDir "GirlsWarSpineProbeHeroImporter.cs"
$ProbeRawDest = Join-Path $ProbeProject "Assets\RestoreData\hero1001_spine_source_raw"
New-Item -ItemType Directory -Force -Path $EditorDir, $Reports | Out-Null
Copy-Item -LiteralPath $Template -Destination $ProbeImporter -Force
Copy-Item -LiteralPath $RawSource -Destination (Split-Path -Parent $ProbeRawDest) -Recurse -Force

Write-Host "[GirlsWarRestore] Probe project: $ProbeProject"
Write-Host "[GirlsWarRestore] Hero importer: $ProbeImporter"
Write-Host "[GirlsWarRestore] Raw source: $RawSource"
Write-Host "[GirlsWarRestore] Log: $LatestLog"

$UnityProcessCode = 0
& $UnityExe `
  -batchmode `
  -nographics `
  -quit `
  -accept-apiupdate `
  -projectPath $ProbeProject `
  -executeMethod GirlsWarRestore.SpineProbeHeroImporter.ImportHero1001 `
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
  probe_project = $ProbeProject
  unity_exe = $UnityExe
  probe_importer = $ProbeImporter
  log = $LatestLog
  unity_process_exit_code = $UnityProcessCode
  unity_log_return_code = $UnityLogReturnCode
  unity_exit_code = $EffectiveUnityCode
}
$Result | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath $LatestResultFile -Encoding UTF8

Write-Host "[GirlsWarRestore] Hero 1001 import finished with Unity process exit code $UnityProcessCode"
Write-Host "[GirlsWarRestore] Hero 1001 import log return code $UnityLogReturnCode"
Write-Host "[GirlsWarRestore] Effective Unity exit code $EffectiveUnityCode"
Write-Host "[GirlsWarRestore] Result: $LatestResultFile"
exit $EffectiveUnityCode
