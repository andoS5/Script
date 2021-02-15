function ScrapWebElementByStringTag{
    param(
        [Parameter(Mandatory)]
        $HTMLContent,
        [Parameter(Mandatory)]
        [string]$Pattern,
        [Parameter(Mandatory)]
        [string]$ResultRegex,
        [Parameter]
        [string]$ResultName
    )

    Begin {
        Write-Host "Starting Scrapping $ResultName" -ForegroundColor Yellow
    }
       
    Process {
        $RawResult = ([regex]$Pattern).Matches($HTMLContent)
        $Regex = [Regex]::new("$ResultRegex")       
        $Result = $Regex.Match($RawResult)           
        if ($Result.Success) {           
           return $Result.Value           
        }
    }
}