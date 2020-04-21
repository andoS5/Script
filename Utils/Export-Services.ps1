
function Utils-Export-Service {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0 )]
        [string]$RegionName,
    
        [Parameter(Mandatory = $true, Position = 1 )]
        [string]$Language,
    
        [Parameter(Mandatory = $true, Position = 2 )]
        [string]$MallName
    )
    begin {
        Write-Host "Export-Content Begin"
    }

    process {
        $outputFilePath = "$($AppPath)/Services_$($MallName).csv"
        $array = New-Object System.Collections.ArrayList

        $ServicesItem = Get-Item -Path "master:/sitecore/content/Klepierre/$($RegionName)/$($MallName)/Home/Services" -Language $Language
        
        $ServiceChildItems = $ServicesItem.Children | Where-Object {$_.TemplateID -eq "{80090502-71A4-42A5-8031-26A219977FBC}"}
        $ServiceCount = $ServiceChildItems.Count

        $cpt = 1;

        foreach ($ServiceChildItem in $ServiceChildItems) {

            Write-Host -NoNewLine "[$cpt/$ServiceCount] Processing $($ServiceChildItem.Name) ... "

            $childItemPath = "master:/sitecore/content/Klepierre/$($RegionName)/$($MallName)/Home/Services/$($ServiceChildItem.Name)" 
            $Services = Get-Item -Path $childItemPath -Language  $Language
            $ServiceFields = $Services.Fields

            #images
            $bg = $ServiceFields["Background Image"].Value
            $BackgroundImage = if (![string]::IsNullOrEmpty($bg)) {Get-Item $bg} else {""}
            $mob = $ServiceFields["Mobile Image"].Value
            $MobileImage = if (![string]::IsNullOrEmpty($bg)) {Get-Item $mob} else {""}
            $tab = $ServiceFields["Tablet Image"].Value
            $TabletImage = if (![string]::IsNullOrEmpty($tab)) {Get-Item $tab} else {""}
            $large = $ServiceFields["Large Image"].Value
            $LargeImage = if (![string]::IsNullOrEmpty($large)) {Get-Item $large} else {""}
            $ogImage = $ServiceFields["Open Graph Image"].Value
            $OpenGraphImage = if (![string]::IsNullOrEmpty($ogImage)) {Get-Item $ogImage} else {""}
            $mobTile = $ServiceFields["Mobile Tile Image"].Value
            $MobileTileImage = if (![string]::IsNullOrEmpty($mobTile)) {Get-Item $mobTile} else {""}
            $tabTile = $ServiceFields["Tablet Tile Image"].Value
            $TabletTileImage = if (![string]::IsNullOrEmpty($tabTile)) {Get-Item $tabTile} else {""}
            $largeTile = $ServiceFields["Large Tile Image"].Value
            $LargeTileImage = if (![string]::IsNullOrEmpty($largeTile)) {Get-Item $largeTile} else {""}
            $descMobImage = $ServiceFields["Description Mobile Image"].Value
            $DescriptionMobileImage = if (![string]::IsNullOrEmpty($descMobImage)) {Get-Item $descMobImage} else {""}
            $descTabImage = $ServiceFields["Description Tablet Image"].Value
            $DescriptionTabletImage = if (![string]::IsNullOrEmpty($descTabImage)) {Get-Item $descTabImage} else {""}
            #end image
            #page Design
            $pageDes = $ServiceFields["Page Design"].value
            $pageDesign = if (![string]::IsNullOrEmpty($pageDes)) {Get-Item $pageDes} else {""}
            $categ = $ServiceFields["Category"].value
            $category = if (![string]::IsNullOrEmpty($categ)) {Get-Item $categ} else {""}
            #end page Design

            $obj = New-Object System.Object
            $obj | Add-Member -MemberType NoteProperty -Name "Breadcrumbtitle" -Value  $ServiceFields["Breadcrumb title"].value
            $obj | Add-Member -MemberType NoteProperty -Name "PageDesign" -Value  $pageDesign.Name
            $obj | Add-Member -MemberType NoteProperty -Name "Name" -Value  $ServiceFields["Name"].value
            $obj | Add-Member -MemberType NoteProperty -Name "Title" -Value  $ServiceFields["Title"].value
            $obj | Add-Member -MemberType NoteProperty -Name "Category" -Value  $category.Name
            $obj | Add-Member -MemberType NoteProperty -Name "ShortPresentation" -Value  $ServiceFields["Short Presentation"].value
            $obj | Add-Member -MemberType NoteProperty -Name "LongPresentation" -Value  $ServiceFields["Long Presentation"].value
            $obj | Add-Member -MemberType NoteProperty -Name "BannerTitle" -Value  $ServiceFields["Banner Title"].value
            $obj | Add-Member -MemberType NoteProperty -Name "BackgroundImage" -Value  $BackgroundImage.Name
            $obj | Add-Member -MemberType NoteProperty -Name "MobileImage"     -Value  $MobileImage.Name
            $obj | Add-Member -MemberType NoteProperty -Name "TabletImage"     -Value  $TabletImage.Name
            $obj | Add-Member -MemberType NoteProperty -Name "LargeImage"      -Value  $LargeImage.Name
            $obj | Add-Member -MemberType NoteProperty -Name "OpenGraphImage"  -Value  $OpenGraphImage.Name
            $obj | Add-Member -MemberType NoteProperty -Name "MobileTileImage" -Value  $MobileTileImage.Name
            $obj | Add-Member -MemberType NoteProperty -Name "TabletTileImage" -Value  $TabletTileImage.Name
            $obj | Add-Member -MemberType NoteProperty -Name "LargeTileImage" -Value  $LargeTileImage.Name
            $obj | Add-Member -MemberType NoteProperty -Name "DescriptionMobileImage" -Value  $DescriptionMobileImage.Name
            $obj | Add-Member -MemberType NoteProperty -Name "DescriptionTabletImage" -Value  $DescriptionTabletImage.Name
            $obj | Add-Member -MemberType NoteProperty -Name "placeId" -Value  $ServiceFields["place Id"].value
            $obj | Add-Member -MemberType NoteProperty -Name "placeAlias" -Value  $ServiceFields["place Alias"].value
            $obj | Add-Member -MemberType NoteProperty -Name "MapId" -Value  $ServiceFields["Map Id"].value
            $obj | Add-Member -MemberType NoteProperty -Name "Stores" -Value  $ServiceFields["Stores"].value
            $obj | Add-Member -MemberType NoteProperty -Name "DisplayOrder" -Value  $ServiceFields["Display Order"].value
            $obj | Add-Member -MemberType NoteProperty -Name "PageTitle" -Value  $ServiceFields["Page Title"].value
            $obj | Add-Member -MemberType NoteProperty -Name "MetaDescription" -Value  $ServiceFields["Meta Description"].value
            $obj | Add-Member -MemberType NoteProperty -Name "MetaKeywords" -Value  $ServiceFields["Meta Keywords"].value
            $obj | Add-Member -MemberType NoteProperty -Name "OpenGraphTitle" -Value  $ServiceFields["Open Graph Title"].value
            $obj | Add-Member -MemberType NoteProperty -Name "OpenGraphDescription" -Value  $ServiceFields["Open Graph Description"].value

            $array.Add($obj) | Out-Null
            $cpt ++;
            
            Write-Host "done" -ForegroundColor Green
        }

        $array | Select-Object Breadcrumbtitle, PageDesign, Name, Title, Category, ShortPresentation, LongPresentation, BannerTitle, BackgroundImage, MobileImage, TabletImage, LargeImage, OpenGraphImage, MobileTileImage, TabletTileImage, LargeTileImage, DescriptionMobileImage, DescriptionTabletImage, placeId,  MapId, Stores, DisplayOrder, PageTitle, MetaDescription, MetaKeywords, OpenGraphTitle, OpenGraphDescription| Export-Csv -Encoding UTF8 -notypeinformation -Path $outputFilePath
        Try {
            Send-File -Path $outputFilePath
        }
        Finally {
            Remove-Item -Path $outputFilePath
        }
    }
    end {
        Write-Host "Export-Content End"
    }
}
Utils-Export-Service "Portugal" "pt-PT" "ParqueNascente" #test on sit 2