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

function Get-Image-Item-Id {
    param (
        [Parameter(Mandatory = $true, Position = 0 )]
        [string]$RawValue
    )
    process {
        $ResultRegex = "(?<={)(.*)(?=})"

        $Regex = [Regex]::new("$ResultRegex")       
        $Result = $Regex.Match($RawValue)   
        if ($Result.Success) {           
            return "{$($Result.Value)}"         
        }
    }
}

function Export-Stores {

    param (
        [Parameter(Mandatory = $true, Position = 0 )]
        [string]$RegionName,
        [Parameter(Mandatory = $true, Position = 1 )]
        [string]$MallName,
        [Parameter(Mandatory = $true, Position = 2 )]
        [string]$Language
    )
    begin {
        Write-Host "Export-Stores-Contents Begin"
    }

    process {

        $outputFilePath = "$($AppPath)/Stores_$($MallName).csv"
        $array = New-Object System.Collections.ArrayList
        
        $shopPath = "master:/sitecore/content/Klepierre/$($RegionName)/$($MallName)/Home/Shop Repository"
        $shopChildItems = Get-ChildItem -Path $shopPath -Language $Language | Where { $_.TemplateID -eq "{80D19FA2-B1EF-4E32-93BD-4B2C650A126F}" -or $_.TemplateID -eq "{A496118C-D0EF-440D-8DF5-5DEFE47E662E}" }
        $count = $shopChildItems.Count
        $cpt = 1

        foreach ($shopChildItem in $shopChildItems) {
            $Fields = $shopChildItem.Fields
            $pageDesign = $Fields['Page Design'].Value
            $pageDesignItem = if (![string]::IsNullOrEmpty($pageDesign)) { Get-Image-Item-Id $pageDesign } else { "" }

            $BackgroundImageRaw = $Fields['Background Image'].Value
            $BackgroundImageID = if (![string]::IsNullOrEmpty($BackgroundImageRaw)) { Get-Image-Item-Id $BackgroundImageRaw } else { "" }
            $BackgroundImage = if (![string]::IsNullOrEmpty($BackgroundImageID)) { Get-Item master: -ID $BackgroundImageID }

            $MobileImageRaw = $Fields['Mobile Image'].Value
            $MobileImageID = if (![string]::IsNullOrEmpty($MobileImageRaw)) { Get-Image-Item-Id $MobileImageRaw } else { "" }
            $MobileImage = if (![string]::IsNullOrEmpty($MobileImageID)) { Get-Item master: -ID $MobileImageID }

            $brand = $Fields["Brand"]
            $brandName = if (![string]::IsNullOrEmpty($brand)) { Get-Item master: -ID $brand -Language $Language } else { "" }
          
            $OpeningDate = if (![string]::IsNullOrEmpty($Fields['Opening Date'].Value)) { Reformat-Hour($Fields['Opening Date'].Value) }

            $gate = $Fields['Gate'].Value
            $gateItem = if (![string]::IsNullOrEmpty($gate)) { Get-Item master: -ID $gate -Language $Language } else { "" }

            $TabletImageRaw = $Fields['Tablet Image'].Value
            $TabletImageID = if (![string]::IsNullOrEmpty($TabletImageRaw)) { Get-Image-Item-Id $TabletImageRaw } else { "" }
            $TabletImage = if (![string]::IsNullOrEmpty($TabletImageID)) { Get-Item master: -ID $TabletImageID }

            $LargeImageRaw = $Fields['Large Image'].Value
            $LargeImageID = if (![string]::IsNullOrEmpty($LargeImageRaw)) { Get-Image-Item-Id $LargeImageRaw } else { "" }
            $LargeImage = if (![string]::IsNullOrEmpty($LargeImageID)) { Get-Item master: -ID $LargeImageID }

            $OpenGraphImageRaw = $Fields['Open Graph Image'].Value
            $OpenGraphImageID = if (![string]::IsNullOrEmpty($OpenGraphImageRaw)) { Get-Image-Item-Id $OpenGraphImageRaw } else { "" }
            $OpenGraphImage = if (![string]::IsNullOrEmpty($OpenGraphImageID)) { Get-Item master: -ID $OpenGraphImageID }
            
            $ShopImage = ""
            $shopTitle = ""
            $popUp = ""
            $itemType = ""
            if ($shopChildItem.TemplateID -eq "{80D19FA2-B1EF-4E32-93BD-4B2C650A126F}") {
                $ShopImageRaw = $Fields['Shop Image'].Value
                $ShopImageID = if (![string]::IsNullOrEmpty($ShopImageRaw)) { Get-Image-Item-Id $ShopImageRaw } else { "" }
                $ShopImage = if (![string]::IsNullOrEmpty($ShopImageID)) { Get-Item master: -ID $ShopImageID }

                $shopTitle = $Fields['Shop Title'].Value
                $popUp = $Fields["Pop-Up"]
                $itemType = "Shop"
            }
            else {
                $RestaurantImageRaw = $Fields['Restaurant Image'].Value
                $RestaurantImageID = if (![string]::IsNullOrEmpty($RestaurantImageRaw)) { Get-Image-Item-Id $RestaurantImageRaw } else { "" }
                $ShopImage = if (![string]::IsNullOrEmpty($RestaurantImageID)) { Get-Item master: -ID $RestaurantImageID }

                $shopTitle = $Fields['Restaurant Title'].Value
                $itemType = "Restaurant"
            }
            
            $CategorySeleted = if (![string]::IsNullOrEmpty($Fields['Category'].Value)) { Get-Name-By-ID($Fields['Category'].Value) } else { "" }#pipe
            $SubCategorySelected = if (![string]::IsNullOrEmpty($Fields['Sub Category'].Value)) { Get-Name-By-ID($Fields['Sub Category'].Value) } else { "" } #pipe
            $ServicesSelected = if (![string]::IsNullOrEmpty($Fields['Services'].Value)) { Get-Name-By-ID($Fields['Services'].Value) } else { "" }  #pipe
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
            $isClosedMonday = $null

            $TuesdayOpening = $null
            $TuesdayClosing = $null
            $isClosedTuesday = $null

            $WednesdayOpening = $null
            $WednesdayClosing = $null
            $isClosedWednesday = $null

            $ThursdayOpening = $null
            $ThursdayClosing = $null
            $isClosedThursday = $null

            $FridayOpening = $null
            $FridayClosing = $null
            $isClosedFriday = $null

            $SaturdayOpening = $null
            $SaturdayClosing = $null
            $isClosedSaturday = $null

            $SundayOpening = $null
            $SundayClosing = $null
            $isClosedSunday = $null

            if ($child.Count -gt 0) {
                $days = $child.children
                #need to get the children item
                $MondayOpening = if (![string]::IsNullOrEmpty($days[0].Fields['Opening Time'].Value)) { Reformat-Hour($days[0].Fields['Opening Time'].Value) } else { "" }
                $MondayClosing = if (![string]::IsNullOrEmpty($days[0].Fields['Closing Time'].Value)) { Reformat-Hour($days[0].Fields['Closing Time'].Value) } else { "" }
                $isClosedMonday = $days[0].Fields['Close'].Value
                $TuesdayOpening = if (![string]::IsNullOrEmpty($days[1].Fields['Opening Time'].Value)) { Reformat-Hour($days[1].Fields['Opening Time'].Value) } else { "" }
                $TuesdayClosing = if (![string]::IsNullOrEmpty($days[1].Fields['Closing Time'].Value)) { Reformat-Hour($days[1].Fields['Closing Time'].Value) } else { "" }
                $isClosedTuesday = $days[1].Fields['Close'].Value
                $WednesdayOpening = if (![string]::IsNullOrEmpty($days[2].Fields['Opening Time'].Value)) { Reformat-Hour($days[2].Fields['Opening Time'].Value) } else { "" }
                $WednesdayClosing = if (![string]::IsNullOrEmpty($days[2].Fields['Closing Time'].Value)) { Reformat-Hour($days[2].Fields['Closing Time'].Value) } else { "" }
                $isClosedWednesday = $days[2].Fields['Close'].Value
                $ThursdayOpening = if (![string]::IsNullOrEmpty($days[3].Fields['Opening Time'].Value)) { Reformat-Hour($days[3].Fields['Opening Time'].Value) } else { "" }
                $ThursdayClosing = if (![string]::IsNullOrEmpty($days[3].Fields['Closing Time'].Value)) { Reformat-Hour($days[3].Fields['Closing Time'].Value) } else { "" }
                $isClosedThursday = $days[3].Fields['Close'].Value
                $FridayOpening = if (![string]::IsNullOrEmpty($days[4].Fields['Opening Time'].Value)) { Reformat-Hour($days[4].Fields['Opening Time'].Value) } else { "" }
                $FridayClosing = if (![string]::IsNullOrEmpty($days[4].Fields['Closing Time'].Value)) { Reformat-Hour($days[4].Fields['Closing Time'].Value) } else { "" }
                $isClosedFriday = $days[4].Fields['Close'].Value
                $SaturdayOpening = if (![string]::IsNullOrEmpty($days[5].Fields['Opening Time'].Value)) { Reformat-Hour($days[5].Fields['Opening Time'].Value) } else { "" }
                $SaturdayClosing = if (![string]::IsNullOrEmpty($days[5].Fields['Closing Time'].Value)) { Reformat-Hour($days[5].Fields['Closing Time'].Value) } else { "" }
                $isClosedSaturday = $days[5].Fields['Close'].Value
                $SundayOpening = if (![string]::IsNullOrEmpty($days[6].Fields['Opening Time'].Value)) { Reformat-Hour($days[6].Fields['Opening Time'].Value) } else { "" }
                $SundayClosing = if (![string]::IsNullOrEmpty($days[6].Fields['Closing Time'].Value)) { Reformat-Hour($days[6].Fields['Closing Time'].Value) } else { "" }
                $isClosedSunday = $days[6].Fields['Close'].Value
            }

            $obj = New-Object System.Object

            $obj | Add-Member -MemberType NoteProperty -Name "ItemType" -Value  $itemType
            $obj | Add-Member -MemberType NoteProperty -Name "Breadcrumbtitle" -Value  $Fields['Breadcrumb title'].Value
            $obj | Add-Member -MemberType NoteProperty -Name "Showonbreadcrumb" -Value  $Fields['Show on breadcrumb'].Value
            $obj | Add-Member -MemberType NoteProperty -Name "PageDesign" -Value  $pageDesignItem.Name
            $obj | Add-Member -MemberType NoteProperty -Name "BannerTitle" -Value  $Fields['Banner Title'].Value
            $obj | Add-Member -MemberType NoteProperty -Name "BackgroundImage" -Value  $BackgroundImage.Name
            $obj | Add-Member -MemberType NoteProperty -Name "LargeImage" -Value  $LargeImage.Name
            $obj | Add-Member -MemberType NoteProperty -Name "MobileImage" -Value  $MobileImage.Name
            $obj | Add-Member -MemberType NoteProperty -Name "TabletImage" -Value  $TabletImage.Name
            $obj | Add-Member -MemberType NoteProperty -Name "ShopOrRestaurantImage" -Value  $ShopImage.Name
            $obj | Add-Member -MemberType NoteProperty -Name "ShopOrRestaurantTitle" -Value  $shopTitle 
            $obj | Add-Member -MemberType NoteProperty -Name "Description" -Value  $Fields['Description'].Value
            $obj | Add-Member -MemberType NoteProperty -Name "Contact" -Value  $Fields['Contact'].Value
            $obj | Add-Member -MemberType NoteProperty -Name "Playfull" -Value  $Fields['Playfull'].Value
            $obj | Add-Member -MemberType NoteProperty -Name "Brand" -Value  $brandName.Name
            $obj | Add-Member -MemberType NoteProperty -Name "OpeningDate" -Value  $OpeningDate
            $obj | Add-Member -MemberType NoteProperty -Name "popUp" -Value   $popUp
            $obj | Add-Member -MemberType NoteProperty -Name "Parking" -Value  $Fields['Parking'].Value
            $obj | Add-Member -MemberType NoteProperty -Name "Gate"     -Value  $gateItem.Name
            $obj | Add-Member -MemberType NoteProperty -Name "Category" -Value  $CategorySeleted
            $obj | Add-Member -MemberType NoteProperty -Name "SubCategory" -Value  $SubCategorySelected
            $obj | Add-Member -MemberType NoteProperty -Name "canonicalUrl" -Value  $Fields['Canonical Url'].Value
            $obj | Add-Member -MemberType NoteProperty -Name "Services" -Value  $ServicesSelected
            $obj | Add-Member -MemberType NoteProperty -Name "OpenGraphImage" -Value  $OpenGraphImage.Name
            $obj | Add-Member -MemberType NoteProperty -Name "placeId" -Value  $Fields['placeId'].Value
            $obj | Add-Member -MemberType NoteProperty -Name "placeAlias" -Value  $Fields['placeAlias'].Value
            $obj | Add-Member -MemberType NoteProperty -Name "ShowOnMobile" -Value  $Fields['Show on Mobile'].Value
            $obj | Add-Member -MemberType NoteProperty -Name "FacebookUrl" -Value  $FacebookUrl
            $obj | Add-Member -MemberType NoteProperty -Name "TwitterUrl" -Value  $TwitterUrl
            $obj | Add-Member -MemberType NoteProperty -Name "InstagramUrl" -Value  $InstagramUrl
            $obj | Add-Member -MemberType NoteProperty -Name "StoreWebsiteUrl" -Value  $StoreWebsiteUrl
            $obj | Add-Member -MemberType NoteProperty -Name "MondayOpening" -Value  $MondayOpening
            $obj | Add-Member -MemberType NoteProperty -Name "MondayClosing" -Value  $MondayClosing
            $obj | Add-Member -MemberType NoteProperty -Name "isClosedMonday" -Value  $isClosedMonday
            $obj | Add-Member -MemberType NoteProperty -Name "TuesdayOpening" -Value  $TuesdayOpening
            $obj | Add-Member -MemberType NoteProperty -Name "TuesdayClosing" -Value  $TuesdayClosing
            $obj | Add-Member -MemberType NoteProperty -Name "isClosedTuesday" -Value  $isClosedTuesday
            $obj | Add-Member -MemberType NoteProperty -Name "WednesdayOpening" -Value  $WednesdayOpening
            $obj | Add-Member -MemberType NoteProperty -Name "WednesdayClosing" -Value  $WednesdayClosing
            $obj | Add-Member -MemberType NoteProperty -Name "isClosedWednesday" -Value  $isClosedWednesday
            $obj | Add-Member -MemberType NoteProperty -Name "ThursdayOpening" -Value  $ThursdayOpening
            $obj | Add-Member -MemberType NoteProperty -Name "ThursdayClosing" -Value  $ThursdayClosing
            $obj | Add-Member -MemberType NoteProperty -Name "isClosedThursday" -Value  $isClosedThursday
            $obj | Add-Member -MemberType NoteProperty -Name "FridayOpening" -Value  $FridayOpening
            $obj | Add-Member -MemberType NoteProperty -Name "FridayClosing" -Value  $FridayClosing
            $obj | Add-Member -MemberType NoteProperty -Name "isClosedFriday" -Value  $isClosedFriday
            $obj | Add-Member -MemberType NoteProperty -Name "SaturdayOpening" -Value  $SaturdayOpening
            $obj | Add-Member -MemberType NoteProperty -Name "SaturdayClosing" -Value  $SaturdayClosing
            $obj | Add-Member -MemberType NoteProperty -Name "isClosedSaturday" -Value  $isClosedSaturday
            $obj | Add-Member -MemberType NoteProperty -Name "SundayOpening" -Value  $SundayOpening
            $obj | Add-Member -MemberType NoteProperty -Name "SundayClosing" -Value  $SundayClosing
            $obj | Add-Member -MemberType NoteProperty -Name "isClosedSunday" -Value  $isClosedSunday

            $array.Add($obj) | Out-Null
            
            Write-Host "[$($cpt)/$($count)] $($Fields['Shop Title'].Value) ---- done" -ForegroundColor Green
            $cpt ++;
        }
        $array | Select-Object ItemType, Breadcrumbtitle, Showonbreadcrumb, PageDesign, BannerTitle, BackgroundImage, LargeImage , MobileImage, TabletImage, ShopOrRestaurantImage, ShopOrRestaurantTitle, Description, Contact, Playfull, Brand, OpeningDate, popUp, Parking, Gate, Category, SubCategory, Services, canonicalUrl, OpenGraphImage, placeId, placeAlias, ShowOnMobile, FacebookUrl, TwitterUrl, InstagramUrl, StoreWebsiteUrl, MondayOpening, MondayClosing, isClosedMonday, TuesdayOpening, TuesdayClosing, isClosedTuesday, WednesdayOpening, WednesdayClosing, isClosedWednesday, ThursdayOpening, ThursdayClosing, isClosedThursday, FridayOpening, FridayClosing, isClosedFriday, SaturdayOpening, SaturdayClosing, isClosedSaturday, SundayOpening, SundayClosing, isClosedSunday | Export-Csv -Encoding UTF8 -notypeinformation -Path $outputFilePath
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

$RegionName = "Denmark"
$MallName = "Fields"
$Language = "da"
Export-Stores $RegionName $MallName $Language


