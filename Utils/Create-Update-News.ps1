function Create-Update-News {
    [CmdletBinding()]
    param (

        [Parameter(Mandatory = $true, Position = 0 )]
        [string]$RegionName,

        [Parameter(Mandatory = $true, Position = 1 )]
        [string]$MallName,

        [Parameter(Mandatory = $true, Position = 2 )]
        [string]$Language
      
    )

    begin {
        Write-Host "Creation or update News - Begin"
    }

    process {
        
        $Data = Utils-Upload-CSV-File -title "CREATE OR UPDATE NEWS"
        $EventsAndNewsRepo = "master:/sitecore/content/Klepierre/$RegionName/$MallName/Home/Events and News"


        if ((Test-Path -Path $EventsAndNewsRepo -ErrorAction SilentlyContinue)) {

            Create-Upadte-First-News-Tile-Type1 $RegionName $MallName $Language $Data  #PASS
            Create-Update-Page-Components $RegionName $MallName $Language $Data #PASS
            Create-Update-Slider-Event-Container $RegionName $MallName $Language $Data #PASS
            # Create-Update-Video-Event $RegionName $MallName $Language $itemName $VideoUrl
        }
        else {
            New-Item -Path $EventsAndNewsRepo -ItemType "{64476A1D-56A9-4525-95FB-569A19A69295}" | Out-Null
            Create-Upadte-First-News-Tile-Type1 $RegionName $MallName $Language $Data #PASS
            Create-Update-Page-Components $RegionName $MallName $Language $Data #PASS
            Create-Update-Slider-Event-Container $RegionName $MallName $Language $Data #PASS
            # Create-Update-Video-Event $RegionName $MallName $Language $itemName $VideoUrl
        }
        
    }

    end {
        Write-Host "Creation or update News - Done"
    }
}

