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
    # Import-Function Utils-Remove-Diacritics
    # Import-Function Utils-Upload-CSV-File
    # Import-Function Utils-GetImageFromMediaLibrary
    # Import-Function Content-Update-Meta-Data
  }

  process {
    $services = Utils-Upload-CSV-File -Title "Import Services"
    $total = $services.Count
    $count = 1
    #for Services Repository
    $topServices = @()
    $ServicesPath = "/sitecore/content/Klepierre/$($RegionName)/$($MallName)/Home/Services"
    $ServicesItem = Get-Item -Path $ServicesPath -Language  $Language

    $defaultImage = "default-shop.jpg"

    foreach ($service in $services) {
      $itemName = $service["Friendly URL"]
      if ($itemName -eq "" -or $itemName -eq " ") {
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
      # if ($service["Banner Image"] -ne "") {
      #   $imagesResponsive = Utils-GetImageFromMediaLibrary $RegionName "" $siteName "Services/desktop" $service["Banner Image"] $defaultImage
      #   $bannerImageItem = Utils-GetImageFromMediaLibrary $RegionName "" $siteName "Services/Banner-Image" $service["Banner Image"] $defaultImage
      #   if($null -ne $imagesResponsive){
      #     $bannerImageID = $service["Banner Image"]
      #   }elseif($null -ne $bannerImageItem){
      #       $bannerImageID = $bannerImageItem.ID
      #   }else{
      #     Write-Host $service["Banner Image"] " doesn't exist in media library"
      #   }
      # } else {
      #   $bannerImageID = ""
      # }

      Update-Service $item $breadCrumbTitle $title $categoryID $shortDescription $longDescription $bannerTitle $mapId $bannerImageID $pageDesignPath
      # Content-Update-Meta-Data $item $service $RegionName $MallName "Services"
      $item.Editing.EndEdit() | Out-Null
      $count++
    }
    $topServices = [System.String]::Join("|", $topServices)

    $categoryOrder = (Get-ChildItem -Path "master:/sitecore/content/Klepierre/France/Service Category Repository" | Select-Object -ExpandProperty Id) -join "|"

    $ServicesItem.Editing.BeginEdit() | Out-Null
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
    [string]$BannerImageID = "",

    [Parameter(Mandatory = $false, Position = 9)]
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
    #$Service["Banner Title"] = $BannerTitle
    $Service["Map Id"] = $MapId

    if ($LongDescription -ne "") {
      $Service["Show on breadcrumb"] = 1
    }

    if ($Service["Name"] -eq "") {
      $Service["Name"] = $Service.Name
    }

    # if ($BannerImageID -ne "") {
    #   if(!($BannerImageID -match "([^\s]+(\.|(jpg|png|gif|bmp))$)")){
    #     $Service["Background Image"] = '<image mediaid="' + $BannerImageID + '" alt="' + $bannerImageItem["Alt"] + '"  />'
    #     $Service["Mobile Image"] = '<image mediaid="' + $BannerImageID + '" alt="' + $bannerImageItem["Alt"] + '"  />'
    #     $Service["Tablet Image"] = '<image mediaid="' + $BannerImageID + '" alt="' + $bannerImageItem["Alt"] + '"  />'
    #     $Service["Large Image"] = '<image mediaid="' + $BannerImageID + '" alt="' + $bannerImageItem["Alt"] + '"  />'
        
    #     $Service["Mobile Tile Image"] = '<image mediaid="' + $BannerImageID + '" alt="' + $bannerImageItem["Alt"] + '"  />'
    #     $Service["Tablet Tile Image"] = '<image mediaid="' + $BannerImageID + '" alt="' + $bannerImageItem["Alt"] + '"  />'
    #     $Service["Large Tile Image"] = '<image mediaid="' + $BannerImageID + '" alt="' + $bannerImageItem["Alt"] + '"  />'
    #   }else{
    #     $desktopImage = Utils-GetImageFromMediaLibrary $RegionName "" $siteName "Services/desktop" $BannerImageID
    #     $mobileImage = Utils-GetImageFromMediaLibrary $RegionName "" $siteName "Services/mobile" $BannerImageID
    #     $tabletImage = Utils-GetImageFromMediaLibrary $RegionName "" $siteName "Services/tablet" $BannerImageID
    #     $largeImage = Utils-GetImageFromMediaLibrary $RegionName "" $siteName "Services/large" $BannerImageID

    #     if($desktopImage -ne $null){
    #       $Service["Background Image"] = '<image mediaid="' + $desktopImage.ID + '" alt="' + $desktopImage["Alt"] + '"  />'
    #       $Service["Mobile Tile Image"] = '<image mediaid="' + $desktopImage.ID + '" alt="' + $desktopImage["Alt"] + '"  />'
    #       $Service["Tablet Tile Image"] = '<image mediaid="' + $desktopImage.ID + '" alt="' + $desktopImage["Alt"] + '"  />'
    #       $Service["Large Tile Image"] = '<image mediaid="' + $desktopImage.ID + '" alt="' + $desktopImage["Alt"] + '"  />'
    #     }
    #     if($mobileImage -ne $null){
    #       $Service["Mobile Image"] = '<image mediaid="' + $mobileImage.ID + '" alt="' + $mobileImage["Alt"] + '"  />'
    #     }
    #     if($tabletImage -ne $null){
    #       $Service["Tablet Image"] = '<image mediaid="' + $tabletImage.ID + '" alt="' + $tabletImage["Alt"] + '"  />'
    #     }
    #     if($largeImage -ne $null){
    #       $Service["Large Image"] = '<image mediaid="' + $largeImage.ID + '" alt="' + $largeImage["Alt"] + '"  />'
    #     }
    #   }
    # }
  }
}

Import-Content-Services "Spain" "es-es" "MaremagnumES"