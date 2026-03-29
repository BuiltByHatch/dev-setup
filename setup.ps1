#!/usr/bin/env pwsh
$ErrorActionPreference = "Stop"

$INSTALLED = @()
$ALREADY_INSTALLED = @()
$FAILED = @()

Write-Host "Setting up development environment..." -ForegroundColor Cyan

# Install package managers if needed
if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Host "Installing winget..." -ForegroundColor Yellow
    if (Get-Command choco -ErrorAction SilentlyContinue) {
        Write-Host "Chocolatey detected, using it instead"
    } else {
        Write-Host "Warning: Neither winget nor Chocolatey detected. Install one manually." -ForegroundColor Red
        $FAILED += "winget"
    }
} else {
    $ALREADY_INSTALLED += "winget"
}

# Install Git if not present
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Git..." -ForegroundColor Yellow
    
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

# Install OpenCode
if (-not (Get-Command opencode -ErrorAction SilentlyContinue)) {
    Write-Host "Installing OpenCode..." -ForegroundColor Yellow
    
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

# Install Cursor
if (-not (Get-Command cursor -ErrorAction SilentlyContinue)) {
    Write-Host "Installing Cursor..." -ForegroundColor Yellow
    try {
        Invoke-WebRequest -Uri "https://cursor.com/install?win32=true" -UseBasicParsing | Invoke-Expression
        $INSTALLED += "Cursor"
    } catch {
        $FAILED += "Cursor"
    }
} else {
    $ALREADY_INSTALLED += "Cursor"
}

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
