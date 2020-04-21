function remove-show-on-mobile-in-forms {
    begin {
        Write-Host "Uncheck show on mobile - Begin"
    }

    process {

        $regions = Get-ChildItem -Path "/sitecore/content/Klepierre/" | Where { $_.TemplateID -eq "{CE91FBD6-4D89-42C9-B5BC-2A670439E1FF}" -and !($_.Name -match "^Master") }
        foreach ($region in $regions) {
            $RegionName = $region.Name
            Write-Host "$RegionName Finding - Begin"
            $malls = Get-ChildItem -Item $region | Where { $_.TemplateID -eq "{46591E02-8902-4C2C-AF61-3EB92BE2489A}" -and !($_.Name -match "^Alpha") }
            foreach ($mall in $malls) {
                $mallName = $mall.Name

                $settingPath = "$($mall.FullPath)/Settings/Site Grouping/$mallName"
                $settingItem = Get-Item -Path $settingPath
                $version = $settingItem["Language"]
                # if ($RegionName -eq "Belgium") {
                    # $contactFormsPath = "master:/sitecore/content/Klepierre/$RegionName/$mallName/Home/Forms Repository/Contact Forms Page"
                    $contactFormsPath = "master:/sitecore/content/Klepierre/$RegionName/$mallName/Home/Services"
                    # $permanent = "master:/sitecore/content/Klepierre/$RegionName/$mallName/Home/Forms Repository/Rent Permanent Space Page"
                    $permanent = "master:/sitecore/content/Klepierre/$RegionName/$mallName/Home/Shop Repository"
                    # $temporary = "master:/sitecore/content/Klepierre/$RegionName/$mallName/Home/Forms Repository/Rent Temporary Space Page"

                    $contactItem = Get-Item -path $contactFormsPath -Language $version
                    $permanentItem = Get-Item -path $permanent -Language $version
                    # $temporaryItem = Get-Item -path $temporary -Language $version

                    Write-Host "Starting to uncheck for $RegionName/$mallName/Home/Services"
                    $contactItem.Editing.BeginEdit() | Out-Null
                    $contactItem["Show on Mobile"] = 1
                    $contactItem.Editing.EndEdit() | Out-Null
                    Write-Host "Done" -ForegroundColor Yellow
                    Write-Host "Starting to uncheck for $RegionName/$mallName/Home/Shop Repository"
                    $permanentItem.Editing.BeginEdit() | Out-Null
                    $permanentItem["Show on Mobile"] = 1
                    $permanentItem.Editing.EndEdit() | Out-Null
                    Write-Host "Done" -ForegroundColor Yellow
                    # Write-Host "Starting to uncheck for $RegionName/$mallName/Home/Forms Repository/Rent Permanent Space Page"
                    # $temporaryItem.Editing.BeginEdit() | Out-Null
                    # $temporaryItem["Show on Mobile"] = 0
                    # $temporaryItem.Editing.EndEdit() | Out-Null
                    # Write-Host "Done" -ForegroundColor Yellow
                # }
                

            }
        }

    }

    end {
        Write-Host "Done" -ForegroundColor Green
    }
}

remove-show-on-mobile-in-forms