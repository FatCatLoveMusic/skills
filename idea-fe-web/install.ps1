# idea-fe-web skills install script
# Use Junction (no admin required) to link all skills from skills/ to ~/.trae-cn/skills/

$ErrorActionPreference = "Stop"

$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$skillsSrcDir = Join-Path $repoRoot "skills"
$skillsDestDir = Join-Path $env:USERPROFILE ".trae-cn\skills"

if (-not (Test-Path $skillsSrcDir)) {
    Write-Host "Error: skills directory not found: $skillsSrcDir" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path $skillsDestDir)) {
    New-Item -ItemType Directory -Force -Path $skillsDestDir | Out-Null
    Write-Host "Created directory: $skillsDestDir"
}

$skillDirs = Get-ChildItem -Path $skillsSrcDir -Directory

Write-Host ""
Write-Host "=== idea-fe-web skills install ===" -ForegroundColor Cyan
Write-Host "Source: $skillsSrcDir"
Write-Host "Target: $skillsDestDir"
Write-Host "Found $($skillDirs.Count) skills"
Write-Host ""

$successCount = 0
$skipCount = 0
$errorCount = 0

foreach ($skillDir in $skillDirs) {
    $linkPath = Join-Path $skillsDestDir $skillDir.Name
    $targetPath = $skillDir.FullName

    if (Test-Path $linkPath) {
        $item = Get-Item $linkPath
        if ($item.LinkType -eq "Junction" -or $item.LinkType -eq "SymbolicLink") {
            Write-Host "[SKIP] $($skillDir.Name) - already linked" -ForegroundColor Yellow
            $skipCount++
        } else {
            Write-Host "[SKIP] $($skillDir.Name) - name conflict, please handle manually" -ForegroundColor Yellow
            $skipCount++
        }
        continue
    }

    try {
        New-Item -ItemType Junction -Path $linkPath -Target $targetPath | Out-Null
        Write-Host "[OK] $($skillDir.Name)" -ForegroundColor Green
        $successCount++
    } catch {
        Write-Host "[FAIL] $($skillDir.Name) - $($_.Exception.Message)" -ForegroundColor Red
        $errorCount++
    }
}

Write-Host ""
Write-Host "=== Installation complete ===" -ForegroundColor Cyan
Write-Host "Success: $successCount" -ForegroundColor Green
Write-Host "Skipped: $skipCount" -ForegroundColor Yellow
Write-Host "Failed: $errorCount" -ForegroundColor Red
Write-Host ""
Write-Host "Tip: Restart Trae to activate the skills" -ForegroundColor Cyan
