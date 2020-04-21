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


$Datas = Utils-Upload-CSV-File -Title "Open/Close Stores"

foreach ($data in $Datas) {
    $shopID = $data["ShopID"].Trim()
    $shopRegion = $data["RegionName"].Trim()
    $shopMall = $data["MallName"].Trim()
    $shopLanguage = $data["Language"].Trim()
    $shopItem = Get-Item -Path "master:" -ID "$shopID" -Language $shopLanguage
    $shopName = $shopItem.Name
    $shopPath = "master:/sitecore/content/Klepierre/$shopRegion/$shopMall/Home/Shop Repository/$shopName/Opening Hours"

    $Monday = $null
    if($data["Monday"] -match "^Open"){
        $Monday = 0
    }else{
        $Monday = 1
    }
    $MondayItem = Get-Item -Path "$shopPath/Monday" -Language $shopLanguage
    $MondayItem.Editing.BeginEdit() | Out-Null
    Write-Host "Setting $shopRegion - $shopName Day :$($MondayItem.Name) Open/Close : $Monday" -ForegroundColor Yellow
    $MondayItem["Close"] = $Monday
    $MondayItem.Editing.EndEdit() | Out-Null

    #Tuesday
    $Tuesday = $null
    if($data["Tuesday"] -match "^Open"){
        $Tuesday = 0
    }else{
        $Tuesday = 1
    }

    $TuesdayItem = Get-Item -Path "$shopPath/Tuesday" -Language $shopLanguage
    $TuesdayItem.Editing.BeginEdit() | Out-Null
    Write-Host "Setting $shopRegion - $shopName Day :$($TuesdayItem.Name) Open/Close : $Tuesday" -ForegroundColor Yellow
    $TuesdayItem["Close"] = $Tuesday
    $TuesdayItem.Editing.EndEdit() | Out-Null

    #Wednesday
    $Wednesday = $null
    if($data["Wednesday"] -match "^Open"){
        $Wednesday = 0
    }else{
        $Wednesday = 1
    }

    $WednesdayItem = Get-Item -Path "$shopPath/Wednesday" -Language $shopLanguage
    $WednesdayItem.Editing.BeginEdit() | Out-Null
    Write-Host "Setting $shopRegion - $shopName Day :$($WednesdayItem.Name) Open/Close : $Wednesday" -ForegroundColor Yellow
    $WednesdayItem["Close"] = $Wednesday
    $WednesdayItem.Editing.EndEdit() | Out-Null

    #Thursday
    $Thursday = $null
    if($data["Thursday"] -match "^Open"){
        $Thursday = 0
    }else{
        $Thursday = 1
    }

    $ThursdayItem = Get-Item -Path "$shopPath/Thursday" -Language $shopLanguage
    $ThursdayItem.Editing.BeginEdit() | Out-Null
    Write-Host "Setting $shopRegion - $shopName Day :$($ThursdayItem.Name) Open/Close : $Thursday" -ForegroundColor Yellow
    $ThursdayItem["Close"] = $Thursday
    $ThursdayItem.Editing.EndEdit() | Out-Null

    #friday
    $Friday = $null
    if($data["Friday"] -match "^Open"){
        $Friday = 0
    }else{
        $Friday = 1
    }

    $FridayItem = Get-Item -Path "$shopPath/Friday" -Language $shopLanguage
    $FridayItem.Editing.BeginEdit() | Out-Null
    Write-Host "Setting $shopRegion - $shopName Day :$($FridayItem.Name) Open/Close : $Friday" -ForegroundColor Yellow
    $FridayItem["Close"] = $Friday
    $FridayItem.Editing.EndEdit() | Out-Null

    #saturday
    $Saturday = $null
    if($data["Saturday"] -match "^Open"){
        $Saturday = 0
    }else{
        $Saturday = 1
    }
    $SaturdayItem = Get-Item -Path "$shopPath/Saturday" -Language $shopLanguage
    $SaturdayItem.Editing.BeginEdit() | Out-Null
    Write-Host "Setting $shopRegion - $shopName Day :$($SaturdayItem.Name) Open/Close : $Saturday" -ForegroundColor Yellow
    $SaturdayItem["Close"] = $Saturday
    $SaturdayItem.Editing.EndEdit() | Out-Null

    #sunday
    $Sunday = $null
    if($data["Sunday"] -match "^Open"){
        $Sunday = 0
    }else{
        $Sunday = 1
    }
    $SundayItem = Get-Item -Path "$shopPath/Sunday" -Language $shopLanguage
    $SundayItem.Editing.BeginEdit() | Out-Null
    Write-Host "Setting $shopRegion - $shopName Day :$($SundayItem.Name) Open/Close : $Sunday" -ForegroundColor Yellow
    $SundayItem["Close"] = $Sunday
    $SundayItem.Editing.EndEdit() | Out-Null
}