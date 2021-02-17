function Reformat-Hour($Hours) {
    $split = $Hours.Split('T')
    $hs = $split[1]
    $Hh = $hs.substring(0, 2)
    $Mm = $hs.substring(2, 2)
    # $Ss = $hs.substring(4,2)
    return "$($Hh):$($Mm)"
}

function Get-Name-By-ID($ID) {
    $listId = $null
    $listName = $null
    if ($ID.Contains('|')) {
        $listId = $ID.split('|')
        foreach ($list in $listId) {
            if ($list.Trim() -ne $null -and $list.Contains("{")) {
                $var = Get-Item master: -ID $list
                $listName = "$($listName)|$($var.Name)".substring(1)
            }
        }
    }
    else {
        # $listId = $ID
        $var = if (![string]::IsNullOrEmpty($ID)) {
            $var = Get-Item master: -ID $ID
            $listName = "$($var.Name)"
        }
        else {
            $listName = ""
        }
        
    }
    return $listName
}
function ExtractParkingRepository {
    param (
        [Parameter(Mandatory = $true, Position = 0 )]
        [string]$RegionName,
        [Parameter(Mandatory = $true, Position = 1 )]
        [string]$MallName,
        [Parameter(Mandatory = $true, Position = 2 )]
        [string]$Language
    )

    process {

        $outputFilePath = "$($AppPath)/Parking Repository - $MallName.csv"
        $array = New-Object System.Collections.ArrayList
        
        $cpt = 1

        $parkingRepository = "master:/sitecore/content/Klepierre/$RegionName/$MallName/Selections/Parking Repository"
        $parking = Get-ChildItem -Path $parkingRepository -Language $Language | Where { $_.TemplateID -eq "{68C94967-9BA2-40A5-9694-91C5A88324ED}" }
        # $parkingCount = $parking.Count

        foreach ($p in $parking) {
            
            $order = @('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday')
            $ParkingSchedule = $p.children
            $count = $ParkingSchedule.Count
            $ScheduleArray = [System.Collections.ArrayList]@() 
    
            foreach ($o in $order) {
                foreach ($ps in $ParkingSchedule) {
                    if ($ps.Name -eq $o) {
                        $ScheduleArray.Add($ps) | Out-Null
                    }
                }
            }
               
            foreach ($schedule in $ScheduleArray) {
                $parkingName = $p.Name
                $day = Get-Name-By-ID($schedule['Day'])
                $IsClosed = $schedule['Close']
                $ClosingTime = Reformat-Hour $schedule['Closing Time']
                $OpeningTime = Reformat-Hour $schedule['Opening Time']
    
                $obj = New-Object System.Object
    
                $obj | Add-Member -MemberType NoteProperty -Name "ParkingName"-Value $parkingName
                $obj | Add-Member -MemberType NoteProperty -Name "Day"-Value $day
                $obj | Add-Member -MemberType NoteProperty -Name "IsClosed"-Value $IsClosed
                $obj | Add-Member -MemberType NoteProperty -Name "ClosingTime"-Value $ClosingTime
                $obj | Add-Member -MemberType NoteProperty -Name "OpeningTime"-Value $OpeningTime
    
                $array.Add($obj) | Out-Null         
                Write-Host "[$($cpt)/$($count)]  ---- done" -ForegroundColor Green
                $cpt ++;
            }
            
        }
        $array | Select-Object ParkingName, Day, IsClosed, OpeningTime, ClosingTime | Export-Csv -Encoding UTF8 -notypeinformation -Path $outputFilePath
        Try {
            Send-File -Path $outputFilePath
        }
        Finally {
            Remove-Item -Path $outputFilePath
        }
    }
}

$RegionName = "France"
$MallName = "Odysseum"
$Language = "fr-fr"
ExtractParkingRepository $RegionName $MallName $Language
