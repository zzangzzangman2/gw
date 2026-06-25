$ErrorActionPreference = "Stop"

$Base = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
$Tools = Join-Path $Base "_restore_tools"
$WorkRoot = Join-Path $Tools "work"
$LatestProbeFile = Join-Path $WorkRoot "spine40_unity6000_probe_latest.txt"
$Reports = Join-Path $Base "reports\maininterface"
$MainProject = Join-Path $Base "girlswar_maininterface_unity"
$MainRestoreData = Join-Path $MainProject "Assets\RestoreData"
$MainReports = Join-Path $MainRestoreData "reports"
$Template = Join-Path $Tools "templates\GirlsWarSpineProbeRouteRawDecodeRecovery.cs"
$UnityExe = "C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe"
$ProbeLog = Join-Path $Reports "unity_114_route_raw_decode_recovery_probe.log"
$CaptureLog = Join-Path $MainProject "logs\unity_114_maininterface_capture.log"
$ClickLog = Join-Path $MainProject "logs\unity_114_click_validation.log"
$ReportPath = Join-Path $Reports "MAININTERFACE_ROUTE_SPINEGRAPHIC_RUNTIME_REPLAY_RAW_SKELETON_DECODE_RECOVERY_RESULT.md"
$JsonPath = Join-Path $MainRestoreData "maininterface_route_spinegraphic_runtime_replay_raw_skeleton_decode_recovery.json"
$CsvPath = Join-Path $MainReports "maininterface_route_spinegraphic_runtime_replay_raw_skeleton_decode_recovery.csv"
$ClickSummaryPath = Join-Path $MainReports "maininterface_click_validation_summary.json"
$CapturePath = Join-Path $MainProject "Assets\RestoreCaptures\maininterface_restored_1680x720.png"

function Get-UnityReturnCodeFromLog([string]$Path) {
  if (-not (Test-Path -LiteralPath $Path)) { return $null }
  $line = Select-String -LiteralPath $Path -Pattern "Application will terminate with return code ([0-9]+)" | Select-Object -Last 1
  if ($line -and $line.Matches.Count -gt 0) { return [int]$line.Matches[0].Groups[1].Value }
  return $null
}

function Invoke-UnityMethod([string]$Project, [string]$Method, [string]$Log, [switch]$NoGraphics) {
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
  if ($code -ne 0) { throw "Unity method failed: $Method exit=$code log=$Log" }
}

if (-not (Test-Path -LiteralPath $LatestProbeFile)) { throw "Spine probe project pointer not found: $LatestProbeFile" }
if (-not (Test-Path -LiteralPath $Template)) { throw "Probe template not found: $Template" }
if (-not (Test-Path -LiteralPath $UnityExe)) { throw "Unity editor not found: $UnityExe" }

$ProbeProject = (Get-Content -LiteralPath $LatestProbeFile -Encoding UTF8).Trim([char]0xFEFF).Trim()
if (-not (Test-Path -LiteralPath $ProbeProject)) { throw "Probe project not found: $ProbeProject" }

$BaseResolved = (Resolve-Path $Base).Path
$ProbeResolved = (Resolve-Path $ProbeProject).Path
if (-not $ProbeResolved.StartsWith($BaseResolved, [System.StringComparison]::OrdinalIgnoreCase)) {
  throw "Probe project is outside base folder: $ProbeResolved"
}

New-Item -ItemType Directory -Force -Path $Reports, $MainReports, (Join-Path $ProbeProject "Assets\Editor") | Out-Null
$ProbeScript = Join-Path $ProbeProject "Assets\Editor\GirlsWarSpineProbeRouteRawDecodeRecovery.cs"
Copy-Item -LiteralPath $Template -Destination $ProbeScript -Force