function Create-Upadte-First-News-Tile-Type1 {
    param (
        [Parameter(Mandatory = $true, Position = 0 )]
        [string]$RegionName,

        [Parameter(Mandatory = $true, Position = 1 )]
        [string]$MallName,

        [Parameter(Mandatory = $true, Position = 2 )]
        [string]$Language,

        [Parameter(Mandatory = $true, Position = 3 )]
        $Data
      
    )

    begin {
        Write-Host "Create-Upadte-First-News-Tile"
    }

    process {

        foreach ($datas in $Data) {
            $itemName = Utils-Remove-Diacritics $datas."Friendly URL"
            $HaveShop = $datas."Shop"
            $itemTYpe = ""

            if (!([string]::IsNullOrEmpty($HaveShop))) {
                $itemTYpe = "{CD5164AE-FE0B-4A0B-BF3B-6DDEE8CFC3E9}"
            }
            else {
                $itemTYpe = "{64476A1D-56A9-4525-95FB-569A19A69295}"
            }
            $newsRepository = "master:/sitecore/content/Klepierre/$RegionName/$MallName/Home/Events and News/News"
            if(!(Test-Path -Path $newsRepository -ErrorAction SilentlyContinue)){
                New-Item -Path $newsRepository -ItemType "{088F3575-92E9-4A78-9844-8FD82D75F6FF}" -Language $Language | Out-Null
            }
            $NewsItemPath = "master:/sitecore/content/Klepierre/$RegionName/$MallName/Home/Events and News/News/$itemName"
            if (!(Test-Path -Path $NewsItemPath -ErrorAction SilentlyContinue)) {
                # New-Item -Path $NewsItemPath -ItemType $itemTYpe -Language $Language | Out-Null

                # #update
                # $NewsItem = Get-Item -Path $NewsItemPath -Language $Language

                # $MediaRepository = "master:/sitecore/media library/Project/Klepierre/$RegionName/$MallName/News-and-Events"
                # $imageName = $datas."Image name"
                # $ImageAltText = $datas."AltImageText"
                # $LargeImage = if ((Test-Path -Path "$MediaRepository/$($imageName)_large" -ErrorAction SilentlyContinue)) { Get-Item -Path  "$MediaRepository/$($imageName)_large" } else { }
                # $LargeImageID = if ($LargeImage) { $LargeImage.ID }else { }               
                # $DesktopImage = if ((Test-Path -Path "$MediaRepository/$($imageName)_desktop" -ErrorAction SilentlyContinue)) { Get-Item -Path  "$MediaRepository/$($imageName)_desktop" } else { }
                # $DesktopImageID = if ($DesktopImage) { $DesktopImage.ID }else { }   
                # $TabletImage = if ((Test-Path -Path "$MediaRepository/$($imageName)_tablet" -ErrorAction SilentlyContinue)) { Get-Item -Path  "$MediaRepository/$($imageName)_tablet" } else { }
                # $TabletImageID = if ($TabletImage) { $TabletImage.ID }else { }
                # $MobileImage = if ((Test-Path -Path "$MediaRepository/$($imageName)_mobile" -ErrorAction SilentlyContinue)) { Get-Item -Path  "$MediaRepository/$($imageName)_mobile" } else { } 
                # $MobileImageID = if ($MobileImage) { $MobileImage.ID }else { }

                # $NewsItem.Editing.BeginEdit() | Out-Null

                # if ($itemTYpe -eq "{CD5164AE-FE0B-4A0B-BF3B-6DDEE8CFC3E9}") {
                #     $BrandRepository = "master:/sitecore/content/Klepierre/$RegionName/Brand Repository"
                #     if ((Test-Path -Path $BrandRepository -ErrorAction SilentlyContinue)) {
                #         $ShopName = if (!([string]::IsNullOrEmpty($HaveShop))) { Utils-Remove-Diacritics $datas."Shop" }else { }
                #         $brandPath = "$BrandRepository/$ShopName"

                #         if ((Test-Path -Path $brandPath -ErrorAction SilentlyContinue)) {
                #             $BrandItem = Get-Item -Path $brandPath -Language $Language
                #             $NewsItem["Brand"] = $BrandItem.ID
                #             # Write-Host $brandPath
                #             # Write-Host $BrandItem.ID
                #         }

                #     }
                #     $NewsItem["News tile small image"] = "<image mediaid=`"$MobileImageID`" alt=`"$ImageAltText`" height=`"`" width=`"`" hspace=`"`" vspace=`"`" />"
                # }
                # $NewsItem["Breadcrumb Title"] = $datas."Title"
                # $NewsItem["Show on breadcrumb"] = 1
                # $NewsItem["Page Design"] = "{204245C9-C6FC-41A5-B76A-8B577C8A0795}"
                # $NewsItem["Banner Title"] = $datas."Title"
                # $NewsItem["Background Image"] = "<image mediaid=`"$LargeImageID`" alt=`"$ImageAltText`" height=`"`" width=`"`" hspace=`"`" vspace=`"`" />"
                # $NewsItem["Large Image"] = "<image mediaid=`"$DesktopImageID`" alt=`"$ImageAltText`" height=`"`" width=`"`" hspace=`"`" vspace=`"`" />"
                # $NewsItem["Tablet Image"] = "<image mediaid=`"$TabletImageID`" alt=`"$ImageAltText`" height=`"`" width=`"`" hspace=`"`" vspace=`"`" />"
                # $NewsItem["Mobile Image"] = "<image mediaid=`"$MobileImageID`" alt=`"$ImageAltText`" height=`"`" width=`"`" hspace=`"`" vspace=`"`" />"

                # $NewsItem["News tile large image"] = "<image mediaid=`"$LargeImageID`" alt=`"$ImageAltText`" height=`"`" width=`"`" hspace=`"`" vspace=`"`" />"
                # $NewsItem["Event title"] = $datas."Title"
                # $NewsItem["Abstract"] = $datas."Short description"
                # $NewsItem["ChangeFrequency"] = "{D23B4654-53A5-4589-8B1B-5665A763D144}"
                # $NewsItem["Priority"] = "{19F3E919-4991-495F-9207-E1DADFD06F54}"
                # $NewsItem["First Title Event"] = $datas."Title"
                # $NewsItem["First Description Event"] = $datas."Description"
                # #$NewsItem["First Image"] = "<image mediaid=`"$imageID`" alt=`"$ImageAltText`" height=`"`" width=`"`" hspace=`"`" vspace=`"`" />"
                # $NewsItem["Second Title Event"] = $datas."Title"
                # $NewsItem["Second Description Event"] = $datas."Full description text"
                # $NewsItem["See More CTA"] = "VIS FLERE!"
                # # $NewsItem["Second Image"] = "<image mediaid=`"$imageID`" alt=`"$ImageAltText`" height=`"`" width=`"`" hspace=`"`" vspace=`"`" />"
                # # $NewsItem["GPOC Reference"] = "{GPOC Reference}|{GPOC Reference}"
                # # $NewsItem["GPOC Historic"] = "{GPOC Historic}|{GPOC Historic}"
                # $NewsItem["Page Title"] = $datas."metaTitle"
                # $NewsItem["Meta Description"] = $datas."metaDescription"
                # # $NewsItem["Canonical URL"] = "Canonical URL"
                # $NewsItem["Open Graph Image"] = "<image mediaid=`"$MobileImageID`" alt=`"$ImageAltText`" height=`"`" width=`"`" hspace=`"`" vspace=`"`" />"
                # $NewsItem["Show on Mobile"] = 1
                # $NewsItem["__Workflow"] = "{ADFA8C60-8AF8-4B6F-8275-E28A105A6268}"
                # $NewsItem["__Workflow state"] = "{1E4BF529-524E-4A9C-89E2-01F0BFAB4C31}"
                # $NewsItem["__Default workflow"] = "{ADFA8C60-8AF8-4B6F-8275-E28A105A6268}"
                
                # $NewsItem.Editing.EndEdit() | Out-Null
            }
            else {
                #update
                $NewsItem = Get-Item -Path $NewsItemPath -Language $Language

                $MediaRepository = "master:/sitecore/media library/Project/Klepierre/$RegionName/$MallName/News-and-Events"
                $imageName = $datas."Image name"
                $ImageAltText = $datas."AltImageText"
                # $LargeImage = if ((Test-Path -Path "$MediaRepository/$($imageName)_large" -ErrorAction SilentlyContinue)) { Get-Item -Path  "$MediaRepository/$($imageName)_large" } else { }
                # $LargeImageID = if ($LargeImage) { $LargeImage.ID }else { }               
                # $DesktopImage = if ((Test-Path -Path "$MediaRepository/$($imageName)_desktop" -ErrorAction SilentlyContinue)) { Get-Item -Path  "$MediaRepository/$($imageName)_desktop" } else { }
                # $DesktopImageID = if ($DesktopImage) { $DesktopImage.ID }else { }   
                # $TabletImage = if ((Test-Path -Path "$MediaRepository/$($imageName)_tablet" -ErrorAction SilentlyContinue)) { Get-Item -Path  "$MediaRepository/$($imageName)_tablet" } else { }
                # $TabletImageID = if ($TabletImage) { $TabletImage.ID }else { }
                # $MobileImage = if ((Test-Path -Path "$MediaRepository/$($imageName)_mobile" -ErrorAction SilentlyContinue)) { Get-Item -Path  "$MediaRepository/$($imageName)_mobile" } else { } 
                # $MobileImageID = if ($MobileImage) { $MobileImage.ID }else { }

                
                $MobileImage = if ((Test-Path -Path "$MediaRepository/$($imageName)_tile" -ErrorAction SilentlyContinue)) { Get-Item -Path  "$MediaRepository/$($imageName)_tile" } else { } 
                $MobileImageID = if ($MobileImage) { $MobileImage.ID }else {}
                
              

                $NewsItem.Editing.BeginEdit() | Out-Null

                if ($itemTYpe -eq "{CD5164AE-FE0B-4A0B-BF3B-6DDEE8CFC3E9}") {
                    # $BrandRepository = "master:/sitecore/content/Klepierre/$RegionName/Brand Repository"
                    # if ((Test-Path -Path $BrandRepository -ErrorAction SilentlyContinue)) {
                    #     $ShopName = if (!([string]::IsNullOrEmpty($HaveShop))) { Utils-Remove-Diacritics $datas."Shop" }else { }
                    #     $brandPath = "$BrandRepository/$ShopName"

                    #     if ((Test-Path -Path $brandPath -ErrorAction SilentlyContinue)) {
                    #         $BrandItem = Get-Item -Path $brandPath -Language $Language
                    #         $NewsItem["Brand"] = $BrandItem.ID
                    #         # Write-Host $brandPath
                    #         # Write-Host $BrandItem.ID
                    #     }

                    # }
                    $NewsItem["News tile large image"] = "<image mediaid=`"$MobileImageID`" alt=`"$ImageAltText`" height=`"`" width=`"`" hspace=`"`" vspace=`"`" />"
                }
                # $NewsItem["Breadcrumb Title"] = $datas."Title"
                # $NewsItem["Show on breadcrumb"] = 1
                # $NewsItem["Page Design"] = "{204245C9-C6FC-41A5-B76A-8B577C8A0795}"
                # $NewsItem["Banner Title"] = $datas."Title"
                # $NewsItem["Banner Title"] = $datas."Title"

                # $NewsItem["Background Image"] = "<image mediaid=`"$LargeImageID`" alt=`"$ImageAltText`" height=`"`" width=`"`" hspace=`"`" vspace=`"`" />"
                # $NewsItem["Large Image"] = "<image mediaid=`"$DesktopImageID`" alt=`"$ImageAltText`" height=`"`" width=`"`" hspace=`"`" vspace=`"`" />"
                # $NewsItem["Tablet Image"] = "<image mediaid=`"$TabletImageID`" alt=`"$ImageAltText`" height=`"`" width=`"`" hspace=`"`" vspace=`"`" />"
                # $NewsItem["Mobile Image"] = "<image mediaid=`"$MobileImageID`" alt=`"$ImageAltText`" height=`"`" width=`"`" hspace=`"`" vspace=`"`" />"

                $NewsItem["News tile large image"] = "<image mediaid=`"$MobileImageID`" alt=`"$ImageAltText`" height=`"`" width=`"`" hspace=`"`" vspace=`"`" />"
                
                # $NewsItem["Event title"] = $datas."Title"
                # $NewsItem["Abstract"] = $datas."Short description"
                # $NewsItem["ChangeFrequency"] = "{D23B4654-53A5-4589-8B1B-5665A763D144}"
                # $NewsItem["Priority"] = "{19F3E919-4991-495F-9207-E1DADFD06F54}"
                # $NewsItem["First Title Event"] = $datas."Title"
                # $NewsItem["First Title Event"] = ""
                # $NewsItem["First Description Event"] = $datas."Description"
                # $NewsItem["First Description Event"] = $datas."Full description text"
                #$NewsItem["First Image"] = "<image mediaid=`"$imageID`" alt=`"$ImageAltText`" height=`"`" width=`"`" hspace=`"`" vspace=`"`" />"
                # $NewsItem["Second Title Event"] = $datas."Title"
                # $NewsItem["Second Title Event"] = ""
                # $NewsItem["Second Description Event"] = $datas."Full description text"
                # $NewsItem["Second Description Event"] = ""
                # $NewsItem["See More CTA"] = "VIS FLERE!"
                # $NewsItem["Second Image"] = "<image mediaid=`"$imageID`" alt=`"$ImageAltText`" height=`"`" width=`"`" hspace=`"`" vspace=`"`" />"
                # $NewsItem["GPOC Reference"] = "{GPOC Reference}|{GPOC Reference}"
                # $NewsItem["GPOC Historic"] = "{GPOC Historic}|{GPOC Historic}"
                # $NewsItem["Page Title"] = $datas."metaTitle"
                # $NewsItem["Meta Description"] = $datas."metaDescription"
                # $NewsItem["Canonical URL"] = "Canonical URL"
                # $NewsItem["Open Graph Image"] = "<image mediaid=`"$MobileImageID`" alt=`"$ImageAltText`" height=`"`" width=`"`" hspace=`"`" vspace=`"`" />"
                # $NewsItem["Show on Mobile"] = 1
                $NewsItem["__Workflow"] = "{ADFA8C60-8AF8-4B6F-8275-E28A105A6268}"
                $NewsItem["__Workflow state"] = "{1E4BF529-524E-4A9C-89E2-01F0BFAB4C31}"
                $NewsItem["__Default workflow"] = "{ADFA8C60-8AF8-4B6F-8275-E28A105A6268}"
                $NewsItem.Editing.EndEdit() | Out-Null
            }
        }
    }
    end {
        Write-Host "Create-Upadte-First-News-Tile - End"
    }
}

