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
    "G" = "E-H";
    "H" = "E-H";
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

# Get unique metadata_tool values
$tools = $data | Select-Object -ExpandProperty metadata_tool -Unique

# Create main 'tools' directory
$mainDir = Join-Path $PSScriptRoot '..\tools\'
New-Item -ItemType Directory -Force -Path $mainDir

foreach ($tool in $tools) {
    # Find the appropriate subdirectory
    $firstLetter = $tool.Substring(0, 1).ToUpper()
	$subDir = $dirMapping[$firstLetter]
	if (-not $subDir) { $subDir = "_Others" }
	
    # Create subdirectory if it doesn't exist
    $subDirPath = Join-Path $mainDir $subDir
    New-Item -ItemType Directory -Force -Path $subDirPath

    # Filter and export data
    $filteredData = $data | Where-Object {$_.metadata_tool -eq $tool}
    $outputFilePath = Join-Path $subDirPath "$tool.csv"
    $filteredData | Export-Csv -Path $outputFilePath -NoTypeInformation -Encoding UTF8
}

$keywords = $data | Select-Object -ExpandProperty keyword
$outputFilePath = Join-Path (Join-Path $PSScriptRoot '..') "only_keywords.txt"

$keywords | Out-File -FilePath $outputFilePath -Encoding UTF8

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
