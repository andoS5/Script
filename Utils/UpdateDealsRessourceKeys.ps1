function update-Ressource-rk {
    param (
        [Parameter(Mandatory = $true, Position = 0 )]
        [string]$RegionName,

        [Parameter(Mandatory = $true, Position = 1 )]
        [string]$MallName,
        
        [Parameter(Mandatory = $true, Position = 2 )]
        [string]$Language,

        [Parameter(Mandatory = $true, Position = 3 )]
        [string]$RessourceKey
    )

    begin {
        Write-Host "Update $RessourceKey Ressource Keys for $RegionName - Begin"
    }

    process {
        $region = Get-Item -Path "master:/sitecore/content/Klepierre/$RegionName"
        $name = $region.Name 
        $malls = $region.Children | Where { $_.TemplateID -eq "{46591E02-8902-4C2C-AF61-3EB92BE2489A}" -and $name -eq "$RegionName" -and !($_.Name -match "$MallName")}
        $Sources = Get-ChildItem -Path "master:/sitecore/content/Klepierre/$RegionName/$MallName/Resource Keys/$RessourceKey" -Language $Language

        foreach($mall in $malls){
            $siteName = $mall.Name
            foreach($Source in $Sources){
                $Sourceitem = Get-Item -Path "master:/sitecore/content/Klepierre/$RegionName/$MallName/Resource Keys/$RessourceKey/$($Source.Name)" -Language $Language
                $sourcePhrase = $Sourceitem["Phrase"]
                if(![string]::IsNullOrEmpty($sourcePhrase)){
                    $destinationItem = Get-Item -Path "master:/sitecore/content/Klepierre/$RegionName/$siteName/Resource Keys/$RessourceKey/$($Source.Name)" -Language $Language
                    if($destinationItem){
                        Write-Host "Updating $RegionName/$siteName/Resource Keys/$RessourceKey/$($Source.Name) - Begin" -ForegroundColor Yellow
                        $destinationItem.Editing.BeginEdit() | Out-Null
                        $destinationItem["Phrase"] = $sourcePhrase
                        $destinationItem.Editing.EndEdit() | Out-Null
                        Write-Host "Done" -ForegroundColor Black -BackgroundColor White
                    }
                }
            }
        }

    }

    end {
        Write-Host "Update $RessourceKey Done" -ForegroundColor Green
    }
}

update-Ressource-rk "France" "odysseum" "fr-Fr" "Search"