function Create-Update-Page-Components {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0 )]
        [string]$RegionName,

        [Parameter(Mandatory = $true, Position = 1 )]
        [string]$MallName,

        [Parameter(Mandatory = $true, Position = 2 )]
        [string]$Language,

        [Parameter(Mandatory = $true, Position = 3 )]
        $Data
      
    )

    begin {
        Write-Host "Create-Update-Page-Components - Begin"
    }


    process {
        foreach ($datas in $Data) {
            $itemName = Utils-Remove-Diacritics $datas."Friendly URL"
            $NewsPageContent = "master:/sitecore/content/Klepierre/$RegionName/$MallName/Home/Events and News/News/$itemName/Page Components"
            if (!(Test-Path -Path $NewsPageContent -ErrorAction SilentlyContinue)) {
                New-Item -Path $NewsPageContent -ItemType "{F3DA1DDD-4093-4DF1-AFF6-268E8E1CFE84}" -Language $Language | Out-Null
            }
            # else {
            #     #create image event item

            #     $ImageEventPath = "master:/sitecore/content/Klepierre/$RegionName/$MallName/Home/Events and News/News/$itemName/Page Components/Image Event"
            #     if (!(Test-Path -Path $ImageEventPath -ErrorAction SilentlyContiue)) {
            #         New-Item -Path $ImageEventPath -ItemType "{39D4EB6D-3558-447F-A317-1713C41E6B81}" -Language $Language | Out-Null
            #     }
            #     else {
            #         $ImageEventItem = Get-Item -Path  $ImageEventPath -Language $Language
            #         $imageID = ""
            #         $ImageAltText = ""

            #         $ImageEventItem.Editing.BeginEdit() | Out-Null
            #         $ImageEventItem["Image Desktop Event"] = "<image mediaid=`"$imageID`" alt=`"$ImageAltText`" height=`"`" width=`"`" hspace=`"`" vspace=`"`" />"
            #         $ImageEventItem["Image Mobile Event"] = "<image mediaid=`"$imageID`" alt=`"$ImageAltText`" height=`"`" width=`"`" hspace=`"`" vspace=`"`" />"
            #         $ImageEventItem["Image Large Event"] = "<image mediaid=`"$imageID`" alt=`"$ImageAltText`" height=`"`" width=`"`" hspace=`"`" vspace=`"`" />"
            #         $ImageEventItem["Image Tablet Event"] = "<image mediaid=`"$imageID`" alt=`"$ImageAltText`" height=`"`" width=`"`" hspace=`"`" vspace=`"`" />"
            #         $ImageEventItem.Editing.EndEdit() | Out-Null
            #     }
            # }
        }
        
    }

    end {
        Write-Host "Create-Update-Page-Components - End"
    }
}


