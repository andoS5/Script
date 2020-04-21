function Import-Content-Resto {
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
    Write-Host "Import Resto - Begin"
    Import-Function Utils-Remove-Diacritics
    Import-Function Utils-Convert-PSObject-To-Hashtable
    Import-Function Utils-GetImageFromMediaLibrary
  }

  process {
    $dataFolder = [Sitecore.Configuration.Settings]::DataFolder
    $tempFolder = $dataFolder + "\temp\upload"
    $filePath = Receive-File -Path $tempFolder -overwrite
    $fileCSV = Import-Csv $filePath

    $shops = Utils-Convert-PSObject-To-Hashtable $fileCSV
    $total = $shops.Count
    $count = 1
    foreach ($shop in $shops) {
      $itemName = $shop["Friendly URL"]

      $siteName = $MallName -Replace '[\W]', '-'
      $itemPath = "master:/content/Klepierre/$($RegionName)/$($siteName)/Home/Shop Repository/$($itemName)"

      if (!(Test-Path -Path $itemPath -ErrorAction SilentlyContinue)) {
        $siteBranch = "Branches/Feature/Kortex/Practical Info/Restaurant"
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
      $item["Page Title"] = $shop["Meta Title"]
      $item["Meta Description"] = $shop["Meta Description"]
      $item["Meta Keywords"] = $shop["Meta Keywords"]
      $item["Restaurant Title"] = $shop["Shop Name"]
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
        $bannerImageItem = Utils-GetImageFromMediaLibrary $RegionName "" $siteName "Stores/Banner-Image" $shop["Banner Image"]

        if ($null -ne $bannerImageItem) {
          $bannerImageID = $bannerImageItem.ID

          $item["Background Image"] = '<image mediaid="' + $BannerImageID + '" alt="' + $bannerImageItem["Alt"] + '" height="" width="" hspace="" vspace="" />'
          $item["Mobile Image"] = '<image mediaid="' + $BannerImageID + '" alt="' + $bannerImageItem["Alt"] + '" height="" width="" hspace="" vspace="" />'
          $item["Tablet Image"] = '<image mediaid="' + $BannerImageID + '" alt="' + $bannerImageItem["Alt"] + '" height="" width="" hspace="" vspace="" />'
          $item["Large Image"] = '<image mediaid="' + $BannerImageID + '" alt="' + $bannerImageItem["Alt"] + '" height="" width="" hspace="" vspace="" />'
          $item["Restaurant Image"] = '<image mediaid="' + $BannerImageID + '" alt="' + $bannerImageItem["Alt"] + '" height="" width="" hspace="" vspace="" />'
        }
      }

      $item.Editing.EndEdit() | Out-Null

      $count++
    }
  }

  end {
    Write-Host "Import Resto - End"
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