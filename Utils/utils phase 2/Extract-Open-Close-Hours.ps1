function Extract-Open-Close-Hours{
    param(
        [Parameter(Mandatory = $true, Position = 0 )]
        [string]$string
    )
    $usefulText = $string.Substring($string.IndexOf("de")+2)
    $openingHourText = $usefulText -replace '\s',''
    return $openingHourText.Split("à")
}