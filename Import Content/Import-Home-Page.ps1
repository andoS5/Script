function Import-Content-Home-Page {
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
      Write-Host "Import Home Page - Begin"
      Import-Function Utils-Remove-Diacritics
      Import-Function Utils-Upload-CSV-File
    }

    process{
    
        $Datas = Utils-Upload-CSV-File -Title "Import Home Page"

        $HomePath = "/sitecore/content/Klepierre/$($RegionName)/$($MallName)/Home"
        $HomeItem = Get-Item -Path $HomePath -Language  $Language

        $HomeItem.Editing.BeginEdit() | Out-Null

        $HomeItem["Page Title"] = $Datas[0]."Meta Title"
        $HomeItem["SEO Paragraph"] = $Datas[0]."seo paragraphe"
        $HomeItem["Meta Keywords"] = $Datas[0]."Meta Keywords"
        $HomeItem["Meta Description"] = $Datas[0]."Meta Description"

        $HomeItem.Editing.EndEdit() | Out-Null

        #SiteLogo
        $SiteLogoItemPath = "/sitecore/content/Klepierre/$($RegionName)/$($MallName)/Home/Media Repository/SiteLogo"
        $SiteLogoItem = Get-Item -Path $SiteLogoItemPath -Language  $Language
        $SiteLogoImage = "master:/sitecore/media library/Project/Klepierre/$($RegionName)/$($MallName)/Home-Page/Logo"
        $SiteLogoImageItem = Get-ChildItem -Path $SiteLogoImage
        $logoID = $SiteLogoImageItem.ID   
        $logoName = $SiteLogoImageItem.Name
        $SiteLogoItem.Editing.BeginEdit() | Out-Null
        $SiteLogoItem["image"] = "<image mediaid=`"$logoID`" alt=`"$logoName`" height=`"`" width=`"`" hspace=`"`" vspace=`"`" />"
        $SiteLogoItem.Editing.EndEdit() | Out-Null

        $AllShopsItemPAth =  "/sitecore/content/Klepierre/$($RegionName)/$($MallName)/Home/Media Repository/All Shops"
        $AllShopsItem = Get-Item -Path $AllShopsItemPAth -Language  $Language
        $AllShopsLogo = "master:/sitecore/media library/Project/Klepierre/$($RegionName)/$($MallName)/Home-Page/Shop-Logo"
        $AllShopsLogoItem = Get-ChildItem -Path $AllShopsLogo
        $AllShopslogoID = $AllShopsLogoItem.ID   
        $AllShopslogoName = $AllShopsLogoItem.Name

        $AllShopsItem.Editing.BeginEdit() | Out-Null
        $AllShopsItem["image"] = "<image mediaid=`"$AllShopslogoID`" alt=`"$AllShopslogoName`" height=`"`" width=`"`" hspace=`"`" vspace=`"`" />"
        $AllShopsItem["text"] = $Datas[0]."ALL SHOPS"
        $AllShopsItem.Editing.EndEdit() | Out-Null

        #Slider
        $pathSliderBannerRepo = $HomePath + "/Banner Repository/Homepage Banner/"
        $i = 0
        foreach($d in $Datas){
          $i++
          $pathSlider = $pathSliderBannerRepo + "Slide " + $i
          if (!(Test-Path -Path $pathSlider -ErrorAction SilentlyContinue)) {
            Write-Host "Create $($pathSlider)"
            New-Item -Path $pathSlider -ItemType "{CCAB194E-53F8-47FB-9119-15C923A0B865}" -Language $Language | Out-Null
          }
          
          $imageValue = ""
          Write-Host "Image : $($d."Image Slide")"
          if($d."Image Slide" -ne $null){
            $nameImageSplited = $d."Image Slide".Split(".")
            $imageName = $nameImageSplited[0]
            $pathImage = "master:/sitecore/media library/Project/Klepierre/$($RegionName)/$($MallName)/Home-Page/Slides/$($imageName)"  
            $image = Get-Item -Path "$pathImage" -Language "en"
            $imageID = $image.ID
            $imageItemName = $image.Name
            $imageValue = "<image mediaid=`"$imageID`" alt=`"$imageItemName`" height=`"`" width=`"`" hspace=`"`" vspace=`"`" />"
          }
            $slider = Get-Item -Path $pathSlider -Language $Language
            $slider.Editing.BeginEdit() | Out-Null
            $slider["Title"] = $d."Title Slide"
            $slider["Short Description"] = $d."Description Slide"
            $slider["Large Desktop Image"] = $imageValue
            $slider["Background Image"] = $imageValue
            $slider["Is Active"] = "1"
            $slider.Editing.EndEdit() | Out-Null
        }

        #AllServices
        $AllServicesItemPAth =  "/sitecore/content/Klepierre/$($RegionName)/$($MallName)/Home/Media Repository/All Services"
        $AllServicesItem = Get-Item -Path $AllServicesItemPAth -Language  $Language
        $AllServicesLogo = "master:/sitecore/media library/Project/Klepierre/$($RegionName)/$($MallName)/Home-Page/Service-Logo"
        $AllServicesLogoItem = Get-ChildItem -Path $AllServicesLogo
        $AllServiceslogoID = $AllServicesLogoItem.ID   
        $AllServiceslogoName = $AllServicesLogoItem.Name

        $AllServicesItem.Editing.BeginEdit() | Out-Null
          $AllServicesItem["image"] = "<image mediaid=`"$AllServiceslogoID`" alt=`"$AllServiceslogoName`" height=`"`" width=`"`" hspace=`"`" vspace=`"`" />"
          $AllServicesItem["text"] = $Datas[0]."SERVICES"
        $AllServicesItem.Editing.EndEdit() | Out-Null

        #AllRestaurants
        $AllServicesItemPAth =  "/sitecore/content/Klepierre/$($RegionName)/$($MallName)/Home/Media Repository/All Restaurants"
        $AllRestaurantsItem = Get-Item -Path $AllServicesItemPAth -Language  $Language
        $AllRestaurantsLogo = "master:/sitecore/media library/Project/Klepierre/$($RegionName)/$($MallName)/Home-Page/Restaurants-Logo"
        $AllRestaurantsLogoItem = Get-ChildItem -Path $AllRestaurantsLogo
        $AllRestaurantslogoID = $AllRestaurantsLogoItem.ID   
        $AllRestaurantslogoName = $AllRestaurantsLogoItem.Name

        $AllRestaurantsItem.Editing.BeginEdit() | Out-Null
          $AllRestaurantsItem["image"] = "<image mediaid=`"$AllRestaurantslogoID`" alt=`"$AllRestaurantslogoName`" height=`"`" width=`"`" hspace=`"`" vspace=`"`" />"
          $AllRestaurantsItem["text"] = $Datas[0]."ALL FOOD"
        $AllRestaurantsItem.Editing.EndEdit() | Out-Null

    }
    end {
        Write-Host "Import Home Page - End"
      }

}