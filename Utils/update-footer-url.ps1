function update-footer-url{
    begin{
        Write-Host "Update Footer URLs for All Malls - Begin"
        Import-Function Utils-Upload-CSV-File
    }
    process{
        

        $Datas = Utils-Upload-CSV-File -Title "Update Footer URLs"

        foreach ($data in $Datas) {
            $Region = $data.Region
            $Mall = $data.Mall
            $AppleStoreUrl = if(![string]::IsNullOrEmpty($data.AppStore)){$data.AppStore}else{""}
            $PlayStoreUrl = if(![string]::IsNullOrEmpty($data.PlayStore)){$data.PlayStore}else{""}
            $FacebookUrl = if(![string]::IsNullOrEmpty($data.Facebook)){$data.Facebook}else{""}
            $InstagramUrl = if(![string]::IsNullOrEmpty($data.Instagram)){$data.Instagram}else{""}
            $settingPath = "master:/sitecore/content/Klepierre/$Region/$Mall/Settings/Site Grouping/$Mall"
            $settingItem = Get-Item -Path $settingPath
            $Language = $settingItem["Language"]

            Write-Host "Update App Store URL for $Region / $Mall - Starting"
            $AppleStore = "master:/sitecore/content/Klepierre/$Region/$Mall/Home/Navigation Container/Footer Repository/Mobile App Repository/AppleStore"
            $AppleStoreItem = Get-Item -Path $AppleStore -Language $Language
            $AppleStoreItem.Editing.BeginEdit() | Out-Null
            $AppleStoreItem["Mobile Media Link"] = "<link text=`"App Store`" linktype=`"external`" url=`"$AppleStoreUrl`" anchor=`"`" target=`"`" />"
            $AppleStoreItem.Editing.EndEdit() | Out-Null
            Write-Host "Update App Store URL for $Region / $Mall - Done" -BackgroundColor White -ForegroundColor Black

            Write-Host "Update Play Store URL for $Region / $Mall - Starting"
            $PlayStore = "master:/sitecore/content/Klepierre/$Region/$Mall/Home/Navigation Container/Footer Repository/Mobile App Repository/Playstore"
            $PlayStoreItem = Get-Item -Path $PlayStore -Language $Language
            $PlayStoreItem.Editing.BeginEdit() | Out-Null
            $PlayStoreItem["Mobile Media Link"] = "<link text=`"Google Play`" linktype=`"external`" url=`"$PlayStoreUrl`" anchor=`"`" target=`"`" />"
            $PlayStoreItem.Editing.EndEdit() | Out-Null
            Write-Host "Update Play Store URL for $Region / $Mall - Done" -BackgroundColor White -ForegroundColor Black

            Write-Host "Update Facebook URL for $Region / $Mall - Starting"
            $Facebook = "master:/sitecore/content/Klepierre/$Region/$Mall/Home/Navigation Container/Footer Repository/Social Media Repository/Facebook"
            $FacebookItem = Get-Item -Path $Facebook -Language $Language
            $FacebookItem.Editing.BeginEdit() | Out-Null
            $FacebookItem["Social Media Link"] = "<link text=`"Facebook`" linktype=`"external`" url=`"$FacebookUrl`" anchor=`"`" target=`"`" />"
            $FacebookItem.Editing.EndEdit() | Out-Null
            Write-Host "Update Facebook URL for $Region / $Mall - Done" -BackgroundColor White -ForegroundColor Black

            Write-Host "Update Instagram URL for $Region / $Mall - Starting"
            $Instagram = "master:/sitecore/content/Klepierre/$Region/$Mall/Home/Navigation Container/Footer Repository/Social Media Repository/Instagram"
            $InstagramItem = Get-Item -Path $Instagram -Language $Language
            $InstagramItem.Editing.BeginEdit() | Out-Null
            $InstagramItem["Social Media Link"] = "<link text=`"Instagram`" linktype=`"external`" url=`"$InstagramUrl`" anchor=`"`" target=`"`" />"
            $InstagramItem.Editing.EndEdit() | Out-Null
            Write-Host "Update Instagram URL for $Region / $Mall - Done" -BackgroundColor White -ForegroundColor Black
        }
    }
    end{
        Write-Host "Update Footer URLs for All Malls - Done" -ForegroundColor Green
    }

}

update-footer-url