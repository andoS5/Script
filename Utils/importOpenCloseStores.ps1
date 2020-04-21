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

        $outputFilePath = "$($AppPath)/Stores_$($MallName).csv"
        $array = New-Object System.Collections.ArrayList
        
        $shopPath = "master:/sitecore/content/Klepierre/$($RegionName)/$($MallName)/Home/Shop Repository"
        # $ShopItem = Get-Item -Path $shopPath -Language $Language
        $shopChildItems = Get-ChildItem -Path $shopPath -Language $Language | Where { $_.TemplateID -eq "{80D19FA2-B1EF-4E32-93BD-4B2C650A126F}" -or $_.TemplateID -eq "{A496118C-D0EF-440D-8DF5-5DEFE47E662E}" }
        # $shopChildItems = $ShopItem.Children | Where-Object { $_ | IsDerived -TemplateId "{80D19FA2-B1EF-4E32-93BD-4B2C650A126F}" }
        $count = $shopChildItems.Count
        $cpt = 1

        foreach ($shopChildItem in $shopChildItems) {
            $Fields = $shopChildItem.Fields
            $shopID = $shopChildItem.ID
            $obj = New-Object System.Object

            $obj | Add-Member -MemberType NoteProperty -Name "RegionName" -Value  $RegionName
            $obj | Add-Member -MemberType NoteProperty -Name "MallName" -Value  $MallName
            $obj | Add-Member -MemberType NoteProperty -Name "Language" -Value  $Language
            $obj | Add-Member -MemberType NoteProperty -Name "ShopID" -Value  $shopID
            $obj | Add-Member -MemberType NoteProperty -Name "ShopTitle" -Value  $Fields['Shop Title'].Value
            $obj | Add-Member -MemberType NoteProperty -Name "Breadcrumbtitle" -Value  $Fields['Breadcrumb title'].Value
            $obj | Add-Member -MemberType NoteProperty -Name "Monday" -Value  ""
            $obj | Add-Member -MemberType NoteProperty -Name "Tuesday" -Value  ""
            $obj | Add-Member -MemberType NoteProperty -Name "Wednesday" -Value  ""
            $obj | Add-Member -MemberType NoteProperty -Name "Thursday" -Value  ""
            $obj | Add-Member -MemberType NoteProperty -Name "Friday" -Value  ""
            $obj | Add-Member -MemberType NoteProperty -Name "Saturday" -Value  ""
            $obj | Add-Member -MemberType NoteProperty -Name "Sunday" -Value  ""

            $array.Add($obj) | Out-Null
            
            Write-Host "[$($cpt)/$($count)] $($Fields['Shop Title'].Value) ---- done" -ForegroundColor Green
            $cpt ++;
        }
        $array | Select-Object RegionName, MallName, Language, ShopID, ShopTitle, Breadcrumbtitle, Monday, Tuesday, Wednesday, Thursday, Friday, Saturday, Sunday | Export-Csv -Encoding UTF8 -notypeinformation -Path $outputFilePath
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
            if($RegionName -eq "Norway"){
                Export-Stores $RegionName $version $mallName
            }
            

        }
    }  
}

runExport