function formatDate($RawValueDate) {
    if ($null -ne $RawValueDate -and $RawValueDate.Contains('T')) {
        return "$($RawValueDate.Substring(4,2))-$($RawValueDate.Substring(6,2))-$($RawValueDate.Substring(0,4))"
    }
}

function formatHour($RawValueDate) {
    if ($null -ne $RawValueDate -and $RawValueDate.Contains('T')) {
        return "$($RawValueDate.Substring(9,2)):$($RawValueDate.Substring(11,2))"
    }
}
function ExtractPIExceptionalHours {
    param (
        [Parameter(Mandatory = $true, Position = 0 )]
        [string]$RegionName,
        [Parameter(Mandatory = $true, Position = 1 )]
        [string]$MallName,
        [Parameter(Mandatory = $true, Position = 2 )]
        [string]$Language
    )

    $ExceptionalHoursRepository = "master:/sitecore/content/Klepierre/$RegionName/$MallName/Home/Practical Information/Exceptional Hours Repository"

    $EHs = Get-ChildItem -Path $ExceptionalHoursRepository -Language $Language | Where { $_.TemplateID -eq "{88796530-8E30-41D9-A593-0BCFBE21BBDC}" }
    $count = $EHs.Count
    $cpt = 1
    $outputFilePath = "$($AppPath)/Exceptional Hours_$($MallName).csv"
    $array = New-Object System.Collections.ArrayList

    foreach ($eh in $EHs) {

        $Occasion = $eh['Occasion']
        $ExceptionalDate = formatDate $eh['Exceptional Date'] 
        $Close = $eh['Close']
        $OpeningTime = formatHour $eh['Opening Time']
        $ClosingTime = formatHour $eh['Closing Time']

        $obj = New-Object System.Object

        $obj | Add-Member -MemberType NoteProperty -Name "Occasion"-Value $Occasion
        $obj | Add-Member -MemberType NoteProperty -Name "ExceptionalDate"-Value $ExceptionalDate
        $obj | Add-Member -MemberType NoteProperty -Name "Close"-Value $Close
        $obj | Add-Member -MemberType NoteProperty -Name "OpeningTime"-Value $OpeningTime
        $obj | Add-Member -MemberType NoteProperty -Name "ClosingTime"-Value $ClosingTime
        
        $array.Add($obj) | Out-Null
            
        Write-Host "[$($cpt)/$($count)]  ---- done" -ForegroundColor Green
        $cpt ++;
    }
    $array | Select-Object Occasion, ExceptionalDate, Close, OpeningTime, ClosingTime| Export-Csv -Encoding UTF8 -notypeinformation -Path $outputFilePath
    Try {
        Send-File -Path $outputFilePath
    }
    Finally {
        Remove-Item -Path $outputFilePath
    }
}

$RegionName = "France"
$MallName = "Odysseum"
$Language = "fr-fr"
ExtractPIExceptionalHours $RegionName $MallName $Language