$ErrorActionPreference = "Stop"

$Base = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
$Tools = Join-Path $Base "_restore_tools"
$WorkRoot = Join-Path $Tools "work"
$LatestProbeFile = Join-Path $WorkRoot "spine40_unity6000_probe_latest.txt"
$Reports = Join-Path $Base "reports\maininterface"
$MainProject = Join-Path $Base "girlswar_maininterface_unity"
$MainRestoreData = Join-Path $MainProject "Assets\RestoreData"
$MainReports = Join-Path $MainRestoreData "reports"
$Template = Join-Path $Tools "templates\GirlsWarSpineProbeRouteClusterTransform.cs"
$UnityExe = "C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe"
$ProbeLog = Join-Path $Reports "unity_113_spine_route_cluster_transform_probe.log"
$CaptureLog = Join-Path $MainProject "logs\unity_113_maininterface_capture.log"
$ClickLog = Join-Path $MainProject "logs\unity_113_click_validation.log"
$ReportPath = Join-Path $Reports "MAININTERFACE_ROUTE_SPINE_SLOT_BONE_ANIMATION_TRANSFORM_RESULT.md"
$JsonPath = Join-Path $MainRestoreData "maininterface_route_spine_slot_bone_animation_transform.json"
$CsvPath = Join-Path $MainReports "maininterface_route_spine_slot_bone_animation_transform.csv"
$ClickSummaryPath = Join-Path $MainReports "maininterface_click_validation_summary.json"
$CapturePath = Join-Path $MainProject "Assets\RestoreCaptures\maininterface_restored_1680x720.png"

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

$ProbeEditorScript = Join-Path $ProbeProject "Assets\Editor\GirlsWarSpineProbeRouteClusterTransform.cs"
Copy-Item -LiteralPath $Template -Destination $ProbeEditorScript -Force

$ProbeSourceRoot = Join-Path $ProbeProject "Assets\RestoreData\route_spine_source"
$ShijieDest = Join-Path $ProbeSourceRoot "maininterface_ext_8"
$NpcDest = Join-Path $ProbeSourceRoot "npcprefabandres_8007"
New-Item -ItemType Directory -Force -Path $ShijieDest, $NpcDest | Out-Null

$ShijieBundle = Join-Path $Base "girlswar_merged_extracted\extracted\unity\bundles\b_35f69f1e4224c83e"
$NpcBundle = Join-Path $Base "girlswar_merged_extracted\extracted\unity\bundles\b_df52239564024098"
$Sources = @(
  @{ From = Join-Path $ShijieBundle "images\T\-1569618029946744867_Spine_shijieanniu.png"; To = Join-Path $ShijieDest "Spine_shijieanniu.png" },
  @{ From = Join-Path $ShijieBundle "textassets\4125696125331628132_Spine_shijieanniu.atlas.txt"; To = Join-Path $ShijieDest "Spine_shijieanniu.atlas.txt" },
  @{ From = Join-Path $ShijieBundle "textassets\-6625475740475696418_Spine_shijieanniu.skel.txt"; To = Join-Path $ShijieDest "Spine_shijieanniu.skel.bytes" },
  @{ From = Join-Path $NpcBundle "images\T\1969165562093376026_8007.png"; To = Join-Path $NpcDest "8007.png" },
  @{ From = Join-Path $NpcBundle "textassets\-5959284149285428779_8007.atlas.txt"; To = Join-Path $NpcDest "8007.atlas.txt" },
  @{ From = Join-Path $NpcBundle "textassets\5717351362711680443_8007.skel.txt"; To = Join-Path $NpcDest "8007.skel.bytes" }
)

foreach ($item in $Sources) {
  if (-not (Test-Path -LiteralPath $item.From)) { throw "Missing source asset: $($item.From)" }
  Copy-Item -LiteralPath $item.From -Destination $item.To -Force
}

Write-Host "[GirlsWarRestore][113] Probe project: $ProbeProject"
Write-Host "[GirlsWarRestore][113] Probe script: $ProbeEditorScript"
Write-Host "[GirlsWarRestore][113] Probe log: $ProbeLog"

& $UnityExe -batchmode -nographics -quit -accept-apiupdate -projectPath $ProbeProject -executeMethod GirlsWarRestore.SpineProbeRouteClusterTransform.TraceRouteCluster -logFile $ProbeLog
$ProbeProcessExit = $LASTEXITCODE
$ProbeLogReturnCode = $null
if (Test-Path -LiteralPath $ProbeLog) {
  $ReturnLine = Select-String -LiteralPath $ProbeLog -Pattern "Application will terminate with return code ([0-9]+)" | Select-Object -Last 1
  if ($ReturnLine -and $ReturnLine.Matches.Count -gt 0) {
    $ProbeLogReturnCode = [int]$ReturnLine.Matches[0].Groups[1].Value
  }
}
$ProbeExit = if ($null -ne $ProbeLogReturnCode) { $ProbeLogReturnCode } elseif ($null -ne $ProbeProcessExit) { $ProbeProcessExit } else { 0 }
if ($ProbeExit -ne 0) { throw "Spine route transform probe failed with exit code $ProbeExit. Log: $ProbeLog" }

