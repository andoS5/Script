function Update-Mapwize {
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
        Write-Host "Update  Mapwize - Begin"
        Import-Function Utils-Upload-CSV-File
        Import-Function Utils-Remove-Diacritics
    }
  
    process {
  
        $csvShop = Utils-Upload-CSV-File -Title "Stores FullKit"
        $csv = Utils-Upload-CSV-File -Title "Mapwize FullKit"

        $total = $csvShop.Count
        $count = 1
        foreach ($record in $csvShop | Where-Object { $_."Friendly URL" -ne "" }) {
         
            $itemName = Utils-Remove-Diacritics $record."Friendly URL"
            $itemPath = "master:/content/Klepierre/$RegionName/$MallName/Home/Shop Repository/$itemName"
            Write-Host "[$($count)/$($total)] - Processing $($itemPath)"
            $count++
            if (Test-Path -Path $itemPath -ErrorAction SilentlyContinue) {
                if ($record.MAPWIZE -ne "") {
                    # $recordMap = "*" + $record.Mapwize + "*"
                    foreach ($map in $csv) { 
                        If ($map.Data -ne '{"type":"shop"}') {  
                            $mapTitle = if($map["title.en"].Trim() -ne""){Utils-Remove-Diacritics $map["title.en"].Trim()}
                                    
                            if ($itemName -eq $mapTitle) {
                                $item = Get-Item -Path $itemPath -Language $Language 
                                $item.Editing.BeginEdit() | Out-Null
                                $item["placeId"] = $map.id
                                $item["placeAlias"] = $map.alias
                        
                                write-host $itemPath 
                                $item.Editing.EndEdit() | Out-Null
                            }
                        }
                    }
                  
                }
            }
        }
  
    }


}

Update-Mapwize "France" "fr-Fr" "Blagnac"