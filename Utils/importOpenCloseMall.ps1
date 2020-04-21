function Get-Name-By-ID($ID) {
    $listId = $null
    $listName = $null
    if ($ID.Contains('|')) {
        $listId = $ID.split('|')
        foreach ($list in $listId) {
            if ($list.Trim() -ne $null -and $list.Contains("{")) {
                $var = Get-Item $list
                $listName = "$($listName)|$($var.Name)".substring(1)
            }
        }
    }
    else {
        # $listId = $ID
        $var = Get-Item $ID
        $listName = "$($var.Name)"
    }
    return $listName
}
function IsDerived {
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)] $Item,
        [Parameter(Mandatory = $true)] $TemplateId
    )
    return [Sitecore.Data.Managers.TemplateManager]::GetTemplate($item).InheritsFrom($TemplateId)
}
function Reformat-Hour($Hours) {
    $split = $Hours.Split('T')
    $hs = $split[1]
    $Hh = $hs.substring(0, 2)
    $Mm = $hs.substring(2, 2)
    # $Ss = $hs.substring(4,2)
    return "$($Hh):$($Mm)"
}
function Export-Malls {

    param (
        [Parameter(Mandatory = $true, Position = 0 )]
        [string]$RegionName,
    
        [Parameter(Mandatory = $true, Position = 1 )]
        [string]$Language,
    
        [Parameter(Mandatory = $true, Position = 2 )]
        [string]$MallName
    )
    begin {
        Write-Host "Export-Stores-Contents Begin"
    }

    process {

        $outputFilePath = "$($AppPath)/$($RegionName)_$($MallName).csv"
        $array = New-Object System.Collections.ArrayList
        
        $OpeningHoursRepository = "master:/sitecore/content/Klepierre/$RegionName/$MallName/Home/Practical Information/Opening Hours Repository"
        # $ShopItem = Get-Item -Path $shopPath -Language $Language
        $day = Get-ChildItem -Path $OpeningHoursRepository -Language $Language | Where { $_.TemplateID -eq "{6C32F517-77B1-4E0C-B8CE-D1FE77E25563}" -or $_.TemplateID -eq "{A496118C-D0EF-440D-8DF5-5DEFE47E662E}" }
        # $shopChildItems = $ShopItem.Children | Where-Object { $_ | IsDerived -TemplateId "{80D19FA2-B1EF-4E32-93BD-4B2C650A126F}" }
        $count = $day.Count
        $cpt = 1

        # foreach ($day in $Days) {
            # $Fields = $day.Fields
            #need to get the children item
            $MondayOpening = if (![string]::IsNullOrEmpty($day[0].Fields['Opening Time'].Value)) { Reformat-Hour($day[0].Fields['Opening Time'].Value) } else { "" }
            $MondayClosing = if (![string]::IsNullOrEmpty($day[0].Fields['Closing Time'].Value)) { Reformat-Hour($day[0].Fields['Closing Time'].Value) } else { "" }
            $TuesdayOpening = if (![string]::IsNullOrEmpty($day[1].Fields['Opening Time'].Value)) { Reformat-Hour($day[1].Fields['Opening Time'].Value) } else { "" }
            $TuesdayClosing = if (![string]::IsNullOrEmpty($day[1].Fields['Closing Time'].Value)) { Reformat-Hour($day[1].Fields['Closing Time'].Value) } else { "" }
            $WednesdayOpening = if (![string]::IsNullOrEmpty($day[2].Fields['Opening Time'].Value)) { Reformat-Hour($day[2].Fields['Opening Time'].Value) } else { "" }
            $WednesdayClosing = if (![string]::IsNullOrEmpty($day[2].Fields['Closing Time'].Value)) { Reformat-Hour($day[2].Fields['Closing Time'].Value) } else { "" }
            $ThursdayOpening = if (![string]::IsNullOrEmpty($day[3].Fields['Opening Time'].Value)) { Reformat-Hour($day[3].Fields['Opening Time'].Value) } else { "" }
            $ThursdayClosing = if (![string]::IsNullOrEmpty($day[3].Fields['Closing Time'].Value)) { Reformat-Hour($day[3].Fields['Closing Time'].Value) } else { "" }
            $FridayOpening = if (![string]::IsNullOrEmpty($day[4].Fields['Opening Time'].Value)) { Reformat-Hour($day[4].Fields['Opening Time'].Value) } else { "" }
            $FridayClosing = if (![string]::IsNullOrEmpty($day[4].Fields['Closing Time'].Value)) { Reformat-Hour($day[4].Fields['Closing Time'].Value) } else { "" }
            $SaturdayOpening = if (![string]::IsNullOrEmpty($day[5].Fields['Opening Time'].Value)) { Reformat-Hour($day[5].Fields['Opening Time'].Value) } else { "" }
            $SaturdayClosing = if (![string]::IsNullOrEmpty($day[5].Fields['Closing Time'].Value)) { Reformat-Hour($day[5].Fields['Closing Time'].Value) } else { "" }
            $SundayOpening = if (![string]::IsNullOrEmpty($day[6].Fields['Opening Time'].Value)) { Reformat-Hour($day[6].Fields['Opening Time'].Value) } else { "" }
            $SundayClosing = if (![string]::IsNullOrEmpty($day[6].Fields['Closing Time'].Value)) { Reformat-Hour($day[6].Fields['Closing Time'].Value) } else { "" }

            $obj = New-Object System.Object

            $obj | Add-Member -MemberType NoteProperty -Name "Region" -Value  $RegionName
            $obj | Add-Member -MemberType NoteProperty -Name "Mall" -Value  $MallName
            $obj | Add-Member -MemberType NoteProperty -Name "MondayOpening" -Value  $MondayOpening
            $obj | Add-Member -MemberType NoteProperty -Name "MondayClosing" -Value  $MondayClosing
            $obj | Add-Member -MemberType NoteProperty -Name "TuesdayOpening" -Value  $TuesdayOpening
            $obj | Add-Member -MemberType NoteProperty -Name "TuesdayClosing" -Value  $TuesdayClosing
            $obj | Add-Member -MemberType NoteProperty -Name "WednesdayOpening" -Value  $WednesdayOpening
            $obj | Add-Member -MemberType NoteProperty -Name "WednesdayClosing" -Value  $WednesdayClosing
            $obj | Add-Member -MemberType NoteProperty -Name "ThursdayOpening" -Value  $ThursdayOpening
            $obj | Add-Member -MemberType NoteProperty -Name "ThursdayClosing" -Value  $ThursdayClosing
            $obj | Add-Member -MemberType NoteProperty -Name "FridayOpening" -Value  $FridayOpening
            $obj | Add-Member -MemberType NoteProperty -Name "FridayClosing" -Value  $FridayClosing
            $obj | Add-Member -MemberType NoteProperty -Name "SaturdayOpening" -Value  $SaturdayOpening
            $obj | Add-Member -MemberType NoteProperty -Name "SaturdayClosing" -Value  $SaturdayClosing
            $obj | Add-Member -MemberType NoteProperty -Name "SundayOpening" -Value  $SundayOpening
            $obj | Add-Member -MemberType NoteProperty -Name "SundayClosing" -Value  $SundayClosing

            $array.Add($obj) | Out-Null
            
            Write-Host "[$($cpt)/$($count)] $($MallName) ---- done" -ForegroundColor Green
            $cpt ++;
        # }
        $array | Select-Object Region, Mall, MondayOpening, MondayClosing, TuesdayOpening, TuesdayClosing, WednesdayOpening, WednesdayClosing, ThursdayOpening, ThursdayClosing, FridayOpening, FridayClosing, SaturdayOpening, SaturdayClosing, SundayOpening, SundayClosing | Export-Csv -Encoding UTF8 -notypeinformation -Path $outputFilePath
        Try {
            Send-File -Path $outputFilePath
        }
        Finally {
            Remove-Item -Path $outputFilePath
        }
    }

    end {
        Write-Host "Export-Stores-Contents End"
    }
}



function runExport {
    $regions = Get-ChildItem -Path "/sitecore/content/Klepierre/" | Where { $_.TemplateID -eq "{CE91FBD6-4D89-42C9-B5BC-2A670439E1FF}" -and !($_.Name -match "^Master") }
    foreach ($region in $regions) {
        $RegionName = $region.Name
        Write-Host "$RegionName Update - Begin"
        $malls = Get-ChildItem -Item $region | Where { $_.TemplateID -eq "{46591E02-8902-4C2C-AF61-3EB92BE2489A}" }
        foreach ($mall in $malls) {
            $mallName = $mall.Name

            $settingPath = "$($mall.FullPath)/Settings/Site Grouping/$mallName"
            $settingItem = Get-Item -Path $settingPath
            $version = $settingItem["Language"]
            if ($mallName -eq "MaremagnumES") {
                Export-Malls $RegionName $version $mallName
            }
        }
    }  
}

runExport