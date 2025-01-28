param (
    [Parameter(Mandatory=$true)]
    [string]$patternFile,
    [Parameter(Mandatory=$true)]
    [string]$targetFile,
    [Parameter(Mandatory=$true)]
    [string]$rgPath
)

Start-Transcript -Path "$PSScriptRoot\result_search.log" -Append -Force -Verbose

<#
  Download ripgrep https://github.com/BurntSushi/ripgrep/releases
  Exemple usage: powershell -ep Bypass -File .\DFIR_hunt_in_file.ps1 -patternFile "only_keywords_regex.txt" -targetFile "C:\Users\mthcht\collection\20230406154410_EvtxECmd_Output.csv" -rgPath "C:\Users\mthcht\Downloads\ripgrep-13.0.0-x86_64-pc-windows-msvc\ripgrep-13.0.0-x86_64-pc-windows-msvc\rg.exe"
#>

$totalLines = (Get-Content $patternFile | Measure-Object -Line).Lines
$currentLine = 0
Get-Content $patternFile | ForEach-Object {
    $currentLine++
    Write-Host "Searching for pattern $currentLine of $totalLines : $_"  
    & $rgPath --multiline --ignore-case $_ $targetFile | Write-Output 
}

Stop-Transcript -Verbose