function Create-Update-Slider-Event-Container {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0 )]
        [string]$RegionName,

        [Parameter(Mandatory = $true, Position = 1 )]
        [string]$MallName,

        [Parameter(Mandatory = $true, Position = 2 )]
        [string]$Language,

        [Parameter(Mandatory = $true, Position = 3 )]
        $Data
      
    )

    begin {
        Write-Host "Create-Update-Slider-Event-Container - Begin"
    }

    process {

        foreach ($datas in $Data) {

            $itemName = Utils-Remove-Diacritics $datas."Friendly URL"
            
            $SliderEventContainerPath = "master:/sitecore/content/Klepierre/$RegionName/$MallName/Home/Events and News/News/$itemName/Page Components/Slider Event Container"
            if (!(Test-Path -Path $SliderEventContainerPath -ErrorAction SilentlyContinue)) {
                New-Item -Path $SliderEventContainerPath -ItemType "{7DE607D6-9E1B-4FCC-A76E-4562C9ACE478}" -Language $Language | Out-Null
                $imageNames = $datas."Description image"
                if (!([string]::IsNullOrEmpty($imageNames))) {
                    if ($imageNames.Contains("|")) {
                        $images = $imageNames.Split("|")

                        foreach ($imgs in $images) {

                            $img = $imgs.Substring(0, $imgs.IndexOf(".")).Trim()
                            # $EventContainerItem = Get-Item -Path $SliderEventContainerPath -Language $Language
                            # $children = $EventContainerItem.Children | Where { $_.TemplateID -eq "{7CEAB744-19B2-4456-AEB6-831491B7BB82}" }
                            # $temp = 0
                            # if ($children) {
                            #     foreach ($child in $children) {
                            #         $childName = $child.Name
                            #         if ($img -eq $childName) {
                            #             $temp = 1;
                            #         }
                            #     }
                                
                            # }
                            # else {
                                # if ($temp -eq 0) {
                                    New-Item -Path "$SliderEventContainerPath/$img" -ItemType "{7CEAB744-19B2-4456-AEB6-831491B7BB82}" -Language $Language | Out-Null
                                    $MediaRepository = "master:/sitecore/media library/Project/Klepierre/$RegionName/$MallName/News-and-Events"
                                    if ((Test-Path -Path "$MediaRepository/$img" -ErrorAction SilentlyContinue)) {
                                        $imgItem = Get-Item -Path "$MediaRepository/$img"
                                        $imgID = $imgItem.ID
                                        $ImageAltText = $imgItem.Name
                                    
                                        $sliderItem = Get-Item -Path "$SliderEventContainerPath/$img" -Language $Language
                                        $sliderItem.Editing.BeginEdit() | Out-Null
                                        $sliderItem["Slider Image Desktop Event"] = "<image mediaid=`"$imgID`" alt=`"$ImageAltText`" height=`"`" width=`"`" hspace=`"`" vspace=`"`" />"
                                        $sliderItem["Slider Image Mobile Event"] = "<image mediaid=`"$imgID`" alt=`"$ImageAltText`" height=`"`" width=`"`" hspace=`"`" vspace=`"`" />"
                                        $sliderItem.Editing.EndEdit() | Out-Null
                                    }
                                # }
                            # }
                        }
                    }
                }
            }
            else {
                $imageNames = $datas."Description image"
                if (!([string]::IsNullOrEmpty($imageNames))) {
                    if ($imageNames.Contains("|")) {
                        $images = $imageNames.Split("|")

                        foreach ($imgs in $images) {

                            $img = $imgs.Substring(0, $imgs.IndexOf(".")).Trim()
                            # $EventContainerItem = Get-Item -Path $SliderEventContainerPath -Language $Language
                            # $children = $EventContainerItem.Children | Where { $_.TemplateID -eq "{7CEAB744-19B2-4456-AEB6-831491B7BB82}" }
                            # $temp = 0
                            # if ($children) {
                            #     foreach ($child in $children) {
                            #         $childName = $child.Name
                            #         if ($img -eq $childName) {
                            #             $temp = 1;
                            #         }
                            #     }
                                
                            # }
                            # else {
                                # if ($temp -eq 0) {
                                    New-Item -Path "$SliderEventContainerPath/$img" -ItemType "{7CEAB744-19B2-4456-AEB6-831491B7BB82}" -Language $Language | Out-Null
                                    $MediaRepository = "master:/sitecore/media library/Project/Klepierre/$RegionName/$MallName/News-and-Events"
                                    if ((Test-Path -Path "$MediaRepository/$img" -ErrorAction SilentlyContinue)) {
                                        $imgItem = Get-Item -Path "$MediaRepository/$img"
                                        $imgID = $imgItem.ID
                                        $ImageAltText = $imgItem.Name
                                    
                                        $sliderItem = Get-Item -Path "$SliderEventContainerPath/$img" -Language $Language
                                        $sliderItem.Editing.BeginEdit() | Out-Null
                                        $sliderItem["Slider Image Desktop Event"] = "<image mediaid=`"$imgID`" alt=`"$ImageAltText`" height=`"`" width=`"`" hspace=`"`" vspace=`"`" />"
                                        $sliderItem["Slider Image Mobile Event"] = "<image mediaid=`"$imgID`" alt=`"$ImageAltText`" height=`"`" width=`"`" hspace=`"`" vspace=`"`" />"
                                        $sliderItem.Editing.EndEdit() | Out-Null
                                    }
                                # }
                            # }
                        }
                    }
                }
            }
        }
    }
}

