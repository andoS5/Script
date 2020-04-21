function update-parking-gate{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0 )]
        [string]$RegionName,

        [Parameter(Mandatory = $true, Position = 1 )]
        [string]$MallName,

        [Parameter(Mandatory = $true, Position = 2 )]
        [string]$Language
      
    )

    begin{
        Write-Host "Update Parking and Gate for $RegionName/$MallName - Start" -ForegroundColor Yellow
    }

    process{
        $Datas = Utils-Upload-CSV-File -Title "Update Parking and Gate"

        foreach($Data in $Datas){
            $shopName = if(![string]::IsNullOrEmpty($Data."Friendly URL")){Utils-Remove-Diacritics $Data."Friendly URL"} else {}
            $itemPath = "master:/sitecore/content/Klepierre/$RegionName/$MallName/Home/Shop Repository/$shopName"

            if((Test-Path -Path $itemPath -ErrorAction SilentlyContinue)){

                #get the ID of gate and parking
                $NearestEntrance = $Data."Nearest entrance"
                $NearestParking = $Data."Nearest parking"

                $parkingRepository ="master:/sitecore/content/Klepierre/$RegionName/$MallName/Selections/Parking Repository"
                $gateRepository = "master:/sitecore/content/Klepierre/$RegionName/$MallName/Selections/Gate"

                $parkingItem = if((Test-Path -Path "$parkingRepository/$NearestParking" -ErrorAction SilentlyContinue)){Get-Item -Path "$parkingRepository/$NearestParking" -Language $Language}
                $parkingID = $parkingItem.ID

                $gateItem = if((Test-Path -Path "$gateRepository/$NearestEntrance" -ErrorAction SilentlyContinue)){Get-Item -Path "$gateRepository/$NearestEntrance" -Language $Language}
                $gateID = $gateItem.ID

                $item = Get-Item -Path $itemPath -Language $Language

                $item.Editing.BeginEdit() | Out-Null
                Write-Host "Starting update for $MallName ==> parking = $($parkingItem.Name) === Gate = $($gateItem.Name) Start" -ForegroundColor Yellow
                $item["Parking"] = $parkingID
                $item["Gate"] = $gateID
                Write-Host "Done" -ForegroundColor Green
                $item.Editing.EndEdit() | Out-Null

                # Write-Host $gateItem.Name $gateID $parkingItem.Name $parkingID 

            }

        }
        



    }

    end{
        Write-Host "Update Parking and Gate for $RegionName/$MallName - Done" -ForegroundColor Green
    }
}


function create-parking-gate{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0 )]
        [string]$RegionName,

        [Parameter(Mandatory = $true, Position = 1 )]
        [string]$MallName,

        [Parameter(Mandatory = $true, Position = 2 )]
        [string]$Language,

        [Parameter(Mandatory = $true, Position = 3 )]
        $Data,

        [Parameter(Mandatory = $true, Position = 4 )]
        [string]$type

      
    )

    begin{
        Write-Host "Create Parking and Gate for $RegionName/$MallName - Start" -ForegroundColor Yellow
    }

    process{
        $parkingRepository ="master:/sitecore/content/Klepierre/$RegionName/$MallName/Selections/Parking Repository"
        $gateRepository = "master:/sitecore/content/Klepierre/$RegionName/$MallName/Selections/Gate"
        if($type -eq "parking"){
            $itemName = $Data."Nearest parking"
            New-Item -Path "$parkingRepository/$itemName" -ItemType "{B4BFB2C4-92F2-4B7C-A81F-442017874B49}" -Language $Language | Out-Null
        }

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

update-parking-gate "France" "Beaulieu" "Fr-fr"