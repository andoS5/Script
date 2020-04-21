function Update-Item-By-Field-For-All-Malls {
    param (
        [Parameter(Mandatory = $true, Position = 0 )]
        [string]$RegionName
    )

    begin {
        Write-Host "Update $FieldsName for $RegionName - Begin"
    }

    process {

        $region = Get-Item -Path "master:/sitecore/content/Klepierre/$RegionName"
        $malls = Get-ChildItem -Item $region | Where { $_.TemplateID -eq "{46591E02-8902-4C2C-AF61-3EB92BE2489A}" -and !($_.Name -match "^Alpha") -and !($_.Name -match "^Odysseum") }

        foreach ($mall in $malls) {
            $mallName = $mall.Name

            $settingPath = "$($mall.FullPath)/Settings/Site Grouping/$mallName"
            $settingItem = Get-Item -Path $settingPath
            $version = $settingItem["Language"]
Write-Host "version" $version
            $item = Get-Item -Path "master:/sitecore/content/Klepierre/$RegionName/$mallName/Resource Keys/Filtering/All" -Language $version
            # Write-Host $item.Name            
            Write-Host "Update $FieldsName for $RegionName -- $mallName"
            $item.Editing.BeginEdit()
            $item["Phrase"] = "Toutes"
            $item.Editing.EndEdit()
            Write-Host "Done" -ForegroundColor Green


        }
    }

    end {
        Write-Host "All is Done" -ForegroundColor Green
    }

}

Update-Item-By-Field-For-All-Malls "France"