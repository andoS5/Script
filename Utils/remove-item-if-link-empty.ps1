function remove-item-if-link-empty {
    begin {
        Write-Host "Remove item if link is empty - Start"
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
                #contact page
                # $fbPath = "master:/sitecore/content/Klepierre/$RegionName/$mallName/Home/Navigation Container/Footer Repository/Social Media Repository/Facebook"
                # $instaPath = "master:/sitecore/content/Klepierre/$RegionName/$mallName/Home/Navigation Container/Footer Repository/Social Media Repository/Instagram"
                $fbPath = "master:/sitecore/content/Klepierre/$RegionName/$mallName/Home/Forms Repository/Contact Forms Page/Social Media Repository/Facebook"
                $instaPath = "master:/sitecore/content/Klepierre/$RegionName/$mallName/Home/Forms Repository/Contact Forms Page/Social Media Repository/Instagram"
                $facebook = if((Test-Path -Path $fbPath -ErrorAction SilentlyContinue)){Get-Item -Path $fbPath -Language $version} else {}
                $instagram = if((Test-Path -Path $instaPath -ErrorAction SilentlyContinue)){Get-Item -Path $instaPath -Language $version} else {}
                $defaultValue = "<link linktype=`"external`" url=`"`" anchor=`"`" target=`"_blank`" />"
                $facebookLink = if((Test-Path -Path $fbPath -ErrorAction SilentlyContinue)){$facebook["Social Media Link"]} else {}
                $instagramLink = if((Test-Path -Path $instaPath -ErrorAction SilentlyContinue)){$instagram["Social Media Link"]} else {}
                if ($facebookLink -eq $defaultValue) {
                    Write-Host "Contact us - Facebook empty link in $RegionName/$mallName" 
                    Write-Host $facebookLink

                    # Write-Host "Removing $path "
                    # Remove-Item -Path $path -Permanently
                    # Write-Host "done" -ForegroundColor Green
                }
                if ($instagramLink -eq $defaultValue) {
                    Write-Host "Contact us - Instagram empty link in $RegionName/$mallName" 
                    Write-Host $instagramLink

                    # Write-Host "Removing $path "
                    # Remove-Item -Path $path -Permanently
                    # Write-Host "done" -ForegroundColor Green
                }
            }
        }
    }

    end {
        Write-Host "All is Done " -ForegroundColor Green
    }
}
remove-item-if-link-empty