function Content-Update-Media-Repository {
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
      Write-Host "Update Media Repository - Begin"
      Import-Function Utils-Remove-Diacritics
      Import-Function Utils-Upload-CSV-File
      Import-Function Utils-GetImageFromMediaLibrary
    }

    process{
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

        #All Shops
        $Datas = Utils-Upload-CSV-File

        $AllShopsItemPAth =  "/sitecore/content/Klepierre/$($RegionName)/$($MallName)/Home/Media Repository/All Shops"
        $AllShopsItem = Get-Item -Path $AllShopsItemPAth -Language  $Language
        $AllShopsLogo = "master:/sitecore/media library/Project/Klepierre/$($RegionName)/$($MallName)/Home-Page/Shop-Logo"
        $AllShopsLogoItem = Get-ChildItem -Path $AllShopsLogo
        $AllShopslogoID = $AllShopsLogoItem.ID   
        $AllShopslogoName = $AllShopsLogoItem.Name

        $AllShopsItem.Editing.BeginEdit() | Out-Null
          $AllShopsItem["image"] = "<image mediaid=`"$AllShopslogoID`" alt=`"$AllShopslogoName`" height=`"`" width=`"`" hspace=`"`" vspace=`"`" />"
          $AllShopsItem["text"] = $Datas."ALL SHOPS"
        $AllShopsItem.Editing.EndEdit() | Out-Null

        #AllServices
        $AllServicesItemPAth =  "/sitecore/content/Klepierre/$($RegionName)/$($MallName)/Home/Media Repository/All Services"
        $AllServicesItem = Get-Item -Path $AllServicesItemPAth -Language  $Language
        $AllServicesLogo = "master:/sitecore/media library/Project/Klepierre/$($RegionName)/$($MallName)/Home-Page/Service-Logo"
        $AllServicesLogoItem = Get-ChildItem -Path $AllServicesLogo
        $AllServiceslogoID = $AllServicesLogoItem.ID   
        $AllServiceslogoName = $AllServicesLogoItem.Name

        $AllServicesItem.Editing.BeginEdit() | Out-Null
          $AllServicesItem["image"] = "<image mediaid=`"$AllServiceslogoID`" alt=`"$AllServiceslogoName`" height=`"`" width=`"`" hspace=`"`" vspace=`"`" />"
          $AllServicesItem["text"] = $Datas."SERVICES"
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
          $AllRestaurantsItem["text"] = $Datas."ALL FOOD"
        $AllRestaurantsItem.Editing.EndEdit() | Out-Null
    }
    end{
      Write-Host "Update Media Repository - End"
    }
}
Content-Update-Media-Repository "France" "fr-Fr" "odysseum"