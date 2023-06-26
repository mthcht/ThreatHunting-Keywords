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
    $filteredData | Export-Csv -Path $outputFilePath -NoTypeInformation -Encoding UTF8
}

$keywords = $data | Select-Object -ExpandProperty keyword
$outputFilePath = Join-Path $PSScriptRoot "only_keywords.txt"
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
    $regexKeyword = $regexKeyword -replace '\\ ', ' '  # Replace escaped space with space
    $regexKeyword = $regexKeyword -replace '"', '\"'  # escape double quote
    $regexKeyword
}

# Write regex keywords to file
$regexOutputFilePath = Join-Path $PSScriptRoot "only_keywords_regex.txt"
$regexKeywords | Out-File -FilePath $regexOutputFilePath -Encoding UTF8
