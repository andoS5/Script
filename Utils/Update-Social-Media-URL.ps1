function Update-Social-Media-URL {
    begin {
        Write-Host "Update Social Media URL - Begin"
    }

    process {

        
        $regions = Get-ChildItem -Path "/sitecore/content/Klepierre/" | Where { $_.TemplateID -eq "{CE91FBD6-4D89-42C9-B5BC-2A670439E1FF}" -and !($_.Name -match "^Master") }
        foreach ($region in $regions) {
            $RegionName = $region.Name
            Write-Host "$RegionName Update - Begin"
            $malls = Get-ChildItem -Item $region | Where { $_.TemplateID -eq "{46591E02-8902-4C2C-AF61-3EB92BE2489A}" -and !($_.Name -match "^Alpha")}
            foreach ($mall in $malls) {
                $mallName = $mall.Name

                $settingPath = "$($mall.FullPath)/Settings/Site Grouping/$mallName"
                $settingItem = Get-Item -Path $settingPath
                $version = $settingItem["Language"]

                # Facebook et Instagram footer
                $FacebookPath = "master:/sitecore/content/Klepierre/$regionName/$mallName/Home/Navigation Container/Footer Repository/Social Media Repository/Facebook"
                $InstagramPath = "master:/sitecore/content/Klepierre/$regionName/$mallName/Home/Navigation Container/Footer Repository/Social Media Repository/Instagram"
                Write-Host "Footer URL Update - Start"
                $FacebookItem = Get-Item -Path $FacebookPath -Language $version
                $fbLink = $FacebookItem["Social Media Link"]
                $UpdatedFbUrl = $fbLink -replace ("target=`"(.*?)`"", "target=`"_blank`"")

                $FacebookItem.Editing.BeginEdit() | Out-Null
                $FacebookItem["Social Media Link"] = $UpdatedFbUrl
                $FacebookItem.Editing.EndEdit() | Out-Null


                $InstagramItem = Get-Item -Path $InstagramPath -Language $version
                $instaLink = $InstagramItem["Social Media Link"]
                $UpdatedInstaUrl = $instaLink -replace ("target=`"(.*?)`"", "target=`"_blank`"")

                $InstagramItem.Editing.BeginEdit() | Out-Null
                $InstagramItem["Social Media Link"] = $UpdatedInstaUrl
                $InstagramItem.Editing.EndEdit() | Out-Null
                Write-Host "Footer URL Update - Done" -ForegroundColor Green

                #Shop External links
                $shopRepo = "master:/sitecore/content/Klepierre/$regionName/$mallName/Home/Shop Repository"
                $shops = Get-ChildItem -Path $shopRepo | Where { $_.TemplateID -eq "{80D19FA2-B1EF-4E32-93BD-4B2C650A126F}" -or $_.TemplateID -eq "{A496118C-D0EF-440D-8DF5-5DEFE47E662E}"}

                foreach ($shop in $shops) {
                    $shopName = $shop.Name
                    $siteItem = Get-Item -Path "master:/sitecore/content/Klepierre/$regionName/$mallName/Home/Shop Repository/$shopName" -Language $version
       
                    $facebookURL = if (![string]::IsNullOrEmpty($siteItem["Facebook Url"])) { $siteItem["Facebook Url"] }else { }
                    $TwitterURL = if (![string]::IsNullOrEmpty($siteItem["Twitter Url"])) { $siteItem["Twitter Url"] }else { }
                    $InstagramURL = if (![string]::IsNullOrEmpty($siteItem["Instagram Url"])) { $siteItem["Instagram Url"] }else { }
                    $storeWebSiteURL = if (![string]::IsNullOrEmpty($siteItem["Store Website Url"])) { $siteItem["Store Website Url"] }else { }

                    $newFbURL = $facebookURL -replace ("target=`"(.*?)`"", "target=`"_blank`"")
                    $newTwitURL = $TwitterURL -replace ("target=`"(.*?)`"", "target=`"_blank`"")
                    $newInstaURL = $InstagramURL -replace ("target=`"(.*?)`"", "target=`"_blank`"")
                    $newWSURL = $storeWebSiteURL -replace ("target=`"(.*?)`"", "target=`"_blank`"")
                    Write-Host "update URL for $regionName -- $mall -- $shopName"
                    $siteItem.Editing.BeginEdit() | Out-Null
                    $siteItem["Facebook Url"] = $newFbURL
                    $siteItem["Twitter Url"] = $newTwitURL
                    $siteItem["Instagram Url"] = $newInstaURL
                    $siteItem["Store Website Url"] = $newWSURL
                    $siteItem.Editing.EndEdit() | Out-Null
                    Write-Host "Done" -ForegroundColor Green

                }
            }
        }
    }

    end {
        Write-Host "Update URL - Done" -ForegroundColor Green
    }
}
Update-Social-Media-URL