$ProbeJson = Join-Path $ProbeProject "Assets\RestoreData\reports\maininterface_route_spine_slot_bone_animation_transform_probe.json"
$ProbeCsv = Join-Path $ProbeProject "Assets\RestoreData\reports\maininterface_route_spine_slot_bone_animation_transform_probe.csv"
if (-not (Test-Path -LiteralPath $ProbeJson)) { throw "Probe JSON missing: $ProbeJson" }
if (-not (Test-Path -LiteralPath $ProbeCsv)) { throw "Probe CSV missing: $ProbeCsv" }
Copy-Item -LiteralPath $ProbeJson -Destination $JsonPath -Force
Copy-Item -LiteralPath $ProbeCsv -Destination $CsvPath -Force

Write-Host "[GirlsWarRestore][113] Running MainInterface graphics capture"
& $UnityExe -batchmode -quit -projectPath $MainProject -executeMethod GirlsWarRestore.MainInterfaceSceneBuilder.CaptureMainInterfaceScene -logFile $CaptureLog
$CaptureProcessExit = $LASTEXITCODE
$CaptureLogReturnCode = $null
if (Test-Path -LiteralPath $CaptureLog) {
  $ReturnLine = Select-String -LiteralPath $CaptureLog -Pattern "Application will terminate with return code ([0-9]+)" | Select-Object -Last 1
  if ($ReturnLine -and $ReturnLine.Matches.Count -gt 0) {
    $CaptureLogReturnCode = [int]$ReturnLine.Matches[0].Groups[1].Value
  }
}
$CaptureExit = if ($null -ne $CaptureLogReturnCode) { $CaptureLogReturnCode } elseif ($null -ne $CaptureProcessExit) { $CaptureProcessExit } else { 0 }
if ($CaptureExit -ne 0) { throw "MainInterface capture failed with exit code $CaptureExit. Log: $CaptureLog" }
Start-Sleep -Seconds 5

Write-Host "[GirlsWarRestore][113] Running click validation"
& $UnityExe -batchmode -quit -projectPath $MainProject -executeMethod GirlsWarRestore.MainInterfaceClickValidator.ValidateMainInterfaceButtonClicks -logFile $ClickLog
$ClickProcessExit = $LASTEXITCODE
$ClickLogReturnCode = $null
if (Test-Path -LiteralPath $ClickLog) {
  $ReturnLine = Select-String -LiteralPath $ClickLog -Pattern "Application will terminate with return code ([0-9]+)" | Select-Object -Last 1
  if ($ReturnLine -and $ReturnLine.Matches.Count -gt 0) {
    $ClickLogReturnCode = [int]$ReturnLine.Matches[0].Groups[1].Value
  }
}
$ClickExit = if ($null -ne $ClickLogReturnCode) { $ClickLogReturnCode } elseif ($null -ne $ClickProcessExit) { $ClickProcessExit } else { 0 }
if ($ClickExit -ne 0 -and (Test-Path -LiteralPath $ClickLog)) {
  Start-Sleep -Seconds 5
  $ReturnLine = Select-String -LiteralPath $ClickLog -Pattern "Application will terminate with return code ([0-9]+)" | Select-Object -Last 1
  if ($ReturnLine -and $ReturnLine.Matches.Count -gt 0) {
    $ClickExit = [int]$ReturnLine.Matches[0].Groups[1].Value
  }
}
if ($ClickExit -ne 0) { throw "Click validation failed with exit code $ClickExit. Log: $ClickLog" }
Start-Sleep -Seconds 3

$Probe = Get-Content -LiteralPath $JsonPath -Raw -Encoding UTF8 | ConvertFrom-Json
$Rows = Import-Csv -LiteralPath $CsvPath
$Click = if (Test-Path -LiteralPath $ClickSummaryPath) { Get-Content -LiteralPath $ClickSummaryPath -Raw -Encoding UTF8 | ConvertFrom-Json } else { $null }
$CaptureItem = if (Test-Path -LiteralPath $CapturePath) { Get-Item -LiteralPath $CapturePath } else { $null }

$DecisionCounts = @{}
foreach ($row in $Rows) {
  $key = [string]$row.decision
  if (-not $DecisionCounts.ContainsKey($key)) { $DecisionCounts[$key] = 0 }
  $DecisionCounts[$key]++
}

