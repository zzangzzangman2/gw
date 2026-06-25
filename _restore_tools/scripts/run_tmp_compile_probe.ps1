$ErrorActionPreference = "Stop"

$Base = "C:\Users\godho\Downloads\girlswar"
$Tools = Join-Path $Base "_restore_tools"
$Unity = "C:\Program Files\Unity\Hub\Editor\6000.4.9f1\Editor\Unity.exe"
$Stamp = Get-Date -Format "yyyyMMdd_HHmmss"
$Probe = Join-Path $Tools "work\tmp_unity6000_probe_$Stamp"
$ReportDir = Join-Path $Base "reports\maininterface"
$ProjectReportDir = Join-Path $Probe "Assets\RestoreData\reports"
$LogPath = Join-Path $Tools "logs\tmp_compile_probe_$Stamp.log"
$SummaryJson = Join-Path $Base "girlswar_maininterface_unity\Assets\RestoreData\reports\maininterface_tmp_compile_probe_summary.json"
$OutMd = Join-Path $ReportDir "MAININTERFACE_TMP_COMPILE_PROBE_RESULT.md"

function Write-Utf8NoBom {
  param(
    [Parameter(Mandatory = $true)][string]$Path,
    [Parameter(Mandatory = $true)][string]$Text
  )
  $Encoding = New-Object System.Text.UTF8Encoding($false)
  [System.IO.File]::WriteAllText($Path, $Text, $Encoding)
}

New-Item -ItemType Directory -Force -Path (Join-Path $Probe "Assets\Editor") | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $Probe "Packages") | Out-Null
New-Item -ItemType Directory -Force -Path (Join-Path $Probe "ProjectSettings") | Out-Null
New-Item -ItemType Directory -Force -Path (Split-Path $LogPath) | Out-Null
New-Item -ItemType Directory -Force -Path $ReportDir | Out-Null
New-Item -ItemType Directory -Force -Path (Split-Path $SummaryJson) | Out-Null

$ManifestText = @"
{
  "dependencies": {
    "com.unity.ugui": "2.0.0",
    "com.unity.modules.ui": "1.0.0",
    "com.unity.modules.imgui": "1.0.0",
    "com.unity.modules.jsonserialize": "1.0.0",
    "com.unity.modules.imageconversion": "1.0.0"
  }
}
"@
Write-Utf8NoBom -Path (Join-Path $Probe "Packages\manifest.json") -Text $ManifestText

$ProjectVersionText = @"
m_EditorVersion: 6000.4.9f1
m_EditorVersionWithRevision: 6000.4.9f1
"@
Write-Utf8NoBom -Path (Join-Path $Probe "ProjectSettings\ProjectVersion.txt") -Text $ProjectVersionText

Copy-Item -Force (Join-Path $Tools "templates\GirlsWarTmpCompileProbe.cs") (Join-Path $Probe "Assets\Editor\GirlsWarTmpCompileProbe.cs")

Write-Host "[GirlsWarRestore] TMP compile probe project: $Probe"
Write-Host "[GirlsWarRestore] Unity log: $LogPath"

& $Unity -batchmode -quit -projectPath $Probe -executeMethod GirlsWarRestoreTmpProbe.Probe.Run -logFile $LogPath
if ($null -eq $LASTEXITCODE) {
  $ExitCode = -999
} else {
  $ExitCode = [int]$LASTEXITCODE
}

$ProbeResult = Join-Path $ProjectReportDir "tmp_compile_probe_result.json"
$WaitSeconds = 90
for ($i = 0; $i -lt $WaitSeconds; $i++) {
  if (Test-Path $ProbeResult) {
    break
  }
  Start-Sleep -Seconds 1
}

$ResultExists = Test-Path $ProbeResult
$LogText = ""
if (Test-Path $LogPath) {
  $LogText = Get-Content -Raw -Path $LogPath -ErrorAction SilentlyContinue
}