function Create-Update-Video-Event {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0 )]
        [string]$RegionName,

        [Parameter(Mandatory = $true, Position = 1 )]
        [string]$MallName,

        [Parameter(Mandatory = $true, Position = 2 )]
        [string]$Language,

        [Parameter(Mandatory = $true, Position = 3 )]
        [string]$itemName,

        [Parameter(Mandatory = $true, Position = 4 )]
        $Data
      
    )

    begin {
        Write-Host "Create-Update-Video-Event - Begin"
    }

    process {
        
        $VideoEventPath = "master:/sitecore/content/Klepierre/$RegionName/$MallName/Home/Events and News/News/$itemName/Page Components/Video Event"

        if (!(Test-Path -Path $ImagePath -ErrorAction SilentlyContiue)) {
            New-Item -Path $VideoEventPath -ItemType "{4B5BA986-C011-4E5A-B018-6FBED007CDD1}" -Language $Language | Out-Null
            $videoItem = Get-Item -Path $VideoEventPath -Language $Language

            $videoItem.Editing.BeginEdit() | Out-Null
            $videoItem["Video Url"] = $VideoUrl
            $videoItem.Editing.EndEdit() | Out-Null
        }
    }

    end {
        Write-Host "Create-Update-Video-Event - End"
    }
}

