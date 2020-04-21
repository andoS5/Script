function Import-Content-Stores {
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
    Write-Host "Import Stores - Begin"
    Import-Function Utils-Remove-Diacritics
    Import-Function Utils-Convert-PSObject-To-Hashtable
    Import-Function Utils-GetImageFromMediaLibrary
    Import-Function Content-Update-Meta-Data
    Import-Function Utils-Upload-CSV-File
  }

  process {
    $openingHourRepositoryPath = "/sitecore/content/Klepierre/$($RegionName)/$($MallName)/Home/Practical Information/Opening Hours Repository"
    $openingHourRepositoryChildren = Get-ChildItem -Path $openingHourRepositoryPath -Language  $Language

    #for Shop Repository
    $ShopRepositoryPath = "/sitecore/content/Klepierre/$($RegionName)/$($MallName)/Home/Shop Repository"
    $shopRepositoryItem = Get-Item -Path $ShopRepositoryPath -Language  $Language
    
    $shopRepositoryItem.Editing.BeginEdit() | Out-Null
    $shopRepositoryItem["Background Image"] = '<image mediaid="{200EAF5E-49E1-4E9D-901A-0D5D02621130}" alt="Background Image" height="" width="" hspace="" vspace="" />'
    $shopRepositoryItem["Mobile Image"] = '<image mediaid="{B0A0A417-41FA-4CEC-ABD9-C05495281364}" alt="Mobile Image" height="" width="" hspace="" vspace="" />'
    $shopRepositoryItem["Tablet Image"] = '<image mediaid="{A8D4A475-1880-40C7-B827-07FAD42EDA8C}" alt="Tablet Image" height="" width="" hspace="" vspace="" />'
    $shopRepositoryItem["Large Image"] = '<image mediaid="{18026B69-2071-4304-AAAC-BF6EF8E74FDB}" alt="Large Image" height="" width="" hspace="" vspace="" />'

    #Check all Filtering
    $filterings = (Get-ChildItem -Path "master:/sitecore/content/Klepierre/Filtering Options" | Select-Object -ExpandProperty Id)  -join "|"
    $shopRepositoryItem["Options"] = $filterings
    $shopRepositoryItem.Editing.EndEdit() | Out-Null
    #for Shop Repository

    $defaultImage = "default-shop.jpg"

    $map = @{}
    foreach($openingHourRepositoryChild in $openingHourRepositoryChildren){
      $map[$openingHourRepositoryChild.Name] = $openingHourRepositoryChild
    }

    $shops = Utils-Upload-CSV-File -Title "Import Shops & Restaurants"

    $total = $shops.Count
    $count = 1
    foreach ($shop in $shops) {
      $itemName = $shop["Friendly URL"]
      $StoreType = if($shop["Legacy URL"] -match "Restaurants"){"Restaurant"}else{"Shop"}
      $siteName = $MallName -Replace '[\W]', '-'
      $itemPath = "master:/content/Klepierre/$($RegionName)/$($siteName)/Home/Shop Repository/$($itemName)"

      if (!(Test-Path -Path $itemPath -ErrorAction SilentlyContinue)) {
        $siteBranch = "Branches/Feature/Kortex/Practical Info/$($StoreType)"
        New-Item -Path $itemPath -ItemType $siteBranch -Language $Language | Out-Null
      }

      Write-Host "[$($count)/$($total)] - Processing $($itemPath)"

      $item = Get-Item -Path $itemPath -Language $Language

      $item.Editing.BeginEdit() | Out-Null

      $pageDesignPath = "master:/content/Klepierre/Master Region/Alpha/Presentation/Page Designs/Shop Details"
      if (Test-Path -Path $pageDesignPath -ErrorAction SilentlyContinue) {
        $pageDesign = Get-Item -Path $pageDesignPath
        $item["Page Design"] = $pageDesign.ID
      }

      $item["Breadcrumb title"] = $shop["Shop Name"]
      #$item["Banner Title"] = $shop["Shop Name"]
      $item["Meta Keywords"] = $shop["Meta Keywords"]
      $item["$($StoreType) Title"] = $shop["Shop Name"]
      $item["Description"] = $shop["Description"]
      $item["Location"] = $shop["MapWize"]
      $item["Contact"] = $shop["Phone Number"]
      #$item["Playfull"] = $shop["Playfull Partner"]
      $item["Show on breadcrumb"] = 1

      if ($shop["Brand Title"] -ne "") {
        $brandItem = Add-Brand $RegionName $Language $shop["Brand Title"] $shop["Brand Logo"]
        $item["Brand"] = $brandItem.ID
      }

      #$item["Opening Date"] = $shop["Opening Date"]
      #$item["Pop-up"] = $shop["Pop-up Store"]

      if ($shop["Category 1"] -ne "") {
        $category1Hash = Add-Category $RegionName $Language $shop["Category 1"] $shop["Sub-Category 1"]
        $item["Category"] = $category1Hash["CategoryItem"].ID
        if ($shop["Sub-Category 1"] -ne "") {
          $item["Sub Category"] = $category1Hash["SubCategoryItem"].ID
        }
      }

      if ($shop["Category 2"] -ne "") {
        $category2Hash = Add-Category $RegionName $Language $shop["Category 2"] $shop["Sub-Category 2"]
        $currentCategory = $item["Category"]
        $newCategory = $category2Hash["CategoryItem"].ID
        $item["Category"] = "$($currentCategory)|$($newCategory)"
        if ($shop["Sub-Category 2"] -ne "") {
          $currentSubCategory = $item["Sub Category"]
          $newSubCategory = $category2Hash["SubCategoryItem"].ID
          $item["Sub Category"] = "$($currentSubCategory)|$($newSubCategory)"
        }
      }
      elseif ($shop["Sub-Category 2"] -ne "") {
        $category2Hash = Add-Category $RegionName $Language $shop["Category 1"] $shop["Sub-Category 2"]

        $currentSubCategory = $item["Sub Category"]
        $newSubCategory = $category2Hash["SubCategoryItem"].ID
        $item["Sub Category"] = "$($currentSubCategory)|$($newSubCategory)"
      }

      if ($shop["Category 3"] -ne "") {
        $category3Hash = Add-Category $RegionName $Language $shop["Category 3"] $shop["Sub-Category 3"]
        $currentCategory = $item["Category"]
        $newCategory = $category3Hash["CategoryItem"].ID
        $item["Category"] = "$($currentCategory)|$($newCategory)"
        if ($shop["Sub-Category 3"] -ne "") {
          $currentSubCategory = $item["Sub Category"]
          $newSubCategory = $category3Hash["SubCategoryItem"].ID
          $item["Sub Category"] = "$($currentSubCategory)|$($newSubCategory)"
        }
      }
      elseif ($shop["Sub-Category 3"] -ne "") {
        $category = $shop["Category 2"]
        if ($category -eq "") {
          $category = $shop["Category 1"]
        }
        $category3Hash = Add-Category $RegionName $Language $category $shop["Sub-Category 3"]

        $currentSubCategory = $item["Sub Category"]
        $newSubCategory = $category3Hash["SubCategoryItem"].ID
        $item["Sub Category"] = "$($currentSubCategory)|$($newSubCategory)"
      }

      if ($shop["Facebook URL"] -ne "") {
        $item["Facebook Url"] = '<link linktype="external" url="' + $shop["Facebook URL"] + '" anchor="" target="" />'
      }

      if ($shop["Instagram URL"] -ne "") {
        $item["Instagram Url"] = '<link linktype="external" url="' + $shop["Instagram URL"] + '" anchor="" target="" />'
      }

      if ($shop["Twitter URL"] -ne "") {
        $item["Twitter Url"] = '<link linktype="external" url="' + $shop["Twitter URL"] + '" anchor="" target="" />'
      }

      if ($shop["SITE URL"] -ne "") {
        $item["Store Website Url"] = '<link linktype="external" url="' + $shop["SITE URL"] + '" anchor="" target="" />'
      }

      if ($shop["Banner image"] -ne "") {
        $desktopImage = Utils-GetImageFromMediaLibrary $RegionName "" $siteName "Stores/desktop" $shop["Banner Image"] $defaultImage
        $mobileImage = Utils-GetImageFromMediaLibrary $RegionName "" $siteName "Stores/mobile" $shop["Banner Image"] $defaultImage
        $tabletImage = Utils-GetImageFromMediaLibrary $RegionName "" $siteName "Stores/tablet" $shop["Banner Image"] $defaultImage
        $largeImage = Utils-GetImageFromMediaLibrary $RegionName "" $siteName "Stores/large" $shop["Banner Image"] $defaultImage

        if($desktopImage -ne $null){
          $item["Background Image"] = '<image mediaid="' + $desktopImage.ID + '" alt="' + $desktopImage["Alt"] + '" height="" width="" hspace="" vspace="" />'
          $item["$($StoreType) Image"] = '<image mediaid="' + $desktopImage.ID + '" alt="' + $desktopImage["Alt"] + '" height="" width="" hspace="" vspace="" />'
        }
        if($mobileImage -ne $null){
          $item["Mobile Image"] = '<image mediaid="' + $mobileImage.ID + '" alt="' + $mobileImage["Alt"] + '" height="" width="" hspace="" vspace="" />'
        }
        if($tabletImage -ne $null){
          $item["Tablet Image"] = '<image mediaid="' + $tabletImage.ID + '" alt="' + $tabletImage["Alt"] + '" height="" width="" hspace="" vspace="" />'
        }
        if($largeImage -ne $null){
          $item["Large Image"] = '<image mediaid="' + $largeImage.ID + '" alt="' + $largeImage["Alt"] + '" height="" width="" hspace="" vspace="" />'
        }
      }

      $openingHourPath = $itemPath + "/Opening Hours/"
      $openingHourItems =  Get-ChildItem -Path $openingHourPath -Language $Language
      foreach($openingHourItem in $openingHourItems){
        $itemName = $openingHourItem.Name
        $opening = $shop[$itemName+' Opening']
        $closing = $shop[$itemName+' Closing']
       
        $openingHourItem.Editing.BeginEdit() | Out-Null
        $openingHourItem["Day"] = $map[$itemName]["Day"]
        $openingHourItem["Display Day"] = $map[$itemName]["Display Day"]
        if($opening -eq "closed" -or $closing -eq "closed"){
          $openingHourItem["Close"] = "1"
          $opening = $map[$itemName]["Opening Time"]
          $closing = $map[$itemName]["Closing Time"]
        }elseif($opening -ne "" -or $closing -ne "") {
          $opening = CleanHour $opening
          $closing = CleanHour $closing
        }
        $openingHourItem["Opening Time"] = $opening
        $openingHourItem["Closing Time"] = $closing
        $openingHourItem.Editing.EndEdit() | Out-Null
      }

      Content-Update-Meta-Data $item $shop $RegionName $MallName "Stores"

      $item.Editing.EndEdit() | Out-Null

      $count++
    }
  }

  end {
    Write-Host "Import Shops - End"
  }
}

