function Import-Content-Services {
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
      Write-Host "Import Services - Begin"
      Import-Function Utils-Remove-Diacritics
      Import-Function Utils-Upload-CSV-File
      Import-Function Utils-GetImageFromMediaLibrary
      Import-Function Content-Update-Meta-Data
  }

  process {


      $services = Utils-Upload-CSV-File -Title "Import Services"
      $total = $services.Count
      $count = 1
      $desktopImage = ""
      $mobileImage = ""
      $tabletImage = ""
      $largeImage = ""
      $tileImage =""
      #for Services Repository
      $topServices = @()
      $ServicesPath = "/sitecore/content/Klepierre/$($RegionName)/$($MallName)/Home/Services"
      $ServicesItem = Get-Item -Path $ServicesPath -Language  $Language

      $defaultImage = "default"

      foreach ($service in $services) {
          $itemName = if($service["Friendly URL"].Trim() -ne ""){Utils-Remove-Diacritics $service["Friendly URL"]} else{""}
          if ($itemName -eq "") {
              $itemName = Utils-Remove-Diacritics $service["Service Title"]
          }

          $siteName = $MallName -replace '[\W]', '-'
          $itemPath = "master:/content/Klepierre/$($RegionName)/$($siteName)/Home/Services/$($itemName)"

          if (!(Test-Path -Path $itemPath -ErrorAction SilentlyContinue)) {
              New-Item -Path $itemPath -ItemType "{80090502-71A4-42A5-8031-26A219977FBC}" -Language $Language | Out-Null
          }

          Write-Host "[$($count)/$($total)] - Processing $($itemPath)"

          $item = Get-Item -Path $itemPath -Language $Language

          if ($service["Featured Service"].Trim() -ne "") {
              $topServices += $Item.ID
          }

          $pageDesignPath = "master:/content/Klepierre/Master Region/Alpha/Presentation/Page Designs/Service Details"

          $breadCrumbTitle = $service["Friendly URL"]
          if ($breadCrumbTitle -ne "") {
              $breadCrumbTitle = $breadCrumbTitle -Replace "-", " "
          }

          $breadCrumbTitle = $service["Service Title"]
          $title = $service["Service Title"]
          $categoryID = ""
          if ($service["Service Category"] -ne "") {
              $serviceCategoryItem = Add-Service-Category $RegionName $Language $service["Service Category"]
              $categoryID = $serviceCategoryItem.ID
          }
          $shortDescription = $service["Short Description"]
          $longDescription = $service["Long Description"]
          $bannerTitle = $service["Service Title"]
          $mapId = $service["Service Position"]

          if ($service["Banner Image"].Trim() -ne "") {
              $serviceBannerImage = $service["Banner image"] -replace "\..+"
              $storesLibraryPath = "master:/sitecore/media library/Project/Klepierre/$RegionName/$MallName/Services"
              $desktopImage = if ((Test-Path -Path "$storesLibraryPath/desktop/$serviceBannerImage" -ErrorAction SilentlyContinue)) { Get-Item -Path "$storesLibraryPath/desktop/$serviceBannerImage" }
              $mobileImage = if ((Test-Path -Path "$storesLibraryPath/mobile/$serviceBannerImage" -ErrorAction SilentlyContinue)) { Get-Item -Path "$storesLibraryPath/mobile/$serviceBannerImage" }
              $tabletImage = if ((Test-Path -Path "$storesLibraryPath/tablet/$serviceBannerImage" -ErrorAction SilentlyContinue)) { Get-Item -Path "$storesLibraryPath/tablet/$serviceBannerImage" }
              $largeImage = if ((Test-Path -Path "$storesLibraryPath/large/$serviceBannerImage" -ErrorAction SilentlyContinue)) { Get-Item -Path "$storesLibraryPath/large/$serviceBannerImage" }
              $tileImage = if ((Test-Path -Path "$storesLibraryPath/Tile/$serviceBannerImage" -ErrorAction SilentlyContinue)) { Get-Item -Path "$storesLibraryPath/Tile/$serviceBannerImage" }
              
          }
          else {
              $storesLibraryPath = "master:/sitecore/media library/Project/Klepierre/$RegionName/$MallName/Services"
              $desktopImage = if ((Test-Path -Path "$storesLibraryPath/desktop/$defaultImage" -ErrorAction SilentlyContinue)) { Get-Item -Path "$storesLibraryPath/desktop/$defaultImage" }
              $mobileImage = if ((Test-Path -Path "$storesLibraryPath/mobile/$defaultImage" -ErrorAction SilentlyContinue)) { Get-Item -Path "$storesLibraryPath/mobile/$defaultImage" }
              $tabletImage = if ((Test-Path -Path "$storesLibraryPath/tablet/$defaultImage" -ErrorAction SilentlyContinue)) { Get-Item -Path "$storesLibraryPath/tablet/$defaultImage" }
              $largeImage = if ((Test-Path -Path "$storesLibraryPath/large/$defaultImage" -ErrorAction SilentlyContinue)) { Get-Item -Path "$storesLibraryPath/large/$defaultImage" } 
              $tileImage = if ((Test-Path -Path "$storesLibraryPath/Tile/$defaultImage" -ErrorAction SilentlyContinue)) { Get-Item -Path "$storesLibraryPath/Tile/$defaultImage" }
          }

          Update-Service $item $breadCrumbTitle $title $categoryID $shortDescription $longDescription $bannerTitle $mapId $desktopImage $mobileImage $tabletImage $largeImage $tileImage $pageDesignPath 
          Content-Update-Meta-Data $item $service $RegionName $MallName "Services" $title
          $item.Editing.EndEdit() | Out-Null
          $count++
      }
      $topServices = [System.String]::Join("|", $topServices)

      $categoryOrder = (Get-ChildItem -Path "master:/sitecore/content/Klepierre/France/Service Category Repository" | Select-Object -ExpandProperty Id) -join "|"

      $ServicesItem.Editing.BeginEdit() | Out-Null
      $ServicesItem["Show on breadcrumb"] = 1
      $ServicesItem["Categories Order"] = $categoryOrder
      $ServicesItem["Top Services"] = $topServices
      $ServicesItem["Background Image"] = '<image mediaid="{200EAF5E-49E1-4E9D-901A-0D5D02621130}" alt="Background Image"  />'
      $ServicesItem["Mobile Image"] = '<image mediaid="{B0A0A417-41FA-4CEC-ABD9-C05495281364}" alt="Mobile Image"  />'
      $ServicesItem["Tablet Image"] = '<image mediaid="{A8D4A475-1880-40C7-B827-07FAD42EDA8C}" alt="Tablet Image"  />'
      $ServicesItem["Large Image"] = '<image mediaid="{18026B69-2071-4304-AAAC-BF6EF8E74FDB}" alt="Large Image"  />'
      $ServicesItem.Editing.EndEdit() | Out-Null
  }

  end {
      Write-Host "Import Services - End"
  }
}

