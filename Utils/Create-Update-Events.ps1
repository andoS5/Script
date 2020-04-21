function Create-Update-Events {
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
        Write-Host "Starting import Events"
    }
    process {

        $Data = Utils-Upload-CSV-File -title "CREATE OR UPDATE NEWS"
        # Check-Events-Repository $RegionName $MallName $Language
        Create-Update-EventItem $RegionName $MallName $Language $Data
    }
    end {
        Write-Host "Ending import Events"
    }

}

function Check-Events-Repository {
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
        Write-Host "Checking Events Repository - Begin"
    }
    process {
        $EventsRepository = "/sitecore/content/Klepierre/$RegionName/$MallName/Home/Events and News/Events"

        if (!(Test-Path -Path $EventsRepository -ErrorAction SilentlyContinue)) {
            New-Item -Path $EventsRepository -ItemType "{B4BFB2C4-92F2-4B7C-A81F-442017874B49}" -Language $Language | Out-Null
        }
        else {
            Write-Host "Repository already exist"
        }
    }
    end {
        Write-Host "Checking - Done"
    }
}

function Create-Update-EventsFolder {
    [CmdletBinding()]
    [Parameter(Mandatory = $true, Position = 0 )]
    [string]$RegionName,

    [Parameter(Mandatory = $true, Position = 1 )]
    [string]$MallName,

    [Parameter(Mandatory = $true, Position = 2 )]
    [string]$Language
    
    ]

    begin {
        Write-Host "Creating Events Folder - Begin"
    }
    process {
        $EventsFolderPath = "master:/sitecore/content/Klepierre/$RegionName/$MallName/Home/Events and News/Events"

        if (!(Test-Path -Path $EventsFolderPath -ErrorAction SilentlyContinue)) {
            New-Item -Path $EventsFolderPath -ItemType "{B4BFB2C4-92F2-4B7C-A81F-442017874B49}" -Language $Language | Out-Null
        }
        else {
            Write-Host "Events Folder Already exist ..."
        }
    }
    end {
        Write-Host "Events Folder Created successfully"
    }
}