$CompileErrors = @()
if ($LogText) {
  $CompileErrors = [regex]::Matches($LogText, "(?m)(error CS\d+:.+|Compilation failed:.+|Build completed with a result of 'Failed'.+)") | ForEach-Object { $_.Value }
}

$Status = if ($ResultExists -and $CompileErrors.Count -eq 0) {
  "tmp_compile_ok"
} else {
  "tmp_compile_failed"
}
$ExitCodeReport = if ($ExitCode -eq -999) {
  "not_reported_by_powershell"
} else {
  [string]$ExitCode
}

$Summary = [ordered]@{
  generated_at = (Get-Date -Format "yyyy-MM-dd HH:mm:ss")
  status = $Status
  unity_exit_code = $ExitCodeReport
  result_wait_seconds = $WaitSeconds
  probe_project = $Probe
  unity_log = $LogPath
  manifest_dependencies = @("com.unity.ugui")
  textmeshpro_package_note = "Unity 6000 com.unity.textmeshpro is a shim; TMP runtime is included through com.unity.ugui 2.0."
  probe_result_json = $ProbeResult
  probe_result_exists = $ResultExists
  compile_error_count = $CompileErrors.Count
  compile_errors = @($CompileErrors | Select-Object -First 20)
}
Write-Utf8NoBom -Path $SummaryJson -Text ($Summary | ConvertTo-Json -Depth 6)

$Md = New-Object System.Collections.Generic.List[string]
$Md.Add("# MainInterface TMP Compile Probe Result")
$Md.Add("")
$Md.Add("Generated: $($Summary.generated_at)")
$Md.Add("")
$Md.Add("## Verdict")
$Md.Add("")
if ($Status -eq "tmp_compile_ok") {
  $Md.Add("Unity 6000 probe compiled `using TMPro` and created a `TextMeshProUGUI` component successfully. The MainInterface builder can split TMP-like rows into a `TextMeshProUGUI` path.")
} else {
  $Md.Add("Unity 6000 probe failed before confirming TMP compile/create. Check the Unity log and compile errors below.")
}
$Md.Add("")
$Md.Add("## Result")
$Md.Add("")
$Md.Add("| item | value |")
$Md.Add("| --- | --- |")
$Md.Add('| status | `' + $Status + '` |')
$Md.Add('| Unity exit code | `' + $ExitCodeReport + '` |')
$Md.Add('| probe project | `' + $Probe + '` |')
$Md.Add('| Unity log | `' + $LogPath + '` |')
$Md.Add('| probe result json | `' + $ProbeResult + '` |')
$Md.Add('| compile errors | `' + $CompileErrors.Count + '` |')
$Md.Add("")
$Md.Add("## Package Note")
$Md.Add("")
$Md.Add('In Unity 6000, `com.unity.textmeshpro` is a shim package and TMP functionality is included through `com.unity.ugui` 2.0. The restore project already has `com.unity.ugui`, so the builder should be changed only after this compile/create probe passes.')
if ($CompileErrors.Count -gt 0) {
  $Md.Add("")
  $Md.Add("## Compile Errors")
  $Md.Add("")
  foreach ($err in ($CompileErrors | Select-Object -First 20)) {
    $Md.Add('- `' + $err + '`')
  }
}
$Md.Add("")
$Md.Add("## Next")
$Md.Add("")
$Md.Add('1. Split `maininterface_text_components.csv` rows into UGUI and TMP-like groups by script_id/component fields.')
$Md.Add('2. Add a `TextMeshProUGUI` creation path for TMP-like rows.')
$Md.Add('3. Map original TMP fields to `maininterface_tmp_font_assets.csv` FontAsset/atlas evidence.')
$Md.Add('4. Validate the right-route TMP labels first with a fresh graphics capture.')

Write-Utf8NoBom -Path $OutMd -Text ($Md -join "`n")

Write-Host "[GirlsWarRestore] Status: $Status"
Write-Host "[GirlsWarRestore] Summary: $SummaryJson"
Write-Host "[GirlsWarRestore] Report: $OutMd"
if ($Status -eq "tmp_compile_ok") {
  exit 0
}
exit $ExitCode