Write-Host "[GirlsWarRestore][114] Probe project: $ProbeProject"
Write-Host "[GirlsWarRestore][114] Probe script: $ProbeScript"
Write-Host "[GirlsWarRestore][114] Probe log: $ProbeLog"
Invoke-UnityMethod -Project $ProbeProject -Method "GirlsWarRestore.SpineProbeRouteRawDecodeRecovery.TraceRawDecodeRecovery" -Log $ProbeLog -NoGraphics
Start-Sleep -Seconds 3

$ProbeJson = Join-Path $ProbeProject "Assets\RestoreData\reports\maininterface_route_spinegraphic_runtime_replay_raw_skeleton_decode_recovery_probe.json"
$ProbeCsv = Join-Path $ProbeProject "Assets\RestoreData\reports\maininterface_route_spinegraphic_runtime_replay_raw_skeleton_decode_recovery_probe.csv"
if (-not (Test-Path -LiteralPath $ProbeJson)) { throw "Probe JSON missing: $ProbeJson" }
if (-not (Test-Path -LiteralPath $ProbeCsv)) { throw "Probe CSV missing: $ProbeCsv" }
Copy-Item -LiteralPath $ProbeJson -Destination $JsonPath -Force
Copy-Item -LiteralPath $ProbeCsv -Destination $CsvPath -Force

Write-Host "[GirlsWarRestore][114] Running MainInterface graphics capture"
Invoke-UnityMethod -Project $MainProject -Method "GirlsWarRestore.MainInterfaceSceneBuilder.CaptureMainInterfaceScene" -Log $CaptureLog
Start-Sleep -Seconds 5
Write-Host "[GirlsWarRestore][114] Running click validation"
Invoke-UnityMethod -Project $MainProject -Method "GirlsWarRestore.MainInterfaceClickValidator.ValidateMainInterfaceButtonClicks" -Log $ClickLog
Start-Sleep -Seconds 3

$Probe = Get-Content -LiteralPath $JsonPath -Raw -Encoding UTF8 | ConvertFrom-Json
$Rows = Import-Csv -LiteralPath $CsvPath
$Click = if (Test-Path -LiteralPath $ClickSummaryPath) { Get-Content -LiteralPath $ClickSummaryPath -Raw -Encoding UTF8 | ConvertFrom-Json } else { $null }
$CaptureItem = if (Test-Path -LiteralPath $CapturePath) { Get-Item -LiteralPath $CapturePath } else { $null }

$decodeRecovered = @($Probe.summaries | Where-Object { $_.decodeRecovered -eq $true }).Count
$visualFixApplied = @($Probe.summaries | Where-Object { $_.visualFixApplied -eq $true }).Count
$matchingTextAssets = 0
$exportedRawCandidates = 0
foreach ($s in $Probe.summaries) {
  $matchingTextAssets += [int]$s.matchingTextAssetCount
  $exportedRawCandidates += [int]$s.exportedRawCandidateCount
}
$bundleCandidateRows = @($Rows | Where-Object { $_.decision -eq "matching_textasset_candidate" }).Count
$exceptionRows = @($Rows | Where-Object { $_.decision -match "exception|blocked" }).Count
$attachmentBoundsRows = @($Rows | Where-Object { $_.kind -eq "spine_attachment_bounds" }).Count

$summaryTable = @()
foreach ($s in $Probe.summaries) {
  $summaryTable += "| ``$($s.key)`` | ``$($s.originalNode)`` | $($s.matchingTextAssetCount) | $($s.exportedRawCandidateCount) | $($s.importAttempted) | $($s.decodeRecovered) | $($s.boneCount) | $($s.slotCount) | $($s.animationCount) | ``$($s.decision)`` | ``$($s.blocker)`` |"
}

$clickLine = "unknown"
if ($Click) { $clickLine = "$($Click.activeButtons) / $($Click.raycastClickableButtons) / $($Click.raycastBlockedButtons) / $($Click.invokedClicks)" }
$captureLine = "False / 0"
if ($CaptureItem) { $captureLine = "True / $($CaptureItem.Length) / $($CaptureItem.LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss'))" }