function CleanHour {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true, Position = 0 )]
    [string]$Hour
  )
  process {
    if($Hour -contains ":"){
      $Hour = $Hour.Replace(":","")
      $Hour = "00010101T" + $Hour + "00"
    }
    return $Hour
  }
}

function Add-Category {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true, Position = 0 )]
    [string]$RegionName,

    [Parameter(Mandatory = $true, Position = 1 )]
    [string]$Language,

    [Parameter(Mandatory = $true, Position = 2 )]
    [string]$CategoryName,

    [Parameter(Mandatory = $false, Position = 3 )]
    [string]$SubCategoryName
  )

  begin {
    Import-Function Utils-Remove-Diacritics
  }

  process {
    $normalizeCategoryName = $normalizeCategoryName -Replace "'", " "
    $normalizeCategoryName = Utils-Remove-Diacritics $CategoryName
    $normalizeCategoryName = $normalizeCategoryName.trim()
    $categoryPath = "master:/content/Klepierre/$($RegionName)/Category Repository/$($normalizeCategoryName)"

    if (!(Test-Path -Path $categoryPath -ErrorAction SilentlyContinue)) {
      New-Item -Path $categoryPath -ItemType "{8368C239-3B61-4272-BB19-C4F7DF5DBB70}" -Language $Language | Out-Null
    }

    $categoryItem = Get-Item -Path $categoryPath -Language $Language

    $categoryItem.Editing.BeginEdit() | Out-Null
    $categoryItem["Category"] = $CategoryName
    $categoryItem.Editing.EndEdit() | Out-Null

    $hash = @{ }
    $hash["CategoryItem"] = $categoryItem

    if ($SubCategoryName -ne "") {
      $normalizeSubCategoryName = $normalizeSubCategoryName -Replace "'", " "
      $normalizeSubCategoryName = Utils-Remove-Diacritics $SubCategoryName
      $normalizeSubCategoryName = $normalizeSubCategoryName.trim()
      $subCategoryPath = "master:/content/Klepierre/$($RegionName)/Category Repository/$($normalizeCategoryName)/$($normalizeSubCategoryName)"

      if (!(Test-Path -Path $subCategoryPath -ErrorAction SilentlyContinue)) {
        New-Item -Path $subCategoryPath -ItemType "{8E759815-DB97-4E5B-856A-2CF06BAA67D0}" -Language $Language | Out-Null
      }

      $subCategoryItem = Get-Item -Path $subCategoryPath -Language $Language

      $subCategoryItem.Editing.BeginEdit() | Out-Null
      $subCategoryItem["Sub Category Name"] = $SubCategoryName
      $subCategoryItem.Editing.EndEdit() | Out-Null

      $hash["SubCategoryItem"] = $subCategoryItem
    }

    $hash
  }
}

