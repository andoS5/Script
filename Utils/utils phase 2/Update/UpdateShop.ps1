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






function CleanHour {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory = $true, Position = 0 )]
        [string]$Hour
    )
    process {
        $Hour = $Hour.Trim()
        if ($Hour.Contains(" ")) {
            $Hour = $Hour.Substring(0, $Hour.IndexOf(" "))
        }
        if ($Hour.Contains(":")) {
            $Htab = $Hour.split(":")
            $Hour = "00010101T" + $Htab[0] + $Htab[1] + "00"
        }
      
        return $Hour
    }
}
function updateOrCreateShop-Restaurant {

    param (
        [Parameter(Mandatory = $true, Position = 0 )]
        [string]$RegionName,
        [Parameter(Mandatory = $true, Position = 1 )]
        [string]$MallName,
        [Parameter(Mandatory = $true, Position = 2 )]
        [string]$Language
    )

    $Datas = Utils-Upload-CSV-File -Title "Create Or update Store - Restaurant"
    $count = $Datas.Count

    $shopRepository = "master:/sitecore/content/Klepierre/$RegionName/$MallName/Home/Shop Repository"
    foreach ($data in $Datas) {
        
        if ($data.ItemType -like "shop") {
            
        }

    }
}