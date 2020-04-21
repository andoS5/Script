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


$csv = Utils-Upload-CSV-File -title "Import chatBot"

$regions = Get-ChildItem -Path "/sitecore/content/Klepierre/" | Where { $_.Name -eq "France" }
foreach ($region in $regions) {
    $sites = Get-ChildItem -Item $region | Where { $_.TemplateID -eq "{46591E02-8902-4C2C-AF61-3EB92BE2489A}" -and !($_.Name -match "ValDeuropeEn") }

    foreach ($site in $sites) {
        $settingPath = "$($site.FullPath)/Settings/Site Grouping/$($site.Name)"
        $settingItem = Get-Item -Path $settingPath
        $version = $settingItem["Language"]
		
        $path = "/sitecore/content/Klepierre/$($region.Name)/$($site.Name)/Resource Keys/Chatbot"
        # $childs = Get-ChildItem -Path $path | Where {$_.TemplateID -eq "{87B5C7E6-1EFF-4AE2-8E28-AB3668399F91}" -and $_.Name -ne "Exceptionnal Hours 1" -and $_.Name -ne "Exceptionnal Hours 2" -and $_.Name -ne "Mall Opening hour" }

        foreach ($data in $csv) {

            $itemName = $data.item.Trim()
            if ($itemName -ne "Exceptionnal Hours 1" -and $itemName -ne "Exceptionnal Hours 2" -and $itemName -ne "Mall Opening hour") {
                $rkItem = Get-Item -Path "$path/$itemName" -Language $version
                $value = $data.value.Replace("[","{")
                $rkItem.Editing.BeginEdit() | Out-Null
                $rkItem["Phrase"] = $value.Replace("]","}")
                Write-Host "$($site.Name)/$($region.Name)"
                $rkItem.Editing.EndEdit() | Out-Null
            }
        }
    }
		
    # Write-Host "Done for $($site.Name)/$($region.Name)"
}
