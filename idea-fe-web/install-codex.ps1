# idea-fe-web Codex/Claude Code install script
# For pi-package format discovery in Codex/Claude Code

param(
    [string]$TargetProject
)

$ErrorActionPreference = "Stop"
$repoRoot = Split-Path -Parent $MyInvocation.MyCommand.Path

Write-Host ""
Write-Host "=== idea-fe-web Codex/Claude Code install ===" -ForegroundColor Cyan
Write-Host ""

# Check package.json
Write-Host "Checking package.json..." -ForegroundColor Cyan
if (-not (Test-Path (Join-Path $repoRoot "package.json"))) {
    Write-Host "[FAIL] package.json not found in $repoRoot" -ForegroundColor Red
    exit 1
}
Write-Host "[OK] package.json exists with pi-package configuration" -ForegroundColor Green

# Get target project path
if (-not $TargetProject) {
    Write-Host ""
    Write-Host "Usage: .\install-codex.ps1 -TargetProject <path-to-your-project>" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "Example:" -ForegroundColor Yellow
    Write-Host "  .\install-codex.ps1 -TargetProject ""C:\Projects\my-webapp""" -ForegroundColor Gray
    Write-Host ""
    Write-Host "What this script does:" -ForegroundColor Cyan
    Write-Host "1. Creates junction: TargetProject\.skills\idea-fe-web -> repoRoot" -ForegroundColor Gray
    Write-Host "2. Copies package.json to TargetProject if needed" -ForegroundColor Gray
    Write-Host "3. Codex/Claude Code auto-discovers skills from .skills directories" -ForegroundColor Gray
    exit 0
}

# Validate target project
if (-not (Test-Path $TargetProject)) {
    Write-Host "[FAIL] Target project not found: $TargetProject" -ForegroundColor Red
    exit 1
}

Write-Host ""
Write-Host "Target project: $TargetProject" -ForegroundColor Cyan

# Create .skills directory in target project
$targetSkillsDir = Join-Path $TargetProject ".skills"
if (-not (Test-Path $targetSkillsDir)) {
    New-Item -ItemType Directory -Force -Path $targetSkillsDir | Out-Null
    Write-Host "[OK] Created $targetSkillsDir" -ForegroundColor Green
}

# Link idea-fe-web to target's .skills directory
$linkPath = Join-Path $targetSkillsDir "idea-fe-web"
if (Test-Path $linkPath) {
    $item = Get-Item $linkPath
    if ($item.LinkType -eq "Junction" -or $item.LinkType -eq "SymbolicLink") {
        Write-Host "[SKIP] idea-fe-web - already linked" -ForegroundColor Yellow
    } else {
        Write-Host "[SKIP] idea-fe-web - name conflict" -ForegroundColor Yellow
    }
} else {
    try {
        New-Item -ItemType Junction -Path $linkPath -Target $repoRoot | Out-Null
        Write-Host "[OK] Linked idea-fe-web -> $repoRoot" -ForegroundColor Green
    } catch {
        Write-Host "[FAIL] $($_.Exception.Message)" -ForegroundColor Red
        exit 1
    }
}

# Check if target project has package.json with pi.skills
$targetPackageJson = Join-Path $TargetProject "package.json"
$needsPiConfig = $false
if (Test-Path $targetPackageJson) {
    $pkg = Get-Content $targetPackageJson | ConvertFrom-Json
    if (-not $pkg.pi) {
        $needsPiConfig = $true
    }
} else {
    $needsPiConfig = $true
}

if ($needsPiConfig) {
    Write-Host ""
    Write-Host "[INFO] Target project needs pi-package config in package.json" -ForegroundColor Yellow
    Write-Host "Add this to target's package.json:" -ForegroundColor Gray
    Write-Host '  "pi": { "skills": [".skills"] }' -ForegroundColor Cyan
}

Write-Host ""
Write-Host "=== Installation complete ===" -ForegroundColor Cyan
Write-Host ""
Write-Host "Next steps:" -ForegroundColor Cyan
Write-Host "1. Restart Codex/Claude Code in the target project directory" -ForegroundColor Gray
Write-Host "2. Skills will be auto-discovered from .skills/idea-fe-web/skills/" -ForegroundColor Gray
Write-Host "3. Use idea-fe-web skill for web-framework development tasks" -ForegroundColor Gray
Write-Host ""
Write-Host "Tip: For Trae, use install-trae.ps1 instead" -ForegroundColor Cyan
