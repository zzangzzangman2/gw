$ErrorActionPreference = "Stop"

$Base = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
$Tools = Join-Path $Base "_restore_tools"
$WorkRoot = Join-Path $Tools "work"
$LatestProbeFile = Join-Path $WorkRoot "spine40_unity6000_probe_latest.txt"
$LatestResultFile = Join-Path $WorkRoot "spine40_hero1001_attach_capture_latest_result.json"
$Reports = Join-Path $Base "reports\maininterface"
$ReportCaptureDir = Join-Path $Reports "captures"
$LatestLog = Join-Path $Reports "spine40_hero1001_attach_capture_latest.log"
$Template = Join-Path $Tools "templates\GirlsWarSpineProbeHeroAttachCapture.cs"
$ImportScript = Join-Path $Tools "scripts\run_spine40_hero1001_import.ps1"
$UnityExe = "C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe"
$RawSource = Join-Path $Base "girlswar_maininterface_unity\Assets\RestoreData\hero1001_spine_source_raw"
$ProbeJsonRelative = "Assets\RestoreData\reports\maininterface_spine40_hero1001_attach_capture_result.json"
$ProbeFullRelative = "Assets\RestoreCaptures\maininterface_spine_hero1001_probe_1680x720.png"
$ProbeHeroOnlyRelative = "Assets\RestoreCaptures\maininterface_spine_hero1001_probe_hero_only_1680x720.png"
$ReportMd = Join-Path $Reports "MAININTERFACE_SPINE40_HERO1001_ATTACH_CAPTURE_RESULT.md"
$ReportsJson = Join-Path $Reports "maininterface_spine40_hero1001_attach_capture_result.json"
$MainDataReports = Join-Path $Base "girlswar_maininterface_unity\Assets\RestoreData\reports"
$MainDataJson = Join-Path $MainDataReports "maininterface_spine40_hero1001_attach_capture_result.json"

