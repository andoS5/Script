function ExtractPIFootfallDay {
    param (
        [Parameter(Mandatory = $true, Position = 0 )]
        [string]$RegionName,
        [Parameter(Mandatory = $true, Position = 1 )]
        [string]$MallName,
        [Parameter(Mandatory = $true, Position = 2 )]
        [string]$Language
    )

    $footfallDayRepo = "master:/sitecore/content/Klepierre/$RegionName/$MallName/Home/Practical Information/Footfall Days"
    $ffdItem = Get-Item -Path $footfallDayRepo -Language $Language
    
    $cpt = 1
    $outputFilePath = "$($AppPath)/Footfall_$($MallName).csv"
    $array = New-Object System.Collections.ArrayList
    $FootfallText = $ffdItem['Footfall Text']
    $NoProcessing = $ffdItem['No Processing']

    $daysOfWeek = Get-ChildItem -Path $footfallDayRepo -Language $Language | Where { $_.TemplateID -eq "{513FA478-F5C8-46FC-A4A9-02D0EE83D43A}"}
    $count = $daysOfWeek.Count
    foreach ($dof in $daysOfWeek) {
        $day = $dof.Name
        $Label = $dof['Label']
        $0H00 = $dof['0H00']
        $1H00 = $dof['1H00']
        $2H00 = $dof['2H00']
        $3H00 = $dof['3H00']
        $4H00 = $dof['4H00']
        $5H00 = $dof['5H00']
        $6H00 = $dof['6H00']
        $7H00 = $dof['7H00']
        $8H00 = $dof['8H00']
        $9H00 = $dof['9H00']
        $10H00 = $dof['10H00']
        $11H00 = $dof['11H00']
        $12H00 = $dof['12H00']
        $13H00 = $dof['13H00']
        $14H00 = $dof['14H00']
        $15H00 = $dof['15H00']
        $16H00 = $dof['16H00']
        $17H00 = $dof['17H00']
        $18H00 = $dof['18H00']
        $19H00 = $dof['19H00']
        $20H00 = $dof['20H00']
        $21H00 = $dof['21H00']
        $22H00 = $dof['22H00']
        $23H00 = $dof['23H00']

        $obj = New-Object System.Object

        $obj | Add-Member -MemberType NoteProperty -Name "day"-Value $day
        $obj | Add-Member -MemberType NoteProperty -Name "Label"-Value $Label
        $obj | Add-Member -MemberType NoteProperty -Name "FootfallText"-Value $FootfallText
        $obj | Add-Member -MemberType NoteProperty -Name "NoProcessing"-Value $NoProcessing
        $obj | Add-Member -MemberType NoteProperty -Name "0H00"-Value $0H00
        $obj | Add-Member -MemberType NoteProperty -Name "1H00"-Value $1H00
        $obj | Add-Member -MemberType NoteProperty -Name "2H00"-Value $2H00
        $obj | Add-Member -MemberType NoteProperty -Name "3H00"-Value $3H00
        $obj | Add-Member -MemberType NoteProperty -Name "4H00"-Value $4H00
        $obj | Add-Member -MemberType NoteProperty -Name "5H00"-Value $5H00
        $obj | Add-Member -MemberType NoteProperty -Name "6H00"-Value $6H00
        $obj | Add-Member -MemberType NoteProperty -Name "7H00"-Value $7H00
        $obj | Add-Member -MemberType NoteProperty -Name "8H00"-Value $8H00
        $obj | Add-Member -MemberType NoteProperty -Name "9H00"-Value $9H00
        $obj | Add-Member -MemberType NoteProperty -Name "10H00"-Value $10H00
        $obj | Add-Member -MemberType NoteProperty -Name "11H00"-Value $11H00
        $obj | Add-Member -MemberType NoteProperty -Name "12H00"-Value $12H00
        $obj | Add-Member -MemberType NoteProperty -Name "13H00"-Value $13H00
        $obj | Add-Member -MemberType NoteProperty -Name "14H00"-Value $14H00
        $obj | Add-Member -MemberType NoteProperty -Name "15H00"-Value $15H00
        $obj | Add-Member -MemberType NoteProperty -Name "16H00"-Value $16H00
        $obj | Add-Member -MemberType NoteProperty -Name "17H00"-Value $17H00
        $obj | Add-Member -MemberType NoteProperty -Name "18H00"-Value $18H00
        $obj | Add-Member -MemberType NoteProperty -Name "19H00"-Value $19H00
        $obj | Add-Member -MemberType NoteProperty -Name "20H00"-Value $20H00
        $obj | Add-Member -MemberType NoteProperty -Name "21H00"-Value $21H00
        $obj | Add-Member -MemberType NoteProperty -Name "22H00"-Value $22H00
        $obj | Add-Member -MemberType NoteProperty -Name "23H00"-Value $23H00
        $array.Add($obj) | Out-Null
            
        Write-Host "[$($cpt)/$($count)]  ---- done" -ForegroundColor Green
        $cpt ++;

    }
    $array | Select-Object day, Label, FootfallText, NoProcessing, 0H00, 1H00, 2H00, 3H00, 4H00, 5H00, 6H00, 7H00, 8H00, 9H00, 10H00, 11H00, 12H00, 13H00, 14H00, 15H00, 16H00, 17H00, 18H00, 19H00, 20H00, 21H00, 22H00, 23H00 | Export-Csv -Encoding UTF8 -notypeinformation -Path $outputFilePath
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
ExtractPIFootfallDay $RegionName $MallName $Language