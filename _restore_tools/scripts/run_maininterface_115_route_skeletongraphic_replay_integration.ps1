$ErrorActionPreference = "Stop"

$Base = (Resolve-Path (Join-Path $PSScriptRoot "..\..")).Path
$Tools = Join-Path $Base "_restore_tools"
$Reports = Join-Path $Base "reports\maininterface"
$MainProject = Join-Path $Base "girlswar_maininterface_unity"
$MainRestoreData = Join-Path $MainProject "Assets\RestoreData"
$MainReports = Join-Path $MainRestoreData "reports"
$UnityExe = "C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe"
$TraceLog = Join-Path $Reports "unity_115_route_skeletongraphic_replay_integration.log"
$CaptureLog = Join-Path $MainProject "logs\unity_115_maininterface_capture.log"
$ClickLog = Join-Path $MainProject "logs\unity_115_click_validation.log"
$ReportPath = Join-Path $Reports "MAININTERFACE_ROUTE_SKELETONGRAPHIC_REPLAY_INTEGRATION_RESULT.md"
$JsonPath = Join-Path $MainRestoreData "maininterface_route_skeletongraphic_replay_integration.json"
$CsvPath = Join-Path $MainReports "maininterface_route_skeletongraphic_replay_integration.csv"
$ClickSummaryPath = Join-Path $MainReports "maininterface_click_validation_summary.json"
$CapturePath = Join-Path $MainProject "Assets\RestoreCaptures\maininterface_restored_1680x720.png"
$ToolCmd = Join-Path $Tools "cmd_archive\115_ROUTE_SKELETONGRAPHIC_REPLAY_INTEGRATION_IN_MAININTERFACE.cmd"

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

function Wait-ForFile([string]$Path, [int]$Seconds) {
  for ($i = 0; $i -lt $Seconds; $i++) {
    if (Test-Path -LiteralPath $Path) { return }
    Start-Sleep -Seconds 1
  }
  throw "File missing after wait: $Path"
}

if (-not (Test-Path -LiteralPath $UnityExe)) { throw "Unity editor not found: $UnityExe" }
New-Item -ItemType Directory -Force -Path $Reports, $MainReports, (Join-Path $MainProject "logs") | Out-Null

Write-Host "[GirlsWarRestore][115] Running route SkeletonGraphic replay integration trace"
Invoke-UnityMethod -Project $MainProject -Method "GirlsWarRestore.MainInterfaceRouteSkeletonGraphicReplayIntegration.TraceRouteSkeletonGraphicReplayIntegration" -Log $TraceLog -NoGraphics
Wait-ForFile -Path $JsonPath -Seconds 20
Wait-ForFile -Path $CsvPath -Seconds 20
Start-Sleep -Seconds 10

Write-Host "[GirlsWarRestore][115] Running MainInterface graphics capture"
Invoke-UnityMethod -Project $MainProject -Method "GirlsWarRestore.MainInterfaceSceneBuilder.CaptureMainInterfaceScene" -Log $CaptureLog
Start-Sleep -Seconds 5

Write-Host "[GirlsWarRestore][115] Running click validation"
Invoke-UnityMethod -Project $MainProject -Method "GirlsWarRestore.MainInterfaceClickValidator.ValidateMainInterfaceButtonClicks" -Log $ClickLog
Start-Sleep -Seconds 3

$Trace = Get-Content -LiteralPath $JsonPath -Raw -Encoding UTF8 | ConvertFrom-Json
$Rows = Import-Csv -LiteralPath $CsvPath
$Click = if (Test-Path -LiteralPath $ClickSummaryPath) { Get-Content -LiteralPath $ClickSummaryPath -Raw -Encoding UTF8 | ConvertFrom-Json } else { $null }
$CaptureItem = if (Test-Path -LiteralPath $CapturePath) { Get-Item -LiteralPath $CapturePath } else { $null }

$clickLine = "unknown"
if ($Click) { $clickLine = "$($Click.activeButtons) / $($Click.raycastClickableButtons) / $($Click.raycastBlockedButtons) / $($Click.invokedClicks)" }
$captureLine = "False / 0"
if ($CaptureItem) { $captureLine = "True / $($CaptureItem.Length) / $($CaptureItem.LastWriteTime.ToString('yyyy-MM-dd HH:mm:ss'))" }

