param(
    [int]$Tail = 30,
    [int]$Sample = 30
)

$ErrorActionPreference = "Continue"
$root = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
Set-Location -LiteralPath $root

function Section([string]$name) {
    Write-Host ""
    Write-Host "=== $name ==="
}

function Show-LogTail([string]$label, [string]$path) {
    Section $label
    if (Test-Path -LiteralPath $path) {
        Get-Item -LiteralPath $path | Select-Object FullName, Length, LastWriteTime | Format-List
        Get-Content -LiteralPath $path -Tail $Tail
    } else {
        Write-Host "No log yet: $path"
    }
}

Section "workspace"
Write-Host $root

Section "local branch"
$branch = git status --short --branch --untracked-files=no 2>&1
if ($branch) {
    $branch | Select-Object -First 1
} else {
    Write-Host "git status unavailable"
}

$trackedStatus = @(git status --porcelain=v1 --untracked-files=no 2>$null)
$trackedChanged = $trackedStatus.Count
Write-Host "tracked changed files: $trackedChanged"
if ($trackedChanged -gt 0) {
    $trackedStatus | Select-Object -First $Sample
    if ($trackedChanged -gt $Sample) {
        Write-Host "... $($trackedChanged - $Sample) more tracked changes"
    }
}

Section "untracked summary"
$untracked = @(git ls-files --others --exclude-standard 2>$null)
Write-Host "untracked files: $($untracked.Count)"
if ($untracked.Count -gt 0) {
    $untracked |
        ForEach-Object { ($_ -split '/')[0] } |
        Group-Object |
        Sort-Object Count -Descending |
        Select-Object -First 15 Count, Name |
        Format-Table -AutoSize

    Write-Host "sample:"
    $untracked | Select-Object -First $Sample
    if ($untracked.Count -gt $Sample) {
        Write-Host "... $($untracked.Count - $Sample) more untracked files"
    }
}

Section "lfs summary"
$lfsCount = (git lfs ls-files 2>$null | Measure-Object).Count
Write-Host "git lfs tracked files: $lfsCount"

Section "remote main"
$remoteMain = git ls-remote origin refs/heads/main 2>&1
if ($LASTEXITCODE -eq 0 -and $remoteMain) {
    $remoteMain
} elseif ($LASTEXITCODE -eq 0) {
    Write-Host "remote refs/heads/main is not created yet"
} else {
    $remoteMain
}

Section "running upload processes"
$names = @("cmd.exe", "git.exe", "git-lfs.exe", "git-remote-https.exe")
$procs = @(Get-CimInstance Win32_Process |
    Where-Object {
        $names -contains $_.Name -and
        ($_.CommandLine -match "PUSH_TO_GITHUB|PUSH_LATEST_TO_GITHUB|git-lfs pre-push|git\s+push -u origin main|git-remote-https origin https://github.com/zzangzzangman2/gw.git")
    } |
    Sort-Object CreationDate)
if ($procs.Count -eq 0) {
    Write-Host "no git/cmd upload processes found"
} else {
    $now = Get-Date
    $procs |
        Select-Object ProcessId, Name, CreationDate, @{Name = "AgeMinutes"; Expression = {
            $created = $_.CreationDate
            if (-not ($created -is [datetime])) {
                $created = [Management.ManagementDateTimeConverter]::ToDateTime($created)
            }
            [math]::Round(($now - $created).TotalMinutes, 1)
        }}, @{Name = "CPU"; Expression = {
            $p = Get-Process -Id $_.ProcessId -ErrorAction SilentlyContinue
            if ($p) { [math]::Round($p.CPU, 1) } else { "" }
        }}, @{Name = "WorkingSetMB"; Expression = {
            $p = Get-Process -Id $_.ProcessId -ErrorAction SilentlyContinue
            if ($p) { [math]::Round($p.WorkingSet64 / 1MB, 1) } else { "" }
        }}, @{Name = "Command"; Expression = {
            $cmd = $_.CommandLine
            if ($cmd.Length -gt 180) { $cmd.Substring(0, 177) + "..." } else { $cmd }
        }} |
        Format-Table -Wrap -AutoSize
}

Show-LogTail "first push log tail" (Join-Path $root "_restore_tools\logs\github_push_main.log")
Show-LogTail "followup push log tail" (Join-Path $root "_restore_tools\logs\github_push_followup_main.log")
