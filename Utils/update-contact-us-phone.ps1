function update-contact-us-phone {
    begin {
        Write-Host "update - start" -ForegroundColor Yellow
        Import-Function Utils-Remove-Diacritics
        Import-Function Utils-Upload-CSV-File
    }

    process {
        $datas = Utils-Upload-CSV-File -Title "Import Datas"
        foreach ($data in $datas) {
            $RegionName	= $data["Region"]
            $mallName = $data["Mall"]
            $phoneNumber = $data["Contact"]
        
            $path = "master:/sitecore/content/Klepierre/$RegionName/$mallName/Home/Forms Repository/Contact Forms Page"

            $settingPath = "master:/sitecore/content/Klepierre/$RegionName/$mallName/Settings/Site Grouping/$mallName"
            $settingItem = Get-Item -Path $settingPath
            $Language = $settingItem["Language"]

            $item = Get-Item -Path $path -Language $Language
            $phoneValue = if($item["Call And Social Phone Number"] -eq "+33 1 60 42 39 39"){$phoneNumber}else{$item["Call And Social Phone Number"]}
            
            Write-Host "Starting to change Phone Number $($item["Call And Social Phone Number"]) to $phoneValue" -ForegroundColor Yellow
            $item.Editing.BeginEdit() | Out-Null
            $item["Call And Social Phone Number"] = $phoneValue
            $item.Editing.EndEdit() | Out-Null
            Write-Host "Done" -ForegroundColor Yellow
        }
    }
    end {
        Write-Host "Done" -ForegroundColor Green
    }
}

update-contact-us-phone