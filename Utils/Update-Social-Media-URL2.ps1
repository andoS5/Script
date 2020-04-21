function updateSocialMedia2 {
    begin {
        Write-Host "Updating social media - start"
        Import-Function Utils-Remove-Diacritics
        Import-Function Utils-Upload-CSV-File
    }

    process {
        $datas = Utils-Upload-CSV-File -Title "Import Datas"
        foreach ($data in $datas) {
            $region	= $data["region"]
            $mallName = $data["mallName"]
            if ($mallName -ne "Odysseum") {
                $itemName = if (![string]::IsNullOrEmpty($data["itemName"])) { Utils-Remove-Diacritics $data["itemName"] }else { }
                $facebook = if (![string]::IsNullOrEmpty($data["facebook"])) { $data["Facebook"] }else { "" }
                $instagram = if (![string]::IsNullOrEmpty($data["instagram"])) { $data["Instagram"] }else { "" }
                $siteUrl = if (![string]::IsNullOrEmpty($data["siteUrl"])) { $data["siteUrl"] }else { "" }
                $twitter = if (![string]::IsNullOrEmpty($data["twitter"])) { $data["twitter"] }else { "" }

                Write-Host "Getting Version for $region - $mallName"
                $settingPath = "master:/sitecore/content/Klepierre/$region/$mallName/Settings/Site Grouping/$mallName"
                $settingItem = Get-Item -Path $settingPath
                $version = $settingItem["Language"]
                Write-Host "Version = $version - Done" -ForegroundColor Yellow



                $Path = "master:/sitecore/content/Klepierre/$region/$mallName/Home/Shop Repository/$itemName"
                $FormsFB = "master:/sitecore/content/Klepierre/$region/$mallName/Home/Forms Repository/Contact Forms Page/Social Media Repository/Facebook"
                $FormsInsta = "master:/sitecore/content/Klepierre/$region/$mallName/Home/Forms Repository/Contact Forms Page/Social Media Repository/Instagram"
                
                $item = Get-Item -Path $Path -Language $version

                $item.Editing.BeginEdit() | Out-Null
                Write-Host "Setting Twitter to $twitter" -ForegroundColor Yellow
                $item["Twitter Url"] = "<link linktype=`"external`" url=`"$twitter`" anchor=`"`" target=`"_blank`" />"



                Write-Host "Setting Facebook to $facebook" -ForegroundColor Yellow
                $item["Facebook Url"] = "<link linktype=`"external`" url=`"$facebook`" anchor=`"`" target=`"_blank`" />"
                Write-Host "Setting Instagram to $instagram" -ForegroundColor Yellow
                $item["Instagram Url"] = "<link linktype=`"external`" url=`"$instagram`" anchor=`"`" target=`"_blank`" />"
                Write-Host "Setting Store Website to $siteUrl" -ForegroundColor Yellow
                $item["Store Website Url"] = "<link linktype=`"external`" url=`"$siteUrl`" anchor=`"`" target=`"_blank`" />"
                Write-Host "Done" -ForegroundColor Green
                $item.Editing.EndEdit() | Out-Null

                $FormItemFB = Get-Item -Path $FormsFB -Language $version
                $FormItemInsta = Get-Item -Path $FormsInsta -Language $version

                # Write-Host "Update Links in forms"

                Write-Host "Facebook to $facebook" -ForegroundColor Yellow
                $FormItemFB.Editing.BeginEdit() | Out-Null
                $FormItemFB["Social Media Link"] = "<link linktype=`"external`" url=`"$facebook`" anchor=`"`" target=`"_blank`" />"
                $FormItemFB.Editing.EndEdit() | Out-Null
                Write-Host "Instagram to $instagram" -ForegroundColor Yellow
                $FormItemInsta.Editing.BeginEdit() | Out-Null
                $FormItemInsta["Social Media Link"] = "<link linktype=`"external`" url=`"$instagram`" anchor=`"`" target=`"_blank`" />"
                $FormItemInsta.Editing.EndEdit() | Out-Null
                Write-Host "Updating in Forms - Done" -ForegroundColor Green
            }
            
        }
    }

    end {
        Write-Host "All is Done" -ForegroundColor Green
    }
}

updateSocialMedia2