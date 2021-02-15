function Get-Image-Item-Id{
    param (
        [Parameter(Mandatory = $true, Position = 0 )]
        [string]$RawValue
    )
    process{
        $ResultRegex = "(?<={)(.*)(?=})"

        $Regex = [Regex]::new("$ResultRegex")       
        $Result = $Regex.Match($RawValue)   
        if ($Result.Success) {           
            return "{$($Result.Value)}"         
        }
    }
}
function Extract-Service-Datas {

    param (
        [Parameter(Mandatory = $true, Position = 0 )]
        [string]$RegionName,
        [Parameter(Mandatory = $true, Position = 1 )]
        [string]$MallName,
        [Parameter(Mandatory = $true, Position = 2 )]
        [string]$Language
    )

    process{
        $outputFilePath = "$($AppPath)/$RegionName $MallName Service Extract.csv"
        $array = New-Object System.Collections.ArrayList


        $serviceRepository = "master:/sitecore/content/Klepierre/$RegionName/$MallName/Home/Services"

        $services = Get-ChildItem -Path $serviceRepository -Language $Language | Where { $_.TemplateID -eq "{80090502-71A4-42A5-8031-26A219977FBC}"}

        $count = $services.Count
        $cpt = 1
        
        foreach($service in $services){
            $Fields = $service.Fields
            $name = $Fields["Name"]
            $ServiceName = $name -replace("^-","")
            $DesktopCarouselImage = $Fields["Desktop Carousel Image"]
            $dciID = if (![string]::IsNullOrEmpty($DesktopCarouselImage)) { Get-Image-Item-Id $DesktopCarouselImage} else { "" }
            $dcItem = if (![string]::IsNullOrEmpty($dciID)){Get-Item master: -ID $dciID}

            $TabletCarouselImage = $Fields["Tablet Carousel Image"]
            $tcID = if (![string]::IsNullOrEmpty($TabletCarouselImage)) { Get-Image-Item-Id $TabletCarouselImage} else { "" }
            $tcItem = if (![string]::IsNullOrEmpty($tcID)){Get-Item master: -ID $tcID}

            $MobileCarouselImage = $Fields["Mobile Carousel Image"]
            $micID = if (![string]::IsNullOrEmpty($MobileCarouselImage)) { Get-Image-Item-Id $MobileCarouselImage} else { "" }
            $micItem = if (![string]::IsNullOrEmpty($micID)){Get-Item master: -ID $micID}

            $LargeDesktopImage = $Fields["Background Image"]
            $ldID = if (![string]::IsNullOrEmpty($LargeDesktopImage)) { Get-Image-Item-Id $LargeDesktopImage} else { "" }
            $ldItem = if (![string]::IsNullOrEmpty($ldID)){Get-Item master: -ID $ldID}

            $DesktopImage = $Fields["Large Image"]
            $dID = if (![string]::IsNullOrEmpty($DesktopImage)) { Get-Image-Item-Id $DesktopImage} else { "" }
            $dItem = if (![string]::IsNullOrEmpty($dID)){Get-Item master: -ID $dID}
    
            $TabletImage = $Fields["Tablet Image"]
            $tID = if (![string]::IsNullOrEmpty($TabletImage)) { Get-Image-Item-Id $TabletImage} else { "" }
            $tItem = if (![string]::IsNullOrEmpty($tID)){Get-Item master: -ID $tID}

            $MobileImage = $Fields["Mobile Image"]
            $mID = if (![string]::IsNullOrEmpty($MobileImage)) { Get-Image-Item-Id $MobileImage} else { "" }
            $mItem = if (![string]::IsNullOrEmpty($mID)){Get-Item master: -ID $mID}

            $TileImage = $Fields["Tile Image"]
            $tiID = if (![string]::IsNullOrEmpty($TileImage)) { Get-Image-Item-Id $TileImage} else { "" }
            $tiItem = if (![string]::IsNullOrEmpty($tiID)){Get-Item master: -ID $tiID}

            $Category = $Fields["Category"]
            $categItem = Get-Item master: -ID $Category -Language $Language

            $AssociatedStores = $Fields["Stores"]
            $StoreName = ""
            if(![string]::IsNullOrEmpty($AssociatedStores)){
                $stores = if($AssociatedStores -Contains("|")){$AssociatedStores.split("|")}
                $storeCount = $stores.Count
                if($storeCount -gt 1){
                    foreach ($store in $stores) {
                        $item = Get-Item master: -ID $store -Language $Language
                        $names += "$($item.Name)|"
                    }
                    $StoreName = $names.Trim("|")
                }else{
                    $storeItem = Get-Item master: -ID $AssociatedStores -Language $Language
                    $StoreName = $storeItem.Name
                }
            }

            $OpenGraphImage = $Fields["Open Graph Image"]
            $ogID = if (![string]::IsNullOrEmpty($OpenGraphImage)) { Get-Image-Item-Id $OpenGraphImage} else { "" }
            $ogItem = if (![string]::IsNullOrEmpty($ogID)){Get-Item master: -ID $ogID}

            $obj = New-Object System.Object

            $obj | Add-Member -MemberType NoteProperty -Name "BreadcrumbTitle" -Value  $Fields["Breadcrumb title"].Value
            $obj | Add-Member -MemberType NoteProperty -Name "ShowOnBreadcrumb" -Value  $Fields["Show on breadcrumb"].Value
            $obj | Add-Member -MemberType NoteProperty -Name "DesktopCarouselImage" -Value  $dcItem.Name
            $obj | Add-Member -MemberType NoteProperty -Name "TabletCarouselImage" -Value  $tcItem.Name
            $obj | Add-Member -MemberType NoteProperty -Name "MobileCarouselImage" -Value  $micItem.Name
            $obj | Add-Member -MemberType NoteProperty -Name "EReservationId" -Value  $Fields["E-reservation Id"].Value
            $obj | Add-Member -MemberType NoteProperty -Name "BannerTitle" -Value  $Fields["Banner Title"].Value
            $obj | Add-Member -MemberType NoteProperty -Name "BackgroudImage" -Value  $ldItem.Name
            $obj | Add-Member -MemberType NoteProperty -Name "LargeImage" -Value  $dItem.Name
            $obj | Add-Member -MemberType NoteProperty -Name "TabletImage" -Value  $tItem.Name
            $obj | Add-Member -MemberType NoteProperty -Name "MobileImage" -Value  $mItem.Name
            $obj | Add-Member -MemberType NoteProperty -Name "TileImage" -Value  $tiItem.Name
            $obj | Add-Member -MemberType NoteProperty -Name "Name" -Value  $ServiceName
            $obj | Add-Member -MemberType NoteProperty -Name "Title" -Value  $Fields["Title"].Value
            $obj | Add-Member -MemberType NoteProperty -Name "Category" -Value  $categItem.Name
            $obj | Add-Member -MemberType NoteProperty -Name "ShortPresentation" -Value  $Fields["Short Presentation"].Value
            $obj | Add-Member -MemberType NoteProperty -Name "CTA" -Value  $Fields["CTA"].Value
            $obj | Add-Member -MemberType NoteProperty -Name "DisplayCTA" -Value  $Fields["Display CTA"].Value
            $obj | Add-Member -MemberType NoteProperty -Name "LongPresentation" -Value  $Fields["Long Presentation"].Value
            $obj | Add-Member -MemberType NoteProperty -Name "StoreName" -Value  $StoreName
            $obj | Add-Member -MemberType NoteProperty -Name "CanonicalURL" -Value  $Fields["Canonical URL"].Value
            $obj | Add-Member -MemberType NoteProperty -Name "OpenGraphImage" -Value  $ogItem.Name
            $obj | Add-Member -MemberType NoteProperty -Name "placeId" -Value  $Fields["placeId"].Value
            $obj | Add-Member -MemberType NoteProperty -Name "placeAlias" -Value  $Fields["placeAlias"].Value
            $obj | Add-Member -MemberType NoteProperty -Name "ShowOnMobile" -Value  $Fields["Show on Mobile"].Value

            $array.Add($obj) | Out-Null
            
            Write-Host "[$($cpt)/$($count)] $($service.Name) ---- done" -ForegroundColor Green
            $cpt ++;
        }
        $array | Select-Object Breadcrumbtitle, Showonbreadcrumb, DesktopCarouselImage, TabletCarouselImage, MobileCarouselImage, EReservationId, BannerTitle, BackgroudImage, LargeImage, TabletImage, MobileImage, TileImage, Name, Title, Category, ShortPresentation, CTA, DisplayCTA, LongPresentation,StoreName, CanonicalURL, OpenGraphImage, placeId, placeAlias, ShowOnMobile| Export-Csv -Encoding UTF8 -notypeinformation -Path $outputFilePath
        Try {
            Send-File -Path $outputFilePath
        }
        Finally {
            Remove-Item -Path $outputFilePath
        }

    }
}
$RegionName = "Denmark"
$MallName = "Fields"
$Language = "da"
Extract-Service-Datas $RegionName $MallName $Language