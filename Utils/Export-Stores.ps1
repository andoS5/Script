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

        $outputFilePath = "$($AppPath)/Stores_$($MallName).csv"
        $array = New-Object System.Collections.ArrayList
        
        $shopPath = "master:/sitecore/content/Klepierre/$($RegionName)/$($MallName)/Home/Shop Repository"
        # $ShopItem = Get-Item -Path $shopPath -Language $Language
        $shopChildItems = Get-ChildItem -Path $shopPath -Language $Language | Where { $_.TemplateID -eq "{80D19FA2-B1EF-4E32-93BD-4B2C650A126F}" -or $_.TemplateID -eq "{A496118C-D0EF-440D-8DF5-5DEFE47E662E}"}
        # $shopChildItems = $ShopItem.Children | Where-Object { $_ | IsDerived -TemplateId "{80D19FA2-B1EF-4E32-93BD-4B2C650A126F}" }
        $count = $shopChildItems.Count
        $cpt = 1

        foreach ($shopChildItem in $shopChildItems) {
            $Fields = $shopChildItem.Fields
            $BackgroundImageRaw = $Fields['Background Image'].Value
            $BackgroundImage = if (![string]::IsNullOrEmpty($BackgroundImageRaw)) { Get-Item $BackgroundImageRaw } else { "" }
            $MobileImageRaw = $Fields['Mobile Image'].Value
            $MobileImage = if (![string]::IsNullOrEmpty($MobileImageRaw)) { Get-Item $MobileImageRaw } else { "" }
            $TabletImageRaw = $Fields['Tablet Image'].Value
            $TabletImage = if (![string]::IsNullOrEmpty($TabletImageRaw)) { Get-Item $TabletImageRaw } else { "" }
            $LargeImageRaw = $Fields['Large Image'].Value
            $LargeImage = if (![string]::IsNullOrEmpty($LargeImageRaw)) { Get-Item $LargeImageRaw } else { "" }
            $OpenGraphImageRaw = $Fields['Open Graph Image'].Value
            $OpenGraphImage = if (![string]::IsNullOrEmpty($OpenGraphImageRaw)) { Get-Item $OpenGraphImageRaw } else { "" }
            $ShopImageRaw = $Fields['Shop Image'].Value
            $ShopImage = if (![string]::IsNullOrEmpty($ShopImageRaw)) { Get-Item $ShopImageRaw } else { "" }
            $CategorySeleted = if(![string]::IsNullOrEmpty($Fields['Category'].Value)) { Get-Name-By-ID($Fields['Category'].Value)} else { "" }#pipe
            $SubCategorySelected = if(![string]::IsNullOrEmpty($Fields['Sub Category'].Value)) { Get-Name-By-ID($Fields['Sub Category'].Value)} else { "" } #pipe
            $ServicesSelected = if(![string]::IsNullOrEmpty($Fields['Services'].Value)) { Get-Name-By-ID($Fields['Services'].Value)} else { "" }  #pipe
            $FacebookUrlRaw = ((Select-String '(http[s]?)(:\/\/)([^\s,]+)(?=")' -Input $Fields['Facebook Url'].Value).Matches.Value)
            $FacebookUrl = if (![string]::IsNullOrEmpty($FacebookUrlRaw)) { $FacebookUrlRaw } else { "" }
            $TwitterUrlRaw = ((Select-String '(http[s]?)(:\/\/)([^\s,]+)(?=")' -Input $Fields['Twitter Url'].Value).Matches.Value)
            $TwitterUrl = if (![string]::IsNullOrEmpty($TwitterUrlRaw)) { $TwitterUrlRaw } else { "" }
            $InstagramUrlRaw = ((Select-String '(http[s]?)(:\/\/)([^\s,]+)(?=")' -Input $Fields['Instagram Url'].Value).Matches.Value)
            $InstagramUrl = if (![string]::IsNullOrEmpty($InstagramUrlRaw)) { $InstagramUrlRaw } else { "" }
            $StoreWebsiteUrlRaw = ((Select-String '(http[s]?)(:\/\/)([^\s,]+)(?=")' -Input $Fields['Store Website Url'].Value).Matches.Value)
            $StoreWebsiteUrl = if (![string]::IsNullOrEmpty($StoreWebsiteUrlRaw)) { $StoreWebsiteUrlRaw } else { "" }
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
            $obj | Add-Member -MemberType NoteProperty -Name "Showonbreadcrumb" -Value  $Fields['Show on breadcrumb'].Value
            $obj | Add-Member -MemberType NoteProperty -Name "PageDesign" -Value  $Fields['Page Design'].Value
            $obj | Add-Member -MemberType NoteProperty -Name "BannerTitle" -Value  $Fields['Banner Title'].Value
            $obj | Add-Member -MemberType NoteProperty -Name "BackgroundImage" -Value  $BackgroundImage.Name
            $obj | Add-Member -MemberType NoteProperty -Name "MobileImage" -Value  $MobileImage.Name
            $obj | Add-Member -MemberType NoteProperty -Name "TabletImage" -Value  $TabletImage.Name
            $obj | Add-Member -MemberType NoteProperty -Name "LargeImage" -Value  $LargeImage.Name
            $obj | Add-Member -MemberType NoteProperty -Name "Parking" -Value  $Fields['Parking'].Value
            $obj | Add-Member -MemberType NoteProperty -Name "Gate"     -Value  $Fields['Gate'].Value
            $obj | Add-Member -MemberType NoteProperty -Name "placeId"     -Value  $Fields['placeId'].Value
            $obj | Add-Member -MemberType NoteProperty -Name "placeAlias"      -Value  $Fields['placeAlias'].Value
            $obj | Add-Member -MemberType NoteProperty -Name "PageTitle"  -Value  $Fields['Page Title'].Value
            $obj | Add-Member -MemberType NoteProperty -Name "MetaDescription" -Value  $Fields['Meta Description'].Value
            $obj | Add-Member -MemberType NoteProperty -Name "CanonicalUrl" -Value  $Fields['Canonical Url'].Value
            $obj | Add-Member -MemberType NoteProperty -Name "OpenGraphImage" -Value  $OpenGraphImage.Name
            $obj | Add-Member -MemberType NoteProperty -Name "Description" -Value  $Fields['Description'].Value
            $obj | Add-Member -MemberType NoteProperty -Name "Contact" -Value  $Fields['Contact'].Value
            $obj | Add-Member -MemberType NoteProperty -Name "OpeningDate" -Value  $Fields['Opening Date'].Value
            $obj | Add-Member -MemberType NoteProperty -Name "Changefrequency" -Value  $Fields['Change frequency'].Value
            $obj | Add-Member -MemberType NoteProperty -Name "Priority" -Value  $Fields['Priority'].Value
            $obj | Add-Member -MemberType NoteProperty -Name "ShopImage" -Value  $ShopImage.Name
            $obj | Add-Member -MemberType NoteProperty -Name "Category" -Value  $CategorySeleted
            $obj | Add-Member -MemberType NoteProperty -Name "SubCategory" -Value  $SubCategorySelected
            $obj | Add-Member -MemberType NoteProperty -Name "Services" -Value  $ServicesSelected
            $obj | Add-Member -MemberType NoteProperty -Name "FacebookUrl" -Value  $FacebookUrl
            $obj | Add-Member -MemberType NoteProperty -Name "TwitterUrl" -Value  $TwitterUrl
            $obj | Add-Member -MemberType NoteProperty -Name "InstagramUrl" -Value  $InstagramUrl
            $obj | Add-Member -MemberType NoteProperty -Name "StoreWebsiteUrl" -Value  $StoreWebsiteUrl
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
        $array | Select-Object ShopTitle, Breadcrumbtitle, Showonbreadcrumb, PageDesign, BannerTitle, BackgroundImage, MobileImage, TabletImage, LargeImage, Parking, Gate, placeId, placeAlias, PageTitle, MetaDescription, CanonicalUrl, OpenGraphImage, Description, Contact, OpeningDate, Changefrequency, Priority, ShopImage, Category, SubCategory, Services, FacebookUrl, TwitterUrl, InstagramUrl, StoreWebsiteUrl, MondayOpening, MondayClosing, TuesdayOpening, TuesdayClosing, WednesdayOpening, WednesdayClosing, ThursdayOpening, ThursdayClosing, FridayOpening, FridayClosing, SaturdayOpening, SaturdayClosing, SundayOpening, SundayClosing | Export-Csv -Encoding UTF8 -notypeinformation -Path $outputFilePath
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

Export-Stores "France" "fr-Fr" "Arcades"