function Utils-Convert-PSObject-To-Hashtable {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline)]
        $InputObject
    )
      
    begin {
        #Write-Host "Cmdlet Utils-Convert-PSObject-To-Hashtable - Begin"
    }
  
    process {
        if ($null -eq $InputObject) { return $null }
  
        if ($InputObject -is [System.Collections.IEnumerable] -and $InputObject -isnot [string]) {
            $collection = @(
                foreach ($object in $InputObject) { Utils-Convert-PSObject-To-Hashtable $object }
            )
  
            #Write-Output -NoEnumerate $collection
            $collection
        }
        elseif ($InputObject -is [psobject]) {
            $hash = @{ }
  
            foreach ($property in $InputObject.PSObject.Properties) {
                $hash[$property.Name] = Utils-Convert-PSObject-To-Hashtable $property.Value
            }
  
            $hash
        }
        else {
            $InputObject
        }
    }
      
    end {
        #Write-Host "Cmdlet Utils-Convert-PSObject-To-Hashtable - End"
    }
}
  
function Utils-Upload-CSV-File {
    param(
        [Parameter(Mandatory = $false)]
        [string]$title,
        [Parameter(Mandatory = $false)]
        [string]$delimiter = ",",
        [Parameter(Mandatory = $false)]
        [string]$description
    )
    $dataFolder = [Sitecore.Configuration.Settings]::DataFolder
    $tempFolder = $dataFolder + "\temp\upload"
    $filePath1 = Receive-File -Path $tempFolder -overwrite -Title $title -Description $description
    if (!(Test-Path -Path $filePath1 -ErrorAction SilentlyContinue)) {
        Write-Host "Canceled"
        Exit
    }
    $fileCSV = Import-Csv -Delimiter $delimiter  $filePath1
    $CSVToHash = Utils-Convert-PSObject-To-Hashtable $fileCSV
      
    return $CSVToHash
}