function Add-Service-Category {
  [CmdletBinding()]
  param (
      [Parameter(Mandatory = $true, Position = 0 )]
      [string]$RegionName,

      [Parameter(Mandatory = $true, Position = 1 )]
      [string]$Language,

      [Parameter(Mandatory = $true, Position = 2 )]
      [string]$ServiceLabel

  )

  begin {
      Import-Function Utils-Remove-Diacritics
  }

  process {
      $normalizedServiceLabel = Utils-Remove-Diacritics $ServiceLabel
      $servicePath = "master:/content/Klepierre/$($RegionName)/Service Category Repository/$($normalizedServiceLabel)"

      if (!(Test-Path -Path $servicePath -ErrorAction SilentlyContinue)) {
          New-Item -Path $servicePath -ItemType "{C96D2C04-2557-45BC-9B39-000596DA0C1E}" -Language $Language | Out-Null
      }
  
      $serviceCategory = Get-Item -Path $servicePath -Language $Language

      $serviceCategory.Editing.BeginEdit()
      $serviceCategory["Service Label"] = $ServiceLabel
      $serviceCategory.Editing.EndEdit()

      $serviceCategory
  }
}

function Update-Service {
  [CmdletBinding()]
  param (
      [Parameter(Mandatory = $true, Position = 0 )]
      [Item]$Service,

      [Parameter(Mandatory = $false, Position = 1 )]
      [string]$BreadCrumbTitle = "",
  
      [Parameter(Mandatory = $false, Position = 2 )]
      [string]$Title = "",
  
      [Parameter(Mandatory = $false, Position = 3 )]
      [string]$CategoryID = "",
  
      [Parameter(Mandatory = $false, Position = 4 )]
      [string]$ShortDescription = "",

      [Parameter(Mandatory = $false, Position = 5 )]
      [string]$LongDescription = "",

      [Parameter(Mandatory = $false, Position = 6 )]
      [string]$BannerTitle = "",

      [Parameter(Mandatory = $false, Position = 7 )]
      [string]$MapId = "",

      [Parameter(Mandatory = $false, Position = 8 )]
      $desktopImage,

      [Parameter(Mandatory = $false, Position = 9 )]
      $mobileImage,

      [Parameter(Mandatory = $false, Position = 10 )]
      $tabletImage,

      [Parameter(Mandatory = $false, Position = 11 )]
      $largeImage,

      [Parameter(Mandatory = $false, Position = 12 )]
      $tileImage,

      [Parameter(Mandatory = $false, Position = 13)]
      [string]$PageDesignPath = ""
  )

  process {
      $Service.Editing.BeginEdit() | Out-Null

      if (Test-Path -Path $PageDesignPath -ErrorAction SilentlyContinue) {
          $pageDesign = Get-Item -Path $pageDesignPath
          $Service["Page Design"] = $pageDesign.ID
      }
  
      $Service["Breadcrumb title"] = $BreadCrumbTitle
      $Service["Title"] = $Title
      $Service["Category"] = $CategoryID
      $Service["Short Presentation"] = $ShortDescription
      $Service["Long Presentation"] = $LongDescription
      $Service["Map Id"] = $MapId
      
      # if ($LongDescription -ne "") {
          $Service["Show on breadcrumb"] = 1
      # }

      if ($Service["Name"] -eq "") {
          $Service["Name"] = $Service.Name
      }

      if ($desktopImage -ne $null) {
          $Service["Background Image"] = '<image mediaid="' + $desktopImage.ID + '" alt="' + $desktopImage.Name + '"  />'
      }
      if ($mobileImage -ne $null) {
          $Service["Mobile Image"] = '<image mediaid="' + $mobileImage.ID + '" alt="' + $mobileImage.Name + '"  />'
          $Service["Open Graph Image"] = '<image mediaid="' + $mobileImage.ID + '" alt="' + $mobileImage.Name + '"  />'
      }
      if ($tabletImage -ne $null) {
          $Service["Tablet Image"] = '<image mediaid="' + $tabletImage.ID + '" alt="' + $tabletImage.Name + '"  />'
      }
      if ($largeImage -ne $null) {
          $Service["Large Image"] = '<image mediaid="' + $largeImage.ID + '" alt="' + $largeImage.Name + '"  />'
      }
      if ($tileImage -ne $null) {
          $Service["Mobile Tile Image"] = '<image mediaid="' + $tileImage.ID + '" alt="' + $tileImage.Name + '"  />'
          $Service["Tablet Tile Image"] = '<image mediaid="' + $tileImage.ID + '" alt="' + $tileImage.Name + '"  />'
          $Service["Large Tile Image"] = '<image mediaid="' + $tileImage.ID + '" alt="' + $tileImage.Name + '"  />'
      }
      
  }
}