function Add-Brand {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true, Position = 0 )]
    [string]$RegionName,

    [Parameter(Mandatory = $true, Position = 1 )]
    [string]$Language,

    [Parameter(Mandatory = $true, Position = 2 )]
    [string]$BrandName,

    [Parameter(Mandatory = $true, Position = 3 )]
    [string]$BrandLogo
  )

  begin {
    Import-Function Utils-Remove-Diacritics
  }

  process {
    $normalizeBrandName = $normalizeBrandName -Replace "'", " "
    $normalizeBrandName = Utils-Remove-Diacritics $BrandName
    $normalizeBrandName = $normalizeBrandName.trim()
    $brandPath = "master:/content/Klepierre/$($RegionName)/Brand Repository/$($normalizeBrandName)"

    if (!(Test-Path -Path $brandPath -ErrorAction SilentlyContinue)) {
      New-Item -Path $brandPath -ItemType "{1C5E49F3-3D24-4D4A-9042-2CA16741DEA1}" -Language $Language | Out-Null 
    }

    $brandItem = Get-Item -Path $brandPath -Language $Language

    $brandItem.Editing.BeginEdit() | Out-Null
    $brandItem["Brand Name"] = $BrandName

    if ($BrandLogo -ne "") {
      $logoImageItem = Utils-GetImageFromMediaLibrary $RegionName "" $siteName "Stores/Logo" $BrandLogo
      
      if ($null -ne $logoImageItem) {
        $logoImageID = $logoImageItem.ID

        $brandItem["Brand Logo"] = '<image mediaid="' + $logoImageID + '" alt="' + $logoImageItem["Alt"] + '" height="" width="" hspace="" vspace="" />'
        $brandItem["Large Brand Logo"] = '<image mediaid="' + $logoImageID + '" alt="' + $logoImageItem["Alt"] + '" height="" width="" hspace="" vspace="" />'
      }
    }
    
    $brandItem.Editing.EndEdit() | Out-Null

    $brandItem
  }
}