function Utils-Remove-Diacritics {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0 )]
        [String]$text
    )
  
    process {
        $alphabet = @{
            #    " "="-";
            ";" = "";
            "а" = "a";
            "б" = "b";
            "в" = "v";
            "г" = "g";
            "д" = "d";
            "е" = "e";
            "ё" = "yo";
            "ж" = "zh";
            "з" = "z";
            "и" = "i";
            "й" = "y";
            "к" = "k";
            "л" = "l";
            "м" = "m";
            "н" = "n";
            "о" = "o";
            "п" = "p";
            "р" = "r";
            "с" = "s";
            "т" = "t";
            "у" = "u";
            "ф" = "f";
            "х" = "h";
            "ц" = "c";
            "ч" = "ch";
            "ш" = "sh";
            "щ" = "shch";
            "ъ" = "y";
            "ы" = "y";
            "ь" = "-";
            "э" = "e";
            "ю" = "ju";
            "я" = "ja";
            "." = "-";
            #","="-";
            "á" = "a"; 
            "à" = "a"; 
            "â" = "a"; 
            "ä" = "a"; 
            "å" = "a"; 
            "ã" = "a"; 
            "æ" = "ae"; 
            "ç" = "c"; 	
            "é" = "e"; 
            "è" = "e"; 
            "ê" = "e"; 
            "ë" = "e"; 	
            "í" = "i"; 
            "ì" = "i"; 
            "î" = "i"; 
            "ï" = "i"; 	
            "ñ" = "n"; 
            "ó" = "o"; 
            "ò" = "o"; 
            "ô" = "o"; 
            "ö" = "o"; 
            "õ" = "o"; 
            "ø" = "o"; 
            "œ" = "oe"; 	
            "š" = "s"; 	
            "ú" = "u"; 
            "ù" = "u"; 
            "û" = "u"; 
            "ü" = "u"; 	
            "ý" = "y"; 
            "ÿ" = "y"; 	
            "ž" = "z"; 
            "ð" = "e"; 
            "þ" = "t"; 
            "ß" = "s";
        }
      
        $akeys = $alphabet.Keys
        $splitKeys = $akeys.Split(" ")
        $avalues = $alphabet.Values
        $splitValues = $avalues.Split(" ")
        $rawText = $text.Replace(" ", "-")
        $res = $rawText.Split("-")
        $result = ""
      
        for ($j = 0; $j -lt $res.Length; $j++) {
            $item = ([string]$res[$j]).ToCharArray()
            for ($i = 0; $i -lt $item.Length; $i++) {
                $index = [string]$item[$i]
                if ($item[$i] -match '^\d+$' -or $alphabet[$index.ToLower()] -eq $null) {
                    $result += $index.ToLower();
                }
                else {
                    $result += $alphabet[$index.ToLower()]
                }
            }
            if ($j -lt $res.Length - 1) {
                $result += "-"
            }
        }
      
        $result = $result -replace '[^a-zA-Z0-9-]', ''
        $result = $result -Replace "-+", "-"
        $result
    }
}
Create-Update-News "Denmark" "Fields" "da" 