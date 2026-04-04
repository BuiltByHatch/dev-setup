#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"

$INSTALLED = @()
$ALREADY_INSTALLED = @()
$FAILED = @()

$TASKS = @(
    "Checking package manager"
    "Installing winget"
    "Installing Git"
    "Installing OpenCode"
    "Installing Cursor"
)
$TOTAL_TASKS = $TASKS.Count
$CURRENT_TASK = 0

function Show-Progress {
    param([int]$Percent, [string]$Status)
    Write-Progress -Activity "Dev Setup Installation" -Status $Status -PercentComplete $Percent
}

Write-Host "========================================" -ForegroundColor Cyan
Write-Host "       DEV SETUP INSTALLER" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "This script will install the following:"
Write-Host "  - Git         (version control)"
Write-Host "  - winget      (Windows package manager, if needed)"
Write-Host "  - OpenCode    (AI coding assistant)"
Write-Host "  - Cursor      (AI-powered IDE)"
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
$response = Read-Host "Proceed with installation? [Y/n]"
if ($response -notlike "Y" -and $response -notlike "y" -and $response -ne "") {
    Write-Host "Installation cancelled." -ForegroundColor Yellow
    exit 0
}

Write-Host ""
Write-Host "Setting up development environment..." -ForegroundColor Cyan
Write-Host ""

$CURRENT_TASK = 1
Show-Progress -Percent (($CURRENT_TASK / $TOTAL_TASKS) * 100) -Status $TASKS[$CURRENT_TASK - 1]

# Install package managers if needed
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    if (Get-Command choco -ErrorAction SilentlyContinue) {
        Write-Host "Chocolatey detected, using it instead"
    } else {
        Write-Host "Warning: Neither winget nor Chocolatey detected. Install one manually." -ForegroundColor Red
        $FAILED += "winget"
    }
} else {
    $ALREADY_INSTALLED += "winget"
}

$CURRENT_TASK = 2
Show-Progress -Percent (($CURRENT_TASK / $TOTAL_TASKS) * 100) -Status $TASKS[$CURRENT_TASK - 1]

# Install Git if not present
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    if (Get-Command winget -ErrorAction SilentlyContinue) {
        winget install Git.Git --accept-source-agreements --accept-package-agreements
        if ($?) { $INSTALLED += "Git" } else { $FAILED += "Git" }
    } elseif (Get-Command choco -ErrorAction SilentlyContinue) {
        choco install git -y
        if ($?) { $INSTALLED += "Git" } else { $FAILED += "Git" }
    } else {
        Write-Host "Error: Could not detect package manager. Please install Git manually." -ForegroundColor Red
        $FAILED += "Git"
    }
} else {
    $ALREADY_INSTALLED += "Git"
}

$CURRENT_TASK = 3
Show-Progress -Percent (($CURRENT_TASK / $TOTAL_TASKS) * 100) -Status $TASKS[$CURRENT_TASK - 1]

# Install OpenCode
if (-not (Get-Command opencode -ErrorAction SilentlyContinue)) {
    try {
        $installScript = Invoke-WebRequest -Uri "https://opencode.ai/install" -UseBasicParsing
        Invoke-Expression $installScript.Content
        $INSTALLED += "OpenCode"
    } catch {
        $FAILED += "OpenCode"
    }
} else {
    $ALREADY_INSTALLED += "OpenCode"
}

$CURRENT_TASK = 4
Show-Progress -Percent (($CURRENT_TASK / $TOTAL_TASKS) * 100) -Status $TASKS[$CURRENT_TASK - 1]

# Install Cursor
if (-not (Get-Command cursor -ErrorAction SilentlyContinue)) {
    try {
        Invoke-WebRequest -Uri "https://cursor.com/install?win32=true" -UseBasicParsing | Invoke-Expression
        $INSTALLED += "Cursor"
    } catch {
        $FAILED += "Cursor"
    }
} else {
    $ALREADY_INSTALLED += "Cursor"
}

$CURRENT_TASK = 5
Show-Progress -Percent (($CURRENT_TASK / $TOTAL_TASKS) * 100) -Status $TASKS[$CURRENT_TASK - 1]
Write-Host ""
Write-Host ""

# Summary
Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
Write-Host "           SETUP SUMMARY" -ForegroundColor Cyan
Write-Host "========================================" -ForegroundColor Cyan

if ($INSTALLED.Count -gt 0) {
    Write-Host ""
    Write-Host "INSTALLED:" -ForegroundColor Green
    foreach ($item in $INSTALLED) {
        Write-Host "  [+] $item" -ForegroundColor Green
    }
}

if ($ALREADY_INSTALLED.Count -gt 0) {
    Write-Host ""
    Write-Host "ALREADY INSTALLED:" -ForegroundColor Yellow
    foreach ($item in $ALREADY_INSTALLED) {
        Write-Host "  [=] $item" -ForegroundColor Yellow
    }
}

if ($FAILED.Count -gt 0) {
    Write-Host ""
    Write-Host "FAILED:" -ForegroundColor Red
    foreach ($item in $FAILED) {
        Write-Host "  [!] $item" -ForegroundColor Red
    }
}

Write-Host ""
Write-Host "========================================" -ForegroundColor Cyan
