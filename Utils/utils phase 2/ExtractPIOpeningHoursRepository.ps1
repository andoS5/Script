function formatHour($RawValueDate) {
    if ($null -ne $RawValueDate -and $RawValueDate.Contains('T')) {
        return "$($RawValueDate.Substring(9,2)):$($RawValueDate.Substring(11,2))"
    }
}
function ExtractPIOpeningHoursRepository {
    param (
        [Parameter(Mandatory = $true, Position = 0 )]
        [string]$RegionName,
        [Parameter(Mandatory = $true, Position = 1 )]
        [string]$MallName,
        [Parameter(Mandatory = $true, Position = 2 )]
        [string]$Language
    )

    $OpeningHoursRepository = "master:/sitecore/content/Klepierre/$RegionName/$MallName/Home/Practical Information/Opening Hours Repository"

    $Days = Get-ChildItem -Path $OpeningHoursRepository -Language $Language | Where { $_.TemplateID -eq "{6C32F517-77B1-4E0C-B8CE-D1FE77E25563}" }

    $cpt = 1
    $outputFilePath = "$($AppPath)/Opening Hours $($MallName).csv"
    $array = New-Object System.Collections.ArrayList
    $count = $Days.Count

    foreach ($d in $Days) {

        $Day = $d['Day']
        $Close = $d['Close']
        $OpeningTime = formatHour $d['Opening Time']
        $ClosingTime = formatHour $d['Closing Time']

        $obj = New-Object System.Object

        $obj | Add-Member -MemberType NoteProperty -Name "Day"-Value $Day
        $obj | Add-Member -MemberType NoteProperty -Name "Close"-Value $Close
        $obj | Add-Member -MemberType NoteProperty -Name "OpeningTime"-Value $OpeningTime
        $obj | Add-Member -MemberType NoteProperty -Name "ClosingTime"-Value $ClosingTime

        $array.Add($obj) | Out-Null
            
        Write-Host "[$($cpt)/$($count)]  ---- done" -ForegroundColor Green
        $cpt ++;
    }
    $array | Select-Object Day, Close, OpeningTime, ClosingTime | Export-Csv -Encoding UTF8 -notypeinformation -Path $outputFilePath
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
ExtractPIOpeningHoursRepository $RegionName $MallName $Language