$cloudRows = @($Rows | Where-Object { $_.attachmentName -match 'yun|yun2' -or $_.slotName -match 'yun|yun2' })
$npcRows = @($Rows | Where-Object { $_.skeletonKey -eq '8007' })
$targetRows = @($Rows | Where-Object { $_.targetRelevance -eq 'target_route_attachment' })
$runtimeEvidenceSentence = if ($Rows.Count -gt 0) {
  "The Spine runtime probe produced attachment world-bounds rows, but the MainInterface scene still has no original SkeletonGraphic runtime replay or proven skeleton-space to UI-space mapping. No new visual fix was applied."
} else {
  "This probe did not produce attachment world-bounds rows. ``Spine_shijieanniu`` creates atlas/material/SkeletonDataAsset files but exposes empty runtime bones/slots/animations, while ``8007`` fails SkeletonBinary decode. Placing cloud/person bitmaps from this state would still be guessed placement."
}

$summaryTable = @()
foreach ($s in $Probe.summaries) {
  $summaryTable += "| ``$($s.key)`` | ``$($s.originalNode)`` | ``$($s.animation)`` | $($s.animationFound) | $($s.animationDuration) | $($s.boneCount) | $($s.slotCount) | $($s.visibleAttachmentRows) | $($s.targetAttachmentCount) | ``$($s.decision)`` |"
}

$decisionTable = @()
foreach ($key in ($DecisionCounts.Keys | Sort-Object)) {
  $decisionTable += "| ``$key`` | $($DecisionCounts[$key]) |"
}

$clickLine = "unknown"
if ($Click) {
  $clickLine = "$($Click.activeButtons) / $($Click.raycastClickableButtons) / $($Click.raycastBlockedButtons) / $($Click.invokedClicks)"
}

$captureLine = "False / 0"
if ($CaptureItem) {
  $captureLine = "True / $($CaptureItem.Length) / $($CaptureItem.LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss'))"
}

$md = @(
  "# MainInterface Route Spine Slot/Bone/Animation Transform Result",
  "",
  "Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') KST",
  "",
  "## Verdict",
  "",
  "Visual verdict: MainInterface is still not a normal/restored UI. UI113 attempted to open ``Spine_shijieanniu`` and ``8007`` through the existing Spine 4.0 probe, but no evidence-backed visual fix was applied to the MainInterface scene.",
  "",
  "$runtimeEvidenceSentence",
  "",
  "## Counts",
  "",
  "| metric | value |",
  "| --- | ---: |",
  "| probe status | ``$($Probe.status)`` |",
  "| visual fixes applied | ``$($Probe.visualFixApplied)`` |",
  "| total attachment rows | $($Rows.Count) |",
  "| target route attachment rows | $($targetRows.Count) |",
  "| cloud rows (``yun/yun2``) | $($cloudRows.Count) |",
  "| 8007 run pose rows | $($npcRows.Count) |",
  "",
  "## Skeleton Runtime Evidence",
  "",
  "| skeleton | original node | animation | found | duration | bones | slots | visible rows | target rows | decision |",
  "| --- | --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- |"
) + $summaryTable + @(
  "",
  "## Decision Counts",
  "",
  "| decision | count |",
  "| --- | ---: |"
) + $decisionTable + @(
  "",
  "## Key Findings",
  "",
  "- ``Spine_shijieanniu`` imported far enough to create atlas/material/SkeletonDataAsset files, but the runtime SkeletonData exposed ``0`` usable bones/slots/animations in this probe, so no ``yun/yun2`` slot transform was applied.",
  "- ``spine_xiaoren/8007`` preserved original node scale evidence ``0.5``, but its ``8007.skel.bytes`` fails Spine 4.0 SkeletonBinary decode with ``IndexOutOfRangeException``. It remains blocked rather than replaced by a whole texture.",
  "- No final-capture debug text, fake icon, whole atlas placement, or guessed cloud/person placement was added.",
  "",
  "## Outputs",
  "",
  "- JSON: ``$JsonPath``",
  "- CSV: ``$CsvPath``",
  "- Tool: ``$Tools\113_RESTORE_MAININTERFACE_ROUTE_SPINE_SLOT_BONE_ANIMATION_TRANSFORM.cmd``",
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
  "Next blocker: ``route SpineGraphic runtime replay / raw skeleton decode recovery``. The current extracted/imported skeleton data is not enough to place ``yun/yun2`` or ``spine_xiaoren/8007`` safely in the final capture."
)

$md | Set-Content -LiteralPath $ReportPath -Encoding UTF8
Write-Host "[GirlsWarRestore][113] Report: $ReportPath"
Write-Host "[GirlsWarRestore][113] JSON: $JsonPath"
Write-Host "[GirlsWarRestore][113] CSV: $CsvPath"
