# Get GitHub API token from environment variable
$apiToken = [System.Environment]::GetEnvironmentVariable('GITHUB_API_TOKEN')

$headers = @{
    Authorization = "Bearer $apiToken"
}

$csvData = Import-Csv -Path "..\threathunting-keywords.csv"
$starCounts = @{}
$forkCounts = @{}
$created_at = @{}
$updated_at = @{}
$popularity = @{}
$newCsvPath = "tmp_updated_threathunting-keywords.csv" # new csv for verification before manual overwrite of threathunting-keywords.csv

Remove-Item $newCsvPath -ErrorAction SilentlyContinue

$updatedRows = @()

foreach ($row in $csvData) {
    Write-Host -ForegroundColor Cyan $row.'keyword'
    $url = $row.metadata_link
    #$needsUpdate = [string]::IsNullOrEmpty($row.'metadata_github_stars') -or 
    #               $row.'metadata_github_stars' -eq 'N/A' -or
    #               [string]::IsNullOrEmpty($row.'metadata_github_forks') -or 
    #               $row.'metadata_github_forks' -eq 'N/A'
    if ($url -match "https:\/\/github\.com\/.+?(?=\/)\/\w") {
        $ownerRepo = $url -replace "^https:\/\/github.com\/([^\/]+\/[^\/]+).*", '$1'
        
        if (-not $starCounts.ContainsKey($ownerRepo)) {
            try {
                $response = Invoke-WebRequest -Uri "https://api.github.com/repos/$ownerRepo" -Method Get -Headers $headers
                $responsecontent = $response.Content | ConvertFrom-Json
            }
            catch{
                if ($null -ne $response) {
                    Write-Host -ForegroundColor Red "Error fetching github infos for $url \nstatus: $response.StatusCode \nCaught an exception: $($_.Exception.Message)"
                }
                else{
                    Write-Host -ForegroundColor Red "Error fetching github infos for $url : Caught an exception: $($_.Exception.Message)"
                    $responsecontent = @{}
                }
                $responsecontent.stargazers_count = 'N/A'
                $responsecontent.forks = 'N/A'
                $responsecontent.created_at = 'N/A'
                $responsecontent.updated_at = 'N/A'
            }
            
            try {
                
                $remainingCalls = [int]$response.Headers['X-RateLimit-Remaining']
                $githubapiresettimestamp = [int]$response.Headers['X-RateLimit-Reset']

                if ($remainingCalls -le 10) {
                    Write-Host "Approaching rate limit. remaing calls: $remainingCalls ... Pausing for 5m (resetting at $githubapiresettimestamp)"
                    Start-Sleep -Seconds 1080
                }
                
                $starCount = $responsecontent.stargazers_count
                $starCounts[$ownerRepo] = $starCount
                $row."metadata_github_stars" = $starCounts[$ownerRepo]

                $forkCount = $responsecontent.forks
                $forkCounts[$ownerRepo] = [int]$forkCount
                $row."metadata_github_forks"= $forkCounts[$ownerRepo]

                $repo_created_at = $responsecontent.created_at
                $created_at[$ownerRepo] = $repo_created_at
                $row."metadata_github_created_at"= $created_at[$ownerRepo]

                $repo_updated_at = $responsecontent.updated_at
                $updated_at[$ownerRepo] = $repo_updated_at
                $row."metadata_github_updated_at" = $updated_at[$ownerRepo]

                if ($starCount -lt 100) { $metadata_popularity_score = 1 }
                elseif ($starCount -ge 100 -and $starCount -lt 200) { $metadata_popularity_score = 2 }
                elseif ($starCount -ge 200 -and $starCount -lt 300) { $metadata_popularity_score = 3 }
                elseif ($starCount -ge 300 -and $starCount -lt 400) { $metadata_popularity_score = 4 }
                elseif ($starCount -ge 400 -and $starCount -lt 500) { $metadata_popularity_score = 5 }
                elseif ($starCount -ge 500 -and $starCount -lt 600) { $metadata_popularity_score = 6 }
                elseif ($starCount -ge 600 -and $starCount -lt 700) { $metadata_popularity_score = 7 }
                elseif ($starCount -ge 700 -and $starCount -lt 800) { $metadata_popularity_score = 8 }
                elseif ($starCount -ge 800 -and $starCount -lt 900) { $metadata_popularity_score = 9 }
                elseif ($starCount -ge 901) { $metadata_popularity_score = 10 }

                if ($row."metadata_category" -like "*C2*") {
                    $row."metadata_popularity_score" = 10
                    $popularity[$ownerRepo] = 10
                }
                else {
                    $row."metadata_popularity_score" = $metadata_popularity_score
                    $popularity[$ownerRepo] = $metadata_popularity_score
                }
            }
            catch {
                Write-Host "Error Setting data values: Caught an exception: $($_.Exception.Message)"
                $row."metadata_github_stars" = 'N/A'
                $row."metadata_github_forks" = 'N/A'
                $row."metadata_github_updated_at" = 'N/A'
                $row."metadata_github_created_at" = 'N/A'
            }
        }
        elseif ($starCounts.ContainsKey($ownerRepo)) {
            $row."metadata_github_stars" = $starCounts[$ownerRepo]
            $row."metadata_github_forks" = $forkCounts[$ownerRepo]
            $row."metadata_github_updated_at" = $updated_at[$ownerRepo]
            $row."metadata_github_created_at" = $created_at[$ownerRepo]
            $row."metadata_popularity_score" = $popularity[$ownerRepo]
        }
    }
    else{
        $row."metadata_github_stars" = 'N/A'
        $row."metadata_github_forks" = 'N/A'
        $row."metadata_github_updated_at" = 'N/A'
        $row."metadata_github_created_at" = 'N/A'
    }
    $updatedRows += $row
    Write-Host "new row: $row "
}

$updatedRows | Export-Csv -Path $newCsvPath -NoTypeInformation -Force