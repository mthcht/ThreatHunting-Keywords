# Variables
$csvFilePath = Join-Path (Join-Path $PSScriptRoot '..') 'threathunting-keywords.csv'


# Load CSV data
$data = Import-Csv -Path $csvFilePath

# Get unique metadata_keyword_type values
$types = $data | Select-Object -ExpandProperty metadata_keyword_type -Unique

foreach ($type in $types) {
    # Filter data based on current type
    $filteredData = $data | Where-Object {$_.metadata_keyword_type -eq $type}

    # Define output file path
    $outputFilePath = Join-Path (Join-Path $PSScriptRoot '..') "$type.csv"

    # Export filtered data to CSV
    $filteredData | Export-Csv -Path $outputFilePath -NoTypeInformation -Encoding UTF8
}

# Creating csv for each tool
$dirMapping = @{
    "A" = "A-C";
    "B" = "A-C";
    "C" = "A-C";
    "D" = "D-F";
    "E" = "D-F";
    "F" = "D-F";
    "G" = "G-H";
    "H" = "G-H";
    "I" = "I-K";
    "J" = "I-K";
    "K" = "I-K";
    "L" = "L-N";
    "M" = "L-N";
    "N" = "L-N";
    "O" = "O-Q";
    "P" = "O-Q";
    "Q" = "O-Q";
    "R" = "R-T";
    "S" = "R-T";
    "T" = "R-T";
    "U" = "U-W";
    "V" = "U-W";
    "W" = "U-W";
    "X" = "X-Z";
    "Y" = "X-Z";
    "Z" = "X-Z"
}

# Initialize a dictionary for storing grouped data
$groupedData = @{}

# Create main 'tools' directory
$mainDir = Join-Path $PSScriptRoot '..\tools\'
New-Item -ItemType Directory -Force -Path $mainDir

# Group data by tool in a single pass
$data | ForEach-Object {
    $tool = $_.metadata_tool
    $firstLetter = $tool.Substring(0, 1).ToUpper()
    $subDir = $dirMapping[$firstLetter]
    if (-not $subDir) { $subDir = "_Others" }

    $subDirPath = Join-Path $mainDir $subDir
    New-Item -ItemType Directory -Force -Path $subDirPath

    $outputFilePath = Join-Path $subDirPath "$tool.csv"

    if (-not $groupedData[$outputFilePath]) {
        $groupedData[$outputFilePath] = @()
    }

    $groupedData[$outputFilePath] += $_
}

# Export data to CSV
$groupedData.Keys | ForEach-Object {
    $outputFilePath = $_
    $groupedData[$outputFilePath] | Export-Csv -Path $outputFilePath -NoTypeInformation -Encoding UTF8
}


$keywords = $data | 
    Select-Object -ExpandProperty keyword | 
    Sort-Object -Unique
$outputFilePath = Join-Path (Join-Path $PSScriptRoot '..') "only_keywords.txt"
$keywords | Out-File -FilePath $outputFilePath -Encoding UTF8

$keywords_regex_better_perf = $data | 
    Where-Object { $_.metadata_keyword_regex -ne 'N/A' -and $_.metadata_keyword_regex -ne $null } | 
    Select-Object -ExpandProperty metadata_keyword_regex | 
    Sort-Object -Unique
$outputFilePath2 = Join-Path (Join-Path $PSScriptRoot '..') "only_keywords_regex_better_perf.txt"
$keywords_regex_better_perf | Out-File -FilePath $outputFilePath2 -Encoding UTF8

# Add-Type method to use C#'s Regex.Escape method
Add-Type -TypeDefinition @"
    using System.Text.RegularExpressions;
    public class RegExUtility{
        public static string Escape(string str){
            return Regex.Escape(str);
        }
    }
"@

# Placeholder string that does not have special meaning in regular expressions
$placeholder = "PLACEHOLDER123"

# Convert keywords to regex keywords
$regexKeywords = foreach ($Keyword in $keywords) {
    $regexKeyword = $Keyword -replace '\*', $placeholder  # Replace * with placeholder
    $regexKeyword = [RegExUtility]::Escape($regexKeyword)  # Escape special characters
    $regexKeyword = $regexKeyword -replace $placeholder, '.*'  # Replace placeholder with .*
    $regexKeyword = $regexKeyword -replace '\\ ', ' '
    $regexKeyword = $regexKeyword -replace '"', '.*'  
    $regexKeyword
}

# Write regex keywords to file
$regexOutputFilePath = Join-Path $PSScriptRoot "only_keywords_regex.txt"
$regexOutputFilePath = Join-Path (Join-Path $PSScriptRoot '..') "only_keywords_regex.txt"

$regexKeywords | Out-File -FilePath $regexOutputFilePath -Encoding UTF8
