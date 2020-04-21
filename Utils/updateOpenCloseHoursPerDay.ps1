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

$Datas = Utils-Upload-CSV-File -Title "Open/Close Stores"

foreach ($data in $Datas) {
    $shopID = $data["ShopID"].Trim()

    $shopItem = Get-Item -Path "master:" -ID "$shopID" -Language "nb-NO"

    $openingHoursItem = Get-Item -Path "$($shopItem.FullPath)/Opening Hours" -Language "nb-NO"
    $day = $openingHoursItem.Children

    $day[0].Editing.BeginEdit() | Out-Null

    if ( $data["MondayOpening"].Trim() -eq $data["MondayClosing"].Trim()) {
        $day[0]['Close'] = 1
    }
    else {
        $day[0]['Close'] = 0
    }
    
    
    $day[0]['Opening Time'] = CleanHour $data["MondayOpening"].Trim()
    $day[0]['Closing Time'] = CleanHour $data["MondayClosing"].Trim()
    $day[0].Editing.EndEdit() | Out-Null

    $day[1].Editing.BeginEdit() | Out-Null

    if ( $data["TuesdayOpening"].Trim() -eq $data["TuesdayClosing"].Trim()) {
        $day[1]['Close'] = 1
    }
    else {
        $day[1]['Close'] = 0
    }
    $day[1]['Opening Time'] = CleanHour $data["TuesdayOpening"].Trim()
    $day[1]['Closing Time'] = CleanHour $data["TuesdayClosing"].Trim()
    $day[1].Editing.EndEdit() | Out-Null

    $day[2].Editing.BeginEdit() | Out-Null

    if ( $data["WednesdayOpening"].Trim() -eq $data["WednesdayClosing"].Trim()) {
        $day[2]['Close'] = 1
    }
    else {
        $day[2]['Close'] = 0
    }
    $day[2]['Opening Time'] = CleanHour $data["WednesdayOpening"].Trim()
    $day[2]['Closing Time'] = CleanHour $data["WednesdayClosing"].Trim()
    $day[2].Editing.EndEdit() | Out-Null

    $day[3].Editing.BeginEdit() | Out-Null

    if ( $data["ThursdayOpening"].Trim() -eq $data["ThursdayClosing"].Trim()) {
        $day[3]['Close'] = 1
    }
    else {
        $day[3]['Close'] = 0
    }
    $day[3]['Opening Time'] = CleanHour $data["ThursdayOpening"].Trim()
    $day[3]['Closing Time'] = CleanHour $data["ThursdayClosing"].Trim()
    $day[3].Editing.EndEdit() | Out-Null

    $day[4].Editing.BeginEdit() | Out-Null
    if ( $data["FridayOpening"].Trim() -eq $data["FridayClosing"].Trim()) {
        $day[4]['Close'] = 1
    }
    else {
        $day[4]['Close'] = 0
    }
    $day[4]['Opening Time'] = CleanHour $data["FridayOpening"].Trim()
    $day[4]['Closing Time'] = CleanHour $data["FridayClosing"].Trim()
    $day[4].Editing.EndEdit() | Out-Null

    $day[5].Editing.BeginEdit() | Out-Null

    if ( $data["SaturdayOpening"].Trim() -eq $data["SaturdayClosing"].Trim()) {
        $day[5]['Close'] = 1
    }
    else {
        $day[5]['Close'] = 0
    }
    $day[5]['Opening Time'] = CleanHour $data["SaturdayOpening"].Trim()
    $day[5]['Closing Time'] = CleanHour $data["SaturdayClosing"].Trim()
    $day[5].Editing.EndEdit() | Out-Null

    $day[6].Editing.BeginEdit() | Out-Null

    if ( $data["SundayOpening"].Trim() -eq $data["SundayClosing"].Trim()) {
        $day[6]['Close'] = 1
    }
    else {
        $day[6]['Close'] = 0
    }
    $day[6]['Opening Time'] = CleanHour $data["SundayOpening"].Trim()
    $day[6]['Closing Time'] = CleanHour $data["SundayClosing"].Trim()
    $day[6].Editing.EndEdit() | Out-Null
 
}