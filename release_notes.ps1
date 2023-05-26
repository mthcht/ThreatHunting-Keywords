# defining paths
$csvFilePath = Join-Path $PSScriptRoot 'threathunting-keywords.csv'
$releaseNotesPath = Join-Path $PSScriptRoot 'release_notes'
$date = Get-Date -Format "yyyyMMdd"
$ReleaseFilePath = Join-Path $releaseNotesPath "Release_$date.csv"

# check if threathunting-keywords.csv file exists
if (-not (Test-Path $csvFilePath)) {
    Write-Host -ForegroundColor Red "CSV file $csvFilePath not found"
    sleep 3
    exit 1
}

# check if releaseNotesPath exists
if (-not (Test-Path $releaseNotesPath)) {
    Write-Host -ForegroundColor Yellow "Release notes directory not found. Creating directory."
    New-Item -ItemType Directory -Path $releaseNotesPath | Out-Null
}

# Import and process threathunting-keywords.csv
$initial = Import-Csv $csvFilePath
$uniqueInitial = $initial | Select-Object metadata_tool, metadata_link | Sort-Object metadata_tool, metadata_link -Unique
$sortedUniqueInitial = $uniqueInitial | Sort-Object metadata_tool

# Export data to CSV file
$sortedUniqueInitial | Export-Csv $ReleaseFilePath -NoTypeInformation