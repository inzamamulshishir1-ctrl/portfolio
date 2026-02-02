# Portfolio File Organization Script
# This script organizes your portfolio files into a proper structure

Write-Host "===================================" -ForegroundColor Cyan
Write-Host "Portfolio File Organization Script" -ForegroundColor Cyan
Write-Host "===================================" -ForegroundColor Cyan
Write-Host ""

# Get the script's directory
$scriptPath = Split-Path -Parent $MyInvocation.MyCommand.Path

# Define source and destination paths
$cssSource = Join-Path $scriptPath "index.css"
$cssDestination = Join-Path $scriptPath "assets\css\style.css"

$jsSource = Join-Path $scriptPath "script.js"
$jsDestination = Join-Path $scriptPath "assets\js\script.js"

$imageSource = Join-Path $scriptPath "profile.jpg"
$imageDestination = Join-Path $scriptPath "assets\images\profile.jpg"

$cvSource = Join-Path $scriptPath "CV 2.pdf"
$cvDestination = Join-Path $scriptPath "assets\documents\CV.pdf"

# Function to move file with confirmation
function Move-FileWithConfirmation {
    param (
        [string]$Source,
        [string]$Destination,
        [string]$Description
    )
    
    if (Test-Path $Source) {
        Write-Host "Moving $Description..." -ForegroundColor Yellow
        Move-Item -Path $Source -Destination $Destination -Force
        Write-Host "✓ $Description moved successfully!" -ForegroundColor Green
    } else {
        Write-Host "✗ $Description not found at $Source" -ForegroundColor Red
    }
    Write-Host ""
}

# Create backup
Write-Host "Creating backup of current structure..." -ForegroundColor Yellow
$backupFolder = Join-Path $scriptPath "backup_$(Get-Date -Format 'yyyyMMdd_HHmmss')"
New-Item -ItemType Directory -Path $backupFolder -Force | Out-Null

# Backup important files
$filesToBackup = @("index.html", "index.css", "script.js", "profile.jpg", "CV 2.pdf")
foreach ($file in $filesToBackup) {
    $filePath = Join-Path $scriptPath $file
    if (Test-Path $filePath) {
        Copy-Item -Path $filePath -Destination $backupFolder -Force
    }
}
Write-Host "✓ Backup created at: $backupFolder" -ForegroundColor Green
Write-Host ""

# Move files to organized structure
Move-FileWithConfirmation -Source $cssSource -Destination $cssDestination -Description "CSS file"
Move-FileWithConfirmation -Source $jsSource -Destination $jsDestination -Description "JavaScript file"
Move-FileWithConfirmation -Source $imageSource -Destination $imageDestination -Description "Profile image"
Move-FileWithConfirmation -Source $cvSource -Destination $cvDestination -Description "CV document"

# Update index.html to reflect new paths
Write-Host "Updating file paths in index.html..." -ForegroundColor Yellow
$indexPath = Join-Path $scriptPath "index.html"

if (Test-Path $indexPath) {
    $content = Get-Content $indexPath -Raw
    
    # Update CSS path
    $content = $content -replace '<link rel="stylesheet" href="index.css">', '<link rel="stylesheet" href="assets/css/style.css">'
    
    # Update JS path
    $content = $content -replace '<script src="script.js"></script>', '<script src="assets/js/script.js"></script>'
    
    # Update image path
    $content = $content -replace 'src="profile.jpg"', 'src="assets/images/profile.jpg"'
    
    # Update CV path
    $content = $content -replace 'href="CV 2.pdf"', 'href="assets/documents/CV.pdf"'
    
    Set-Content -Path $indexPath -Value $content
    Write-Host "✓ File paths updated in index.html!" -ForegroundColor Green
} else {
    Write-Host "✗ index.html not found!" -ForegroundColor Red
}

Write-Host ""
Write-Host "===================================" -ForegroundColor Cyan
Write-Host "Organization Complete!" -ForegroundColor Green
Write-Host "===================================" -ForegroundColor Cyan
Write-Host ""
Write-Host "Your portfolio structure is now organized!" -ForegroundColor Green
Write-Host "You can open index.html in your browser to view your portfolio." -ForegroundColor Yellow
Write-Host ""
Write-Host "Note: A backup has been created in case you need to revert changes." -ForegroundColor Yellow
Write-Host ""
