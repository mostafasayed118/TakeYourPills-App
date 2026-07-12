# Build a signed Android App Bundle for Play Store upload.
# Prerequisites: android/key.properties + upload keystore (see key.properties.example)

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
Set-Location $root

if (-not (Test-Path "android\key.properties")) {
    Write-Error "Missing android\key.properties. Copy key.properties.example and fill secrets."
}

Write-Host "Running tests..."
flutter test
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

Write-Host "Building release app bundle..."
flutter build appbundle --release
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }

$bundle = Join-Path $root "build\app\outputs\bundle\release\app-release.aab"
Write-Host "Done: $bundle"