$verdictLine = "Visual verdict: MainInterface is still not a normal/restored UI. UI114 did not apply a visual fix because raw skeleton decode was not recovered strongly enough for evidence-backed route SpineGraphic replay."
if ($decodeRecovered -gt 0) {
  $verdictLine = "Visual verdict: MainInterface is still not a normal/restored UI. UI114 recovered at least one runtime SkeletonData decode in probe, but no MainInterface visual fix was applied without a proven in-scene SkeletonGraphic replay path."
}

$md = @(
  "# MainInterface Route SpineGraphic Runtime Replay / Raw Skeleton Decode Recovery Result",
  "",
  "Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') KST",
  "",
  "## Verdict",
  "",
  $verdictLine,
  "",
  "No fake icon, debug/path text, whole atlas placement, guessed crop, or guessed cloud/person placement was added to the final capture.",
  "",
  "## Counts",
  "",
  "| metric | value |",
  "| --- | ---: |",
  "| probe status | ``$($Probe.status)`` |",
  "| visual fixes applied | $visualFixApplied |",
  "| decode recovered summaries | $decodeRecovered |",
  "| matching TextAsset candidates | $matchingTextAssets |",
  "| exported raw candidates | $exportedRawCandidates |",
  "| CSV rows | $($Rows.Count) |",
  "| matching bundle candidate rows | $bundleCandidateRows |",
  "| runtime attachment bounds rows | $attachmentBoundsRows |",
  "| blocked/exception rows | $exceptionRows |",
  "",
  "## Skeleton Decode Recovery Summary",
  "",
  "| skeleton | node | matching TextAssets | exported raw | import attempted | decode recovered | bones | slots | animations | decision | blocker |",
  "| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | ---: | --- | --- |"
) + $summaryTable + @(
  "",
  "## Key Findings",
  "",
  "- The probe loaded clean UnityFS bundles directly through Unity ``AssetBundle.LoadFromFile`` and compared bundle ``TextAsset.bytes`` candidates against the existing extracted ``.skel.txt`` / ``.atlas.txt`` files.",
  "- ``Spine_shijieanniu`` and ``8007`` are considered decode-recovered only when the clean bundle ``TextAsset.bytes`` import produces nonzero bones/slots and the requested animation is present.",
  "- Runtime attachment bounds rows are probe evidence only. They were not converted into MainInterface bitmap placement because the final scene still needs an original ``SkeletonGraphic`` replay path or a proven skeleton-space to UI-space transform.",
  "",
  "## Outputs",
  "",
  "- JSON: ``$JsonPath``",
  "- CSV: ``$CsvPath``",
  "- Tool: ``$Tools\114_ROUTE_SPINEGRAPHIC_RUNTIME_REPLAY_RAW_SKELETON_DECODE_RECOVERY.cmd``",
  "- Probe log: ``$ProbeLog``",
  "",
  "## Verification",
  "",
  "| check | result |",
  "| --- | --- |",
  "| graphics capture | ``$CapturePath`` |",
  "| capture exists/size/time | ``$captureLine`` |",
  "| click validation generated | ``$(if ($Click) { $Click.generatedAt } else { 'unknown' })`` |",
  "| active/clickable/blocked/invoked | ``$clickLine`` |",
  "",
  "## Remaining Blocker",
  "",
  "Next blocker: ``route SkeletonGraphic replay integration in MainInterface``. The raw decode and runtime bounds can now feed a real SkeletonGraphic/mesh replay, but final visual placement should not be done by guessed bitmap coordinates."
)
$md | Set-Content -LiteralPath $ReportPath -Encoding UTF8

Write-Host "[GirlsWarRestore][114] Report: $ReportPath"
Write-Host "[GirlsWarRestore][114] JSON: $JsonPath"
Write-Host "[GirlsWarRestore][114] CSV: $CsvPath"
