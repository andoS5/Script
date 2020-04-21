function updateForms2 {
    # Validations

    $regions = Get-ChildItem -Path "/sitecore/content/Klepierre/" | Where { $_.TemplateID -eq "{CE91FBD6-4D89-42C9-B5BC-2A670439E1FF}" -and !($_.Name -match "^Master") }
    foreach ($region in $regions) {
        $RegionName = $region.Name
        Write-Host "$RegionName Update - Begin"
        $malls = Get-ChildItem -Item $region | Where { $_.TemplateID -eq "{46591E02-8902-4C2C-AF61-3EB92BE2489A}" -and !($_.Name -match "^Alpha") -and !($_.Name -match "^Odysseum") }
        foreach ($mall in $malls) {
            $mallName = $mall.Name

            $settingPath = "$($mall.FullPath)/Settings/Site Grouping/$mallName"
            $settingItem = Get-Item -Path $settingPath
            $version = $settingItem["Language"]

            $city = Get-Item -Path "master:/sitecore/Forms/$RegionName/$mallName/Contact Page/Page/City" -Language $version
            $postCode = Get-Item -Path "master:/sitecore/Forms/$RegionName/$mallName/Contact Page/Page/Post Code" -Language $version
            $phone = Get-Item -Path "master:/sitecore/Forms/$RegionName/$mallName/Contact Page/Page/Phone" -Language $version
            
            Write-Host "Removing Validators for $RegionName/$mallName/Contact Page/Page/City" -ForegroundColor Yellow
            $city.Editing.BeginEdit() | Out-Null
            $city["Validations"] = ""
            $city.Editing.EndEdit() | Out-Null

            Write-Host "Removing Validators for $RegionName/$mallName/Contact Page/Page/Post Code" -ForegroundColor Yellow
            $postCode.Editing.BeginEdit() | Out-Null
            $postCode["Validations"] = ""
            $postCode.Editing.EndEdit() | Out-Null

            Write-Host "Removing Validators for $RegionName/$mallName/Contact Page/Page/Phone" -ForegroundColor Yellow
            $phone.Editing.BeginEdit() | Out-Null
            $phone["Validations"] = ""
            $phone.Editing.EndEdit() | Out-Null

            Write-Host "Removed " -ForegroundColor Green

        }
    }
}
updateForms2