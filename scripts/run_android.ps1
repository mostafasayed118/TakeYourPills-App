# Run / build Android when the project lives on E: and the default Pub cache is on C:.
# Cross-drive paths break Kotlin incremental caches on Windows.
#
# Usage:
#   .\scripts\run_android.ps1
#   .\scripts\run_android.ps1 -Device "Infinix X6882"
#   .\scripts\run_android.ps1 -BuildOnly

param(
    [string]$Device = "",
    [switch]$BuildOnly
)

$ErrorActionPreference = "Stop"
$root = Split-Path -Parent $PSScriptRoot
Set-Location $root

# Same drive as the project (E:)
$env:PUB_CACHE = "E:\pub-cache"
if (-not (Test-Path $env:PUB_CACHE)) {
    New-Item -ItemType Directory -Force -Path $env:PUB_CACHE | Out-Null
}

Write-Host "PUB_CACHE=$env:PUB_CACHE"
flutter pub get

if ($BuildOnly) {
    flutter build apk --debug
    exit $LASTEXITCODE
}

if ($Device) {
    flutter run -d $Device
} else {
    flutter run
}