if (-not (Test-Path -LiteralPath $LatestProbeFile)) {
  throw "Probe project pointer not found. Run 55_RUN_SPINE40_PROBE_IMPORT.cmd first."
}
if (-not (Test-Path -LiteralPath $Template)) {
  throw "Probe attach/capture template not found: $Template"
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
$ProbeAttachScript = Join-Path $EditorDir "GirlsWarSpineProbeHeroAttachCapture.cs"
$ProbeRawDest = Join-Path $ProbeProject "Assets\RestoreData\hero1001_spine_source_raw"
$ExpectedSkeleton = Join-Path $ProbeProject "Assets\RestoreData\hero1001_spine_source_raw\paintingprefabandres_1001\Painting_1001_SkeletonData.asset"
New-Item -ItemType Directory -Force -Path $EditorDir, $Reports, $ReportCaptureDir, $MainDataReports | Out-Null
Copy-Item -LiteralPath $Template -Destination $ProbeAttachScript -Force
Copy-Item -LiteralPath $RawSource -Destination (Split-Path -Parent $ProbeRawDest) -Recurse -Force

if (-not (Test-Path -LiteralPath $ExpectedSkeleton)) {
  if (-not (Test-Path -LiteralPath $ImportScript)) {
    throw "Hero 1001 SkeletonDataAsset is missing and import script was not found: $ImportScript"
  }
  Write-Host "[GirlsWarRestore] Hero 1001 SkeletonDataAsset missing in probe; importing first."
  & $ImportScript
  if ($LASTEXITCODE -ne 0) {
    throw "Hero 1001 import failed with exit code $LASTEXITCODE"
  }
}

Write-Host "[GirlsWarRestore] Probe project: $ProbeProject"
Write-Host "[GirlsWarRestore] Attach/capture script: $ProbeAttachScript"
Write-Host "[GirlsWarRestore] Log: $LatestLog"

$UnityProcessCode = 0
$UnityArgs = @(
  "-batchmode",
  "-quit",
  "-accept-apiupdate",
  "-projectPath", $ProbeProject,
  "-executeMethod", "GirlsWarRestore.SpineProbeHeroAttachCapture.AttachAndCaptureHero1001",
  "-logFile", $LatestLog
)
$UnityProcess = Start-Process -FilePath $UnityExe -ArgumentList $UnityArgs -Wait -PassThru -WindowStyle Hidden
$UnityProcessCode = $UnityProcess.ExitCode
$UnityLogReturnCode = $null
if (Test-Path -LiteralPath $LatestLog) {
  $ReturnLine = Select-String -LiteralPath $LatestLog -Pattern "Application will terminate with return code ([0-9]+)" | Select-Object -Last 1
  if ($ReturnLine -and $ReturnLine.Matches.Count -gt 0) {
    $UnityLogReturnCode = [int]$ReturnLine.Matches[0].Groups[1].Value
  }
}
$EffectiveUnityCode = if ($null -ne $UnityLogReturnCode) { $UnityLogReturnCode } else { $UnityProcessCode }

$ProbeJson = Join-Path $ProbeProject ($ProbeJsonRelative -replace "/", "\")
$ProbeFullCapture = Join-Path $ProbeProject ($ProbeFullRelative -replace "/", "\")
$ProbeHeroOnlyCapture = Join-Path $ProbeProject ($ProbeHeroOnlyRelative -replace "/", "\")
$ReportFullCapture = Join-Path $ReportCaptureDir "maininterface_spine_hero1001_probe_1680x720.png"
$ReportHeroOnlyCapture = Join-Path $ReportCaptureDir "maininterface_spine_hero1001_probe_hero_only_1680x720.png"

$Json = $null
for ($i = 0; $i -lt 20 -and -not (Test-Path -LiteralPath $ProbeJson); $i++) {
  Start-Sleep -Milliseconds 500
}
if (Test-Path -LiteralPath $ProbeJson) {
  Copy-Item -LiteralPath $ProbeJson -Destination $ReportsJson -Force
  Copy-Item -LiteralPath $ProbeJson -Destination $MainDataJson -Force
  $Json = Get-Content -LiteralPath $ProbeJson -Raw -Encoding UTF8 | ConvertFrom-Json
}
if (Test-Path -LiteralPath $ProbeFullCapture) {
  Copy-Item -LiteralPath $ProbeFullCapture -Destination $ReportFullCapture -Force
}
if (Test-Path -LiteralPath $ProbeHeroOnlyCapture) {
  Copy-Item -LiteralPath $ProbeHeroOnlyCapture -Destination $ReportHeroOnlyCapture -Force
}
Get-ChildItem -LiteralPath (Join-Path $ProbeProject "Assets\RestoreCaptures") -Filter "maininterface_spine_hero1001_probe_layer_*_1680x720.png" -ErrorAction SilentlyContinue |
  ForEach-Object {
    Copy-Item -LiteralPath $_.FullName -Destination (Join-Path $ReportCaptureDir $_.Name) -Force
  }
Get-ChildItem -LiteralPath (Join-Path $ProbeProject "Assets\RestoreCaptures") -Filter "maininterface_spine_hero1001_probe_variant_*_1680x720.png" -ErrorAction SilentlyContinue |
  ForEach-Object {
    Copy-Item -LiteralPath $_.FullName -Destination (Join-Path $ReportCaptureDir $_.Name) -Force
  }

$Result = [ordered]@{
  generated_at = (Get-Date).ToString("yyyy-MM-dd HH:mm:ss")
  base = $Base
  probe_project = $ProbeProject
  unity_exe = $UnityExe
  probe_attach_script = $ProbeAttachScript
  log = $LatestLog
  probe_json = $ProbeJson
  report_md = $ReportMd
  report_json = $ReportsJson
  full_capture = $ReportFullCapture
  hero_only_capture = $ReportHeroOnlyCapture
  unity_process_exit_code = $UnityProcessCode
  unity_log_return_code = $UnityLogReturnCode
  unity_exit_code = $EffectiveUnityCode
}
$Result | ConvertTo-Json -Depth 4 | Set-Content -LiteralPath $LatestResultFile -Encoding UTF8

$status = if ($Json) { [string]$Json.status } else { "missing_probe_result_json" }
$fullVisible = if ($Json) { [int]$Json.fullCapture.visiblePixelCount } else { 0 }
$heroVisible = if ($Json) { [int]$Json.heroOnlyCapture.visiblePixelCount } else { 0 }
$heroUnique = if ($Json) { [int]$Json.heroOnlyCapture.uniqueColorCount } else { 0 }
$verdict = if ($status -eq "hero1001_spine_rendered_in_probe" -and $heroVisible -gt 0) {
  "The isolated probe attached Hero 1001 through real Spine SkeletonGraphic components and rendered nonblank hero-only pixels."
} elseif ($Json) {
  "The probe ran, but the hero-only capture is still blank or incomplete. Check the Unity log and layer metrics before applying anything to the main restore project."
} else {
  "Unity did not produce the probe JSON result. Check the Unity log before continuing."
}

$LayerLines = @()
if ($Json) {
  foreach ($layer in $Json.layers) {
    $layerVisible = if ($layer.layerCapture) { [int]$layer.layerCapture.visiblePixelCount } else { 0 }
    $LayerLines += ("| ``{0}`` | ``{1}`` | {2} | {3} | {4} | {5} | {6} | {7} | {8} |" -f $layer.layerName, $layer.animation, $layer.bones, $layer.slots, $layer.animations, $layer.vertexCount, $layer.canvasRendererCount, $layerVisible, $layer.matchedBounds)
  }
}
if ($LayerLines.Count -eq 0) {
  $LayerLines += "| none |  | 0 | 0 | 0 | 0 | 0 | 0 | False |"
}

$VariantLines = @()
if ($Json -and $Json.variants) {
  foreach ($variant in $Json.variants) {
    $enabled = if ($variant.enabledGameObjects) { ($variant.enabledGameObjects -join ", ") } else { "" }
    $bounds = if ($variant.capture) {
      "$($variant.capture.boundsMinX),$($variant.capture.boundsMinY) - $($variant.capture.boundsMaxX),$($variant.capture.boundsMaxY)"
    } else {
      "missing"
    }
    $visible = if ($variant.capture) { [int]$variant.capture.visiblePixelCount } else { 0 }
    $unique = if ($variant.capture) { [int]$variant.capture.uniqueColorCount } else { 0 }
    $VariantLines += ("| ``{0}`` | ``{1}`` | {2} | {3} | {4} | ``{5}`` | ``{6}`` |" -f $variant.variantName, $variant.suffix, $variant.keepsNonHeroEnabled, $visible, $unique, $bounds, $enabled)
  }
}
if ($VariantLines.Count -eq 0) {
  $VariantLines += "| none |  |  | 0 | 0 | ``missing`` | ```` |"
}

$Md = @()
$Md += "# Spine 4.0 Hero 1001 Attach/Capture Result"
$Md += ""
$Md += "Generated: $((Get-Date).ToString("yyyy-MM-dd HH:mm:ss"))"
$Md += ""
$Md += "## Verdict"
$Md += ""
$Md += $verdict
$Md += ""
$Md += "## Run"
$Md += ""
$Md += "| item | value |"
$Md += "| --- | --- |"
$Md += "| status | ``$status`` |"
$Md += "| probe project | ``$ProbeProject`` |"
$Md += "| Unity exit code | ``$EffectiveUnityCode`` |"
$Md += "| Unity process exit code | ``$UnityProcessCode`` |"
$Md += "| Unity log return code | ``$UnityLogReturnCode`` |"
$Md += "| log | ``$LatestLog`` |"
$Md += "| probe scene | ``$($Json.probeScenePath)`` |"
$Md += "| homePara | ``$($Json.homePara)`` |"
$Md += ""
$Md += "## Captures"
$Md += ""
$Md += "| capture | copied path | visible pixels | unique colors | bounds |"
$Md += "| --- | --- | ---: | ---: | --- |"
if ($Json) {
  $fullBounds = "$($Json.fullCapture.boundsMinX),$($Json.fullCapture.boundsMinY) - $($Json.fullCapture.boundsMaxX),$($Json.fullCapture.boundsMaxY)"
  $heroBounds = "$($Json.heroOnlyCapture.boundsMinX),$($Json.heroOnlyCapture.boundsMinY) - $($Json.heroOnlyCapture.boundsMaxX),$($Json.heroOnlyCapture.boundsMaxY)"
  $Md += "| full MainInterface | ``$ReportFullCapture`` | $fullVisible | $($Json.fullCapture.uniqueColorCount) | ``$fullBounds`` |"
  $Md += "| hero only | ``$ReportHeroOnlyCapture`` | $heroVisible | $heroUnique | ``$heroBounds`` |"
} else {
  $Md += "| full MainInterface | ``$ReportFullCapture`` | 0 | 0 | ``missing`` |"
  $Md += "| hero only | ``$ReportHeroOnlyCapture`` | 0 | 0 | ``missing`` |"
}
$Md += ""
$Md += "## Layers"
$Md += ""
$Md += "| layer | animation | bones | slots | animations | main vertices | canvas renderers | layer visible pixels | matched bounds |"
$Md += "| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |"
$Md += $LayerLines
$Md += ""
$Md += "## Candidate Variants"
$Md += ""
$Md += "| variant | suffix | non-hero UI enabled | visible pixels | unique colors | bounds | enabled Spine objects |"
$Md += "| --- | --- | --- | ---: | ---: | --- | --- |"
$Md += $VariantLines
$Md += ""
$Md += "## Restore Meaning"
$Md += ""
$Md += "- This remains probe-only evidence; it does not modify the main Unity restore project."
$Md += '- The hero is attached as Spine `SkeletonGraphic` layers under `UI_heroSpine`, not as whole atlas PNG images.'
$Md += '- Do not port the same four-layer attach directly into the main restore project yet. `Painting_1001_back` is background-like evidence and can overpaint the home background that Lua loads separately.'
$Md += '- Visual QA result: `main_only` is the first apply candidate. `main_front_name` and `all_layers_with_back` overpaint the face, center UI, or separately loaded home background, so keep them conditional until the real home branch proves they are needed.'
$Md += ""
$Md += "## Generated Files"
$Md += ""
$Md += "- ``$ReportsJson``"
$Md += "- ``$ReportFullCapture``"
$Md += "- ``$ReportHeroOnlyCapture``"
$Md += "- ``$ReportCaptureDir\maininterface_spine_hero1001_probe_layer_*_1680x720.png``"
$Md += "- ``$ReportCaptureDir\maininterface_spine_hero1001_probe_variant_*_1680x720.png``"
$Md += "- ``$LatestLog``"

$Md -join "`r`n" | Set-Content -LiteralPath $ReportMd -Encoding UTF8

Write-Host "[GirlsWarRestore] Hero 1001 attach/capture finished with Unity process exit code $UnityProcessCode"
Write-Host "[GirlsWarRestore] Hero 1001 attach/capture log return code $UnityLogReturnCode"
Write-Host "[GirlsWarRestore] Effective Unity exit code $EffectiveUnityCode"
Write-Host "[GirlsWarRestore] Report: $ReportMd"
Write-Host "[GirlsWarRestore] Full capture: $ReportFullCapture"
Write-Host "[GirlsWarRestore] Hero-only capture: $ReportHeroOnlyCapture"
Write-Host "[GirlsWarRestore] Result: $LatestResultFile"
exit $EffectiveUnityCode
