# Variables
$csvFilePath = Join-Path $PSScriptRoot 'threathunting-keywords.csv'

# Load CSV data
$data = Import-Csv -Path $csvFilePath

# Get unique metadata_keyword_type values
$types = $data | Select-Object -ExpandProperty metadata_keyword_type -Unique

foreach ($type in $types) {
    # Filter data based on current type
    $filteredData = $data | Where-Object {$_.metadata_keyword_type -eq $type}

    # Define output file path
    $outputFilePath = Join-Path $PSScriptRoot "$type.csv"

    # Export filtered data to CSV
    $filteredData | Export-Csv -Path $outputFilePath -NoTypeInformation
}
