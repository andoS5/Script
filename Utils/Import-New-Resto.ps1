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

$file = Utils-Upload-CSV-File -title "Import new resto"
$version = "Da"
foreach($f in $file){
    $itemName = $f."Friendly URL".Trim()
    $path = "/sitecore/content/Klepierre/Denmark/BruunsGalleri/Home/Shop Repository/$itemName"
    if(!(Test-Path -Path $path -ErrorAction SilentlyContinue)){
        Write-Host "Create New resto $itemName"
        New-Item -Path $path -ItemType "{A496118C-D0EF-440D-8DF5-5DEFE47E662E}" -Language $version | Out-Null
    }

    ##Images
    $imageArr = $f."Banner image".Split(".")
    $imageName = $imageArr[0]

    $pathImage = "/sitecore/media library/Project/Klepierre/Denmark/BruunsGalleri/Stores"

    <#*$typeImage = @("Desktop","Large","Tablet","Mobile","Tile")
    foreach($img in $typeImage){
        $pathImage = "/sitecore/media library/Project/Klepierre/Denmark/BruunsGalleri/Stores/$($img)/$($imageName)"
        if(!(Test-Path -Path $pathImage -ErrorAction SilentlyContinue)){
            
        }
    }#>
    $desktopImage = if((Test-Path -Path "$($pathImage)/Desktop/$imageName" -ErrorAction SilentlyContinue)){Get-Item -Path "$($pathImage)/Desktop/$imageName"} else{""}
    $largeImage = if((Test-Path -Path "$($pathImage)/Large/$imageName" -ErrorAction SilentlyContinue)){Get-Item -Path "$($pathImage)/Large/$imageName"} else{""}
    $tabletImage = if((Test-Path -Path "$($pathImage)/Tablet/$imageName" -ErrorAction SilentlyContinue)){Get-Item -Path "$($pathImage)/Tablet/$imageName"} else{""}
    $mobileImage = if((Test-Path -Path "$($pathImage)/Mobile/$imageName" -ErrorAction SilentlyContinue)){Get-Item -Path "$($pathImage)/Mobile/$imageName"} else{""}
    $tileImage = if((Test-Path -Path "$($pathImage)/Tile/$imageName" -ErrorAction SilentlyContinue)){Get-Item -Path "$($pathImage)/Tile/$imageName"} else{""}


    #Create Brand
    $pathBrand = "/sitecore/content/Klepierre/Denmark/Brand Repository/$itemName"

    if(!(Test-Path -Path $pathBrand -ErrorAction SilentlyContinue)){
        Write-Host "Create New Brand $itemName"
        New-Item -Path $pathBrand -ItemType "{1C5E49F3-3D24-4D4A-9042-2CA16741DEA1}" -Language $version | Out-Null
    }
    
    $brandItem = Get-Item -Path $pathBrand -Language $version -ErrorAction SilentlyContinue
    if(($null -ne $brandItem)){
        $brandItem.Editing.BeginEdit() | Out-Null
        $brandItem["Brand Name"] = $f."Shop Name".Trim()
        $brandItem.Editing.EndEdit() | Out-Null
    }


    Write-Host "Update $itemName"

    $item = Get-Item -Path $path -Language $version -ErrorAction SilentlyContinue
    
   # $site = $f."SITE URL".Trim()
    #$face = $f."Facebook".Trim()
    #$insta = $f."INSTAGRAM".Trim()
   # $siteVal = "<link linktype=`"external`" url=`"$($site)`" anchor=`"`" target=`"_blank`" />"
   # $fbVal = "<link linktype=`"external`" url=`"$($face)`" anchor=`"`" target=`"_blank`" />"
   # $instaVal = "<link linktype=`"external`" url=`"$($insta)`" anchor=`"`" target=`"_blank`" />"
    if($null -ne $itemName){
        $item.Editing.BeginEdit() | Out-Null
        $item["Breadcrumb Title"] = $f."Shop Name".Trim()
        $item["Show on breadcrumb"] = "1"
        $item["Restaurant Title"] = $f."Shop Name".Trim()
        $item["Description"] = $f."Description".Trim()
        $item["Contact"] = $f."Phone Number".Trim()
        $item["Category"] = "{C49A5C58-3800-4433-A414-24F2280706EC}"
        $item["Page Title"] = $f."Meta Title".Trim()
        $item["Meta Description"] = $f."Meta Description".Trim()
        $item["Brand"] = $brandItem.ID
        $item["Store Website Url"] = $siteVal
        $item["Facebook Url"] = $fbVal
        $item["Instagram Url"] = $instaVal

        if($largeImage -ne $null){
          $item["Background Image"] = '<image mediaid="' + $largeImage.ID + '" alt="' + $largeImage.Name + '" height="" width="" hspace="" vspace="" />'
          
        }
        if($mobileImage -ne $null){
          $item["Mobile Image"] = '<image mediaid="' + $mobileImage.ID + '" alt="' + $mobileImage.Name + '" height="" width="" hspace="" vspace="" />'
          $item["Open Graph Image"] = '<image mediaid="' + $mobileImage.ID + '" alt="' + $mobileImage.Name + '" height="" width="" hspace="" vspace="" />'
        }
        if($tabletImage -ne $null){
          $item["Tablet Image"] = '<image mediaid="' + $tabletImage.ID + '" alt="' + $tabletImage.Name + '" height="" width="" hspace="" vspace="" />'
        }
        if($desktopImage -ne $null){
          $item["Large Image"] = '<image mediaid="' + $desktopImage.ID + '" alt="' + $desktopImage.Name+ '" height="" width="" hspace="" vspace="" />'
        }
        if($tileImage -ne $null){
          $item["Restaurant Image"] = '<image mediaid="' + $tileImage.ID + '" alt="' + $tileImage.Name+ '" height="" width="" hspace="" vspace="" />'
        }
        $item.Editing.EndEdit() |Out-Null

        #Update Hour 
        $pathHourRepo = "/sitecore/content/Klepierre/Denmark/BruunsGalleri/Home/Shop Repository/$($itemName)/Opening Hours/"

        if(!(Test-Path -Path $pathHourRepo -ErrorAction SilentlyContinue)){
            Write-Host "$pathHourRepo doesn't exist"

            New-Item -Path $pathHourRepo -ItemType "{DBC3FD11-335D-480C-A9EC-CFE176CE7494}" -Language $version | Out-Null

            $week = @("Monday","Tuesday","Wednesday","Thursday","Friday","Saturday","Sunday")
            foreach($w in $week){
                $pathWeek = $pathHourRepo + $w
                if(!(Test-Path -Path $pathWeek -ErrorAction SilentlyContinue)){
                    Write-Host "Create $w"
                    New-Item -Path $pathWeek -ItemType "{6C32F517-77B1-4E0C-B8CE-D1FE77E25563}" -Language $version
                }
            }
        }

        $days = Get-ChildItem -Path $pathHourRepo -Language $version -ErrorAction SilentlyContinue
        if($null -eq $days){
            Write-Host "$path has a problem "
            continue
        }
        foreach($d in $days){
            Write-Host "Update $($d.Name)"
            $PathDayRepo = "/sitecore/content/Klepierre/Shared/Days Repository/$($d.Name)"
            $dayRepo = Get-Item -Path $PathDayRepo
            $d.Editing.BeginEdit() |Out-Null
            $d["Day"] = $dayRepo.ID
            $d["Close"] = "1"
            $d["Opening Time"] = "00010101T100000"
            $d["Closing Time"] = "00010101T200000"
            $d.Editing.EndEdit() | Out-Null
        }
    }else{
        Write-Host "$path doesn't exist"
        Continue
    }
}