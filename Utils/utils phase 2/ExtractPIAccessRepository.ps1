function ExtractPIAccessRepository {
    param (
        [Parameter(Mandatory = $true, Position = 0 )]
        [string]$RegionName,
        [Parameter(Mandatory = $true, Position = 1 )]
        [string]$MallName,
        [Parameter(Mandatory = $true, Position = 2 )]
        [string]$Language
    )

    $AccesRepositoryPath = "master:/sitecore/content/Klepierre/$RegionName/$MallName/Home/Practical Information/Access Repository"

    $ARs = Get-ChildItem -Path $AccesRepositoryPath -Language $Language | Where { $_.TemplateID -eq "{3BB963C9-FD3F-4C75-B3EC-933481337F45}" }
    $count = $ARs.Count
    $cpt = 1
    $outputFilePath = "$($AppPath)/Access Repository_$($MallName).csv"
    $array = New-Object System.Collections.ArrayList

    foreach ($ar in $ARs) {
        $ItemName = $ar.Name

        $Title = $ar['Title']
        $description = $ar['Description']

        $obj = New-Object System.Object

        $obj | Add-Member -MemberType NoteProperty -Name "Name" -Value  $ItemName
        $obj | Add-Member -MemberType NoteProperty -Name "Title" -Value  $Title
        $obj | Add-Member -MemberType NoteProperty -Name "description" -Value  $description
        $array.Add($obj) | Out-Null
            
        Write-Host "[$($cpt)/$($count)]  $ItemName ---- done" -ForegroundColor Green
        $cpt ++;
         
    }
    $array | Select-Object Name, Title, Description| Export-Csv -Encoding UTF8 -notypeinformation -Path $outputFilePath
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
ExtractPIAccessRepository $RegionName $MallName $Language