function Create-Update-EventItem {
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
        Write-Host "Creating Events Item - Begin"
    }
    process {

        # $EventsRepository = "master:/sitecore/content/Klepierre/$RegionName/$MallName/Home/Events and News/Events"
        # if(!(Test-Path -Path $EventsRepository -ErrorAction SilentlyContinue)){
        #     New-Item -Path $EventsRepository -ItemType "{B4BFB2C4-92F2-4B7C-A81F-442017874B49}" -Language $Language | Out-Null
        # }

        foreach ($datas in $Data) {
            $itemName = Utils-Remove-Diacritics $datas."Friendly URL"
            $EventsItemPath = "master:/sitecore/content/Klepierre/$RegionName/$MallName/Home/Events and News/Events/$itemName"

            if (!(Test-Path -Path $EventsItemPath -ErrorAction SilentlyContinue)) {
                New-Item -Path $EventsItemPath -ItemType "{4058CE82-4516-4650-A69E-162D72F766D6}" -Language $Language | Out-Null
            }

            #images
            $MediaRepository = "master:/sitecore/media library/Project/Klepierre/$RegionName/$MallName/News-and-Events"
            $imageName = $datas."Image name"
            $ImageAltText = $datas."AltImageText"
            $LargeImage = if ((Test-Path -Path "$MediaRepository/$($imageName)_large" -ErrorAction SilentlyContinue)) { Get-Item -Path  "$MediaRepository/$($imageName)_large" } else { }
            $LargeImageID = if ($LargeImage) { $LargeImage.ID }else { }               
            $DesktopImage = if ((Test-Path -Path "$MediaRepository/$($imageName)_desktop" -ErrorAction SilentlyContinue)) { Get-Item -Path  "$MediaRepository/$($imageName)_desktop" } else { }
            $DesktopImageID = if ($DesktopImage) { $DesktopImage.ID }else { }   
            $TabletImage = if ((Test-Path -Path "$MediaRepository/$($imageName)_tablet" -ErrorAction SilentlyContinue)) { Get-Item -Path  "$MediaRepository/$($imageName)_tablet" } else { }
            $TabletImageID = if ($TabletImage) { $TabletImage.ID }else { }
            $MobileImage = if ((Test-Path -Path "$MediaRepository/$($imageName)_mobile" -ErrorAction SilentlyContinue)) { Get-Item -Path  "$MediaRepository/$($imageName)_mobile" } else { } 
            $MobileImageID = if ($MobileImage) { $MobileImage.ID }else { }
            $Tileimage = if ((Test-Path -Path "$MediaRepository/$($imageName)_tile" -ErrorAction SilentlyContinue)) { Get-Item -Path  "$MediaRepository/$($imageName)_mobile" } else { } 
            $TileimageID = if ($Tileimage) { $Tileimage.ID }else { }

            
            

            $item = Get-Item -Path $EventsItemPath -Language $Language
            $item.Editing.BeginEdit() | Out-Null
            # $item["Breadcrumb Title"] = $datas."Title"
            # $item["Show on breadcrumb"] = 1
            # $item["Page Design"] = "{CD1EB3EB-64B7-4275-8B8A-F9FC160DE91A}"
            # $item["Banner Title"] = $datas."Title"
            # $item["Banner Title"] = ""
            $item["Background Image"] = "<image mediaid=`"$LargeImageID`" alt=`"$ImageAltText`" height=`"`" width=`"`" hspace=`"`" vspace=`"`" />"
            $item["Event Tile Large Image"] = "<image mediaid=`"$TileimageID`" alt=`"$ImageAltText`" height=`"`" width=`"`" hspace=`"`" vspace=`"`" />"
            $item["Large Image"] = "<image mediaid=`"$DesktopImageID`" alt=`"$ImageAltText`" height=`"`" width=`"`" hspace=`"`" vspace=`"`" />"
            $item["Tablet Image"] = "<image mediaid=`"$TabletImageID`" alt=`"$ImageAltText`" height=`"`" width=`"`" hspace=`"`" vspace=`"`" />"
            $item["Mobile Image"] = "<image mediaid=`"$MobileImageID`" alt=`"$ImageAltText`" height=`"`" width=`"`" hspace=`"`" vspace=`"`" />"
            # $item["Event title"] = $datas."Title"
            # $item["Use Multiple Dates"] = #optional

            #Date and Time
            # if (!([string]::IsNullOrEmpty($datas."Event start date"))) {
            #     $dateStart = $datas."Event start date"
            #     $dateEnd = $datas."Event end date"
            #     $timeStart = "10:00:00"
            #     $timeEnd = "20:00:00"
            #     [datetime]$FormatedDateStart = $dateStart
            #     [datetime]$FormatedDateEnd = $dateEnd
            #     [datetime]$FromatedTimeStart = $timeStart
            #     [datetime]$FromatedTimeEnd = $timeEnd
            #     $newDateStart = $FormatedDateStart.ToString("yyyyMMdd")
            #     $newDateEnd = $FormatedDateEnd.ToString("yyyyMMdd")
            #     $newTimeStart = $FromatedTimeStart.ToString("HHmmss")
            #     $newTimeEnd = $FromatedTimeEnd.ToString("HHmmss")

            #     $DateTimeStart = $newDateStart + "T" + $newTimeStart + "Z"
            #     $DateTimeEnd = $newDateEnd + "T" + $newTimeEnd + "Z"
            #     $item["Event date Start"] = $DateTimeStart
            #     $item["Event date End"] = $DateTimeEnd
            # }
            
            # $item["Event short description"] = $datas."Short description" #ok
            # $item["Abstract"] = $datas."Description" #ok
            # # $item["Event Location"] = $datas."Friendly URL"
            # $item["ChangeFrequency"] = "{D23B4654-53A5-4589-8B1B-5665A763D144}" #ok
            # $item["Priority"] = "{19F3E919-4991-495F-9207-E1DADFD06F54}" #ok
            # # $item["First Title Event"] = $datas."Title"
            # $item["First Title Event"] = ""
            # $item["First Description Event"] = $datas."Full description text"
            # # $item["First Image"] = 
            # # $item["Second Title Event"] = $datas."Title"
            # $item["Second Title Event"] = ""
            # # $item["Second Description"] = $datas."Full description text"
            # $item["Second Description"] = ""
            # # $item["Second Image"] = 
            # $item["See More CTA"] = "VIS FLERE!"
            # $item["Page Title"] = $datas."metaTitle"
            # $item["Meta Description"] = $datas."metaDescription"
            # $item["Open Graph Image"] = "<image mediaid=`"$MobileImageID`" alt=`"$ImageAltText`" height=`"`" width=`"`" hspace=`"`" vspace=`"`" />"
            # $item["Show on Mobile"] = 1
            $item["__Workflow"] = "{ADFA8C60-8AF8-4B6F-8275-E28A105A6268}"
            $item["__Workflow state"] = "{1E4BF529-524E-4A9C-89E2-01F0BFAB4C31}"
            $item["__Default workflow"] = "{ADFA8C60-8AF8-4B6F-8275-E28A105A6268}"
            $item.Editing.EndEdit() | Out-Null
            
        }
        
    }
    end {
        Write-Host "Events Folder Created successfully"
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
            $NewsPageContent = "master:/sitecore/content/Klepierre/$RegionName/$MallName/Home/Events and News/Events/$itemName/Page Components"
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
Create-Update-Events "Denmark" "fields" "da" 
# Create-Update-EventItem "France" "Odysseum" "Fr-fr" 