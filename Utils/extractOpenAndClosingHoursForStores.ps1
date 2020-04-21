function Get-Name-By-ID($ID) {
    $listId = $null
    $listName = $null
    if ($ID.Contains('|')) {
        $listId = $ID.split('|')
        foreach ($list in $listId) {
            if($list.Trim() -ne $null -and $list.Contains("{")){
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
function Export-Stores {

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

        $outputFilePath = "$($AppPath)/OCStores_$($MallName).csv"
        $array = New-Object System.Collections.ArrayList
        
        $shopPath = "master:/sitecore/content/Klepierre/$($RegionName)/$($MallName)/Home/Shop Repository"
        # $ShopItem = Get-Item -Path $shopPath -Language $Language
        $shopChildItems = Get-ChildItem -Path $shopPath -Language $Language | Where { $_.TemplateID -eq "{80D19FA2-B1EF-4E32-93BD-4B2C650A126F}" -or $_.TemplateID -eq "{A496118C-D0EF-440D-8DF5-5DEFE47E662E}"}
        # $shopChildItems = $ShopItem.Children | Where-Object { $_ | IsDerived -TemplateId "{80D19FA2-B1EF-4E32-93BD-4B2C650A126F}" }
        $count = $shopChildItems.Count
        $cpt = 1

        foreach ($shopChildItem in $shopChildItems) {
            $Fields = $shopChildItem.Fields
            $shopID = $shopChildItem.ID
            $child = $shopChildItem.children
            $MondayOpening = $null
            $MondayClosing = $null
            $TuesdayOpening = $null
            $TuesdayClosing = $null
            $WednesdayOpening = $null
            $WednesdayClosing = $null
            $ThursdayOpening = $null
            $ThursdayClosing = $null
            $FridayOpening = $null
            $FridayClosing = $null
            $SaturdayOpening = $null
            $SaturdayClosing = $null
            $SundayOpening = $null
            $SundayClosing = $null
            if ($child.Count -gt 0) {
                $days = $child.children
                #need to get the children item
                $MondayOpening = if(![string]::IsNullOrEmpty($days[0].Fields['Opening Time'].Value)) {Reformat-Hour($days[0].Fields['Opening Time'].Value)} else { "" }
                $MondayClosing = if(![string]::IsNullOrEmpty($days[0].Fields['Closing Time'].Value)) {Reformat-Hour($days[0].Fields['Closing Time'].Value)} else { "" }
                $TuesdayOpening = if(![string]::IsNullOrEmpty($days[1].Fields['Opening Time'].Value)) {Reformat-Hour($days[1].Fields['Opening Time'].Value)} else { "" }
                $TuesdayClosing = if(![string]::IsNullOrEmpty($days[1].Fields['Closing Time'].Value)) {Reformat-Hour($days[1].Fields['Closing Time'].Value)} else { "" }
                $WednesdayOpening = if(![string]::IsNullOrEmpty($days[2].Fields['Opening Time'].Value)) {Reformat-Hour($days[2].Fields['Opening Time'].Value)} else { "" }
                $WednesdayClosing = if(![string]::IsNullOrEmpty($days[2].Fields['Closing Time'].Value)) {Reformat-Hour($days[2].Fields['Closing Time'].Value)} else { "" }
                $ThursdayOpening = if(![string]::IsNullOrEmpty($days[3].Fields['Opening Time'].Value)) {Reformat-Hour($days[3].Fields['Opening Time'].Value)} else { "" }
                $ThursdayClosing = if(![string]::IsNullOrEmpty($days[3].Fields['Closing Time'].Value)) {Reformat-Hour($days[3].Fields['Closing Time'].Value)} else { "" }
                $FridayOpening = if(![string]::IsNullOrEmpty($days[4].Fields['Opening Time'].Value)) {Reformat-Hour($days[4].Fields['Opening Time'].Value)} else { "" }
                $FridayClosing = if(![string]::IsNullOrEmpty($days[4].Fields['Closing Time'].Value)) {Reformat-Hour($days[4].Fields['Closing Time'].Value)} else { "" }
                $SaturdayOpening = if(![string]::IsNullOrEmpty($days[5].Fields['Opening Time'].Value)) {Reformat-Hour($days[5].Fields['Opening Time'].Value)} else { "" }
                $SaturdayClosing = if(![string]::IsNullOrEmpty($days[5].Fields['Closing Time'].Value)) {Reformat-Hour($days[5].Fields['Closing Time'].Value)} else { "" }
                $SundayOpening = if(![string]::IsNullOrEmpty($days[6].Fields['Opening Time'].Value)) {Reformat-Hour($days[6].Fields['Opening Time'].Value)} else { "" }
                $SundayClosing = if(![string]::IsNullOrEmpty($days[6].Fields['Closing Time'].Value)) {Reformat-Hour($days[6].Fields['Closing Time'].Value)} else { "" }
            }


            $obj = New-Object System.Object

            $obj | Add-Member -MemberType NoteProperty -Name "ShopTitle" -Value  $Fields['Shop Title'].Value
            $obj | Add-Member -MemberType NoteProperty -Name "Breadcrumbtitle" -Value  $Fields['Breadcrumb title'].Value
            $obj | Add-Member -MemberType NoteProperty -Name "ShopID" -Value  $shopID
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
            
            Write-Host "[$($cpt)/$($count)] $($Fields['Shop Title'].Value) ---- done" -ForegroundColor Green
            $cpt ++;
        }
        $array | Select-Object ShopTitle, Breadcrumbtitle, shopID, MondayOpening, MondayClosing, TuesdayOpening, TuesdayClosing, WednesdayOpening, WednesdayClosing, ThursdayOpening, ThursdayClosing, FridayOpening, FridayClosing, SaturdayOpening, SaturdayClosing, SundayOpening, SundayClosing | Export-Csv -Encoding UTF8 -notypeinformation -Path $outputFilePath
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
        Write-Host "$RegionName --- Region skipped"
        $malls = Get-ChildItem -Item $region | Where { $_.TemplateID -eq "{46591E02-8902-4C2C-AF61-3EB92BE2489A}" }
        foreach ($mall in $malls) {
            $mallName = $mall.Name

            $settingPath = "$($mall.FullPath)/Settings/Site Grouping/$mallName"
            $settingItem = Get-Item -Path $settingPath
            $version = $settingItem["Language"]
            if($RegionName -eq "Norway"){
                Export-Stores $RegionName $version $mallName
                # Export-Stores "France" "fr-Fr" "Arcades"
            }
            

        }
    }  
}

runExport
