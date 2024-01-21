param(
    [Parameter(Mandatory = $true)]
    [string]$File1,

    [Parameter(Mandatory = $true)]
    [string]$File2,

    [Parameter()]
    [switch]$ShowOnTerminal,

    [Parameter()]
    [string]$ExportFile
)

# Compare the files using Compare-Object
$differences = Compare-Object -ReferenceObject (Get-Content $File1) -DifferenceObject (Get-Content $File2)

$differences | Format-List -Property InputObject, SideIndicator

# Handle output options
if ($ShowOnTerminal) {
    $differences
} elseif ($ExportFile) {
    $differences | Out-File $ExportFile
}