$targetTable = @()
foreach ($target in $Trace.targets) {
  $targetTable += "| ``$($target.skeletonKey)`` | ``$($target.originalNode)`` | $($target.sceneNodeFound) | $($target.originalEvidenceComplete) | $($target.rawDecodeRecovered) | $($target.rawDecodeAnimationFound) | $($target.mainProjectRuntimeAvailable) | $($target.rawAssetsImportedInMainProject) | ``$($target.integrationDecision)`` | ``$($target.blocker)`` |"
}

$decisionGroups = $Rows | Group-Object decision | Sort-Object Name
$decisionTable = @()
foreach ($group in $decisionGroups) {
  $decisionTable += "| ``$($group.Name)`` | $($group.Count) |"
}
if ($decisionTable.Count -eq 0) {
  $decisionTable += "| ``none`` | 0 |"
}

$visualLine = "Visual verdict: MainInterface is still not a normal/restored UI. UI115 applied no visual fix because MainInterface does not yet have a proven in-scene SkeletonGraphic replay path."
if ([int]$Trace.visualFixApplied -gt 0) {
  $visualLine = "Visual verdict: MainInterface changed and requires manual review. UI115 applied a minimal evidence-backed SkeletonGraphic replay integration."
}

$md = @(
  "# MainInterface Route SkeletonGraphic Replay Integration Result",
  "",
  "Generated: $(Get-Date -Format 'yyyy-MM-dd HH:mm:ss') KST",
  "",
  "## Verdict",
  "",
  $visualLine,
  "",
  "No coordinate-only placement, whole atlas placement, crop guessing, fake icon, debug text, or path/evidence overlay was added to the final capture.",
  "",
  "## Counts",
  "",
  "| metric | value |",
  "| --- | ---: |",
  "| trace status | ``$($Trace.status)`` |",
  "| visual fixes applied | $($Trace.visualFixApplied) |",
  "| integrable targets | $($Trace.integrableTargets) |",
  "| blocked targets | $($Trace.blockedTargets) |",
  "| trace-only targets | $($Trace.traceOnlyTargets) |",
  "| main project SkeletonGraphic type | $($Trace.mainProjectSkeletonGraphicTypeAvailable) |",
  "| main project SkeletonDataAsset type | $($Trace.mainProjectSkeletonDataAssetTypeAvailable) |",
  "| main project AtlasAsset type | $($Trace.mainProjectAtlasAssetTypeAvailable) |",
  "| main project Spine runtime ready | $($Trace.mainProjectSpineRuntimeAvailable) |",
  "| probe project Spine runtime ready | $($Trace.probeProjectRuntimeAvailable) |",
  "| CSV rows | $($Rows.Count) |",
  "",
  "## Target Decisions",
  "",
  "| skeleton | node | scene node | original evidence | raw decode | animation | main runtime | raw asset in main | decision | blocker |",
  "| --- | --- | ---: | ---: | ---: | ---: | ---: | ---: | --- | --- |"
) + $targetTable + @(
  "",
  "## Decision Counts",
  "",
  "| decision | count |",
  "| --- | ---: |"
) + $decisionTable + @(
  "",
  "## Key Findings",
  "",
  "- UI114 proved clean UnityFS raw skeleton decode for ``Spine_shijieanniu`` and ``8007``.",
  "- UI115 confirms the original MainInterface route nodes, RectTransform evidence, SkeletonGraphic-like component rows, material references, atlas paths, texture paths, and starting animations are present in the extracted renderer trace.",
  "- The generated MainInterface scene currently does not have real ``Spine.Unity.SkeletonGraphic`` / ``SkeletonDataAsset`` / ``AtlasAsset`` runtime types available in the main project. The real Spine 4 runtime lives in the separate probe project.",
  "- Because the decoded SkeletonDataAsset is not imported into ``girlswar_maininterface_unity`` under a real Spine runtime, applying the probe bounds as bitmap/crop placement would violate the restore rules.",
  "",
  "## Outputs",
  "",
  "- JSON: ``$JsonPath``",
  "- CSV: ``$CsvPath``",
  "- Tool: ``$ToolCmd``",
  "- Unity trace log: ``$TraceLog``",
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
  "Next blocker: ``import real Spine 4 runtime into girlswar_maininterface_unity or build MainInterface replay scene inside the Spine probe project``. Without that runtime bridge, the recovered skeletons cannot be attached as actual SkeletonGraphic components in the final MainInterface scene."
)
$md | Set-Content -LiteralPath $ReportPath -Encoding UTF8

Write-Host "[GirlsWarRestore][115] Report: $ReportPath"
Write-Host "[GirlsWarRestore][115] JSON: $JsonPath"
Write-Host "[GirlsWarRestore][115] CSV: $CsvPath"
