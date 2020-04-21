function Import-Content-Footer {
    begin { 
        Write-Host "Import Footer - Begin"
        import-function Utils-Upload-CSV-File
    }
    process {
        $data = Utils-Upload-CSV-File -Title "Import Footer"
        $Region = $data[0]."Region Name"
        $Mall = $data[0]."Mall Name"
        $Mall = $Mall -Replace '[\W]', '-'
        $Language = $data[0]."Version"
        $pathMall = "master:/sitecore/content/Klepierre/$Region/$Mall"
        $path = $pathMall + "/Home/Navigation Container/"
        foreach($d in $data ){
            $pathNavigations = $path + $d.Name
            $splitPath = $d.Name.Split("/", [System.StringSplitOptions]::RemoveEmptyEntries)
            if($splitPath.Count -eq 2){
                $navigationItem = Get-Item -Path $pathNavigations -Language $Language -ErrorAction SilentlyContinue
                if($navigationItem -and $navigationItem.TemplateId -eq "{C3F7D93A-9204-428E-8795-A7A4279D03E8}"){ #Mobile App Repository
                    $navMobItem = Get-Item -Path $pathNavigations -Language $Language -ErrorAction SilentlyContinue
                    $navMobItem.Editing.BeginEdit() | Out-Null
                    $navMobItem["Title"] = $d.Value1.Trim()
                    $navMobItem["Description"] = $d.Value2.Trim()
                    $navMobItem.Editing.EndEdit() | Out-Null
                    #Write-Host "#Done for $($d.Name)"
                }elseif($navigationItem -and $navigationItem.TemplateId -eq "{A0600276-7824-418C-A22D-8D97B126CC46}"){ #Newsletter Subscription
                    $navNewsLetItem = Get-Item -Path $pathNavigations -Language $Language -ErrorAction SilentlyContinue
                    $navNewsLetItem.Editing.BeginEdit() | Out-Null
                    $navNewsLetItem["Title"] = $d.Value1.Trim()
                    $navNewsLetItem["Short description"] = $d.Value2.Trim()
                    $navNewsLetItem["User email"] = $d.Value3.Trim()
                    $navNewsLetItem.Editing.EndEdit() | Out-Null
                    #Write-Host "#Done for $($d.Name)"
                }elseif($navigationItem -and $navigationItem.TemplateId -eq "{7EAD16C1-C51B-45EE-BDD4-82BF9ABB4BB9}"){ ##contact LegallPages and #Mall
                    $item = Get-Item -Path $pathNavigations -Language $Language -ErrorAction SilentlyContinue
                    $item.Editing.BeginEdit() | Out-Null
                    $item["Name"] = $d.Value1.Trim()
                    $item["Link"] = "<link linktype=`"external`" url=`"$($d.Link)`" />"
                    $item["Is Active"] = $d.IsActive.Trim()
                    $item.Editing.EndEdit() | Out-Null
                    #Write-Host "#Done for $($d.Name)"
                }
            }elseif(!($d.Name -match "Resource Keys") -and $splitPath.Count -eq 3){
                #Write-Host "SubNav => "$d.Name
                if($d.Name -match "Mobile App"){
                    if(!(Test-Path -Path $pathNavigations -ErrorAction SilentlyContinue)){
                        New-Item -Path $pathNavigations -ItemType "{9140FAD5-16F2-4657-858A-3A1D12AFEA67}" -Language $Language | Out-Null
                    }
                    $subNavMobileItem = Get-Item -Path $pathNavigations -Language $Language -ErrorAction SilentlyContinue
                    ##Update
                    $imageMobilIcon = if($pathNavigations -match "Apple"){"<image mediaid=`"{786AB27F-25DB-4272-9BFB-0F566EDD3A0E}`" alt=`" `" />"}else {"<image mediaid=`"{69760277-6FBB-44CB-8B2A-191BEF41F9AE}`" alt=`" `" />"}
                    $subNavMobileItem.Editing.BeginEdit() | Out-Null
                    $subNavMobileItem["Mobile Media Link"] = "<link linktype=`"external`" url=`"$($d.Link)`" />"
                    $subNavMobileItem["Mobile App Icon"] = $imageMobilIcon
                    $subNavMobileItem.Editing.EndEdit() | Out-Null
                    #Write-Host "#Done for $($d.Name)"
                    
                }elseif($d.Name -match "Social Media Repository"){
                    if(!(Test-Path -Path $pathNavigations -ErrorAction SilentlyContinue)){
                        New-Item -Path $pathNavigations -ItemType "{2ED7C87B-C8A2-4531-88CC-4BC0706DD57A}" -Language $Language | Out-Null
                    }
                    $subNavSocialMediaItem = Get-Item -Path $pathNavigations -Language $Language -ErrorAction SilentlyContinue
                    $mediaPath = if($pathNavigations -match "Facebook") { "facebook-icon"} else {"instagram-logo"}
                    $mediaItem = Get-Item -Path "master:/sitecore/media library/Project/Klepierre/shared/$($mediaPath)"
                    $imageMediaSocialIcon = "<image mediaid=`"$($mediaItem.ID)`" alt=`" `" />"
                    ##Update
                    $subNavSocialMediaItem.Editing.BeginEdit() | Out-Null
                    $subNavSocialMediaItem["Social Media Link"] = "<link linktype=`"external`" url=`"$($($d.Link))`" />"
                    $subNavSocialMediaItem["Social Media Icon"] = $imageMediaSocialIcon
                    $subNavSocialMediaItem.Editing.EndEdit() | Out-Null
                    #Write-Host "#Done for $($d.Name)"
                }else{
                    if(!(Test-Path -Path $pathNavigations -ErrorAction SilentlyContinue)){
                        New-Item -Path $pathNavigations -ItemType "{7DB385F8-8202-4D41-8790-7ED49125AFCA}" -Language $Language | Out-Null
                    }

                    $link = "<link linktype=`"external`" url=`"$($d.Link)`" />"
                    if($pathNavigations -match "Information"){
                        $pathPracticalInfo = $pathMall + "/home/Practical Information"
                        $practicalInfoItem = Get-Item -Path $pathPracticalInfo -Language $Language
                        $id = $practicalInfoItem.ID 
                        $link = "<link id=`"$($id)`" querystring=`"`" text=`"`" anchor=`"`" title=`"`" class=`"`" linktype=`"internal`" />"
                    }elseif($pathNavigations -match "Boutiques" -or $pathNavigations -match "Shop" -or $pathNavigations -match "Store"){
                        $pathShop = $pathMall + "/home/Shop Repository"
                        $shopItem = Get-Item -Path $pathShop -Language $Language
                        $id = $shopItem.ID 
                        $link = "<link id=`"$($id)`" querystring=`"`" text=`"`" anchor=`"`" title=`"`" class=`"`" linktype=`"internal`" />"
                    }elseif($pathNavigations -match "services"){
                        $pathServices = $pathMall + "/home/Services"
                        $servicesItem = Get-Item -Path $pathServices -Language $Language
                        $id = $servicesItem.ID 
                        $link = "<link id=`"$($id)`" querystring=`"`" text=`"`" anchor=`"`" title=`"`" class=`"`" linktype=`"internal`" />"
                    }
                    elseif($pathNavigations -match "Bons" -or $pathNavigations -match 'deal'){
                        $pathDeals = $pathMall + "/home/Deals"
                        $dealsItem = Get-Item -Path $pathDeals -Language $Language
                        $id = $dealsItem.ID 
                        $link = "<link id=`"$($id)`" querystring=`"`" text=`"`" anchor=`"`" title=`"`" class=`"`" linktype=`"internal`" />"
                    }
                    elseif($pathNavigations -match "Actu"){
                        $pathNews = $pathMall + "/home/Events and News/News"
                        $newsItem = Get-Item -Path $pathNews -Language $Language
                        $id = $newsItem.ID 
                        $link = "<link id=`"$($id)`" querystring=`"`" text=`"`" anchor=`"`" title=`"`" class=`"`" linktype=`"internal`" />"
                    }elseif($pathNavigations -match "Eve"){
                        $pathEvents = $pathMall + "/home/Events and News/Events"
                        $eventItem = Get-Item -Path $pathEvents -Language $Language
                        $id = $eventItem.ID 
                        $link = "<link id=`"$($id)`" querystring=`"`" text=`"`" anchor=`"`" title=`"`" class=`"`" linktype=`"internal`" />"
                    }
                    $subNavItem = Get-Item -Path $pathNavigations -Language $Language -ErrorAction SilentlyContinue
                    ##Update
                    $subNavItem.Editing.BeginEdit() | Out-Null
                    $subNavItem["Name"] = $d.Value1
                    $subNavItem["Link"] = $link
                    $subNavItem["Is Active"] = $d.IsActive
                    $subNavItem.Editing.EndEdit() | Out-Null
                    #Write-Host "#Done for $($d.Name)"
                }
            }else{
                $pathRessKeyNav = "/sitecore/content/Klepierre/$($Region)/$($Mall)" + $d.Name
                $resKeyItem = Get-Item -Path $pathRessKeyNav -Language $Language -ErrorAction SilentlyContinue
                $resKeyItem.Editing.BeginEdit() | Out-Null
                $resKeyItem["Phrase"] = $d.Value1
                $resKeyItem.Editing.EndEdit() | Out-Null
                #Write-Host "#Done for $($d.Name)"
            }
        }
    }end{
        Write-Host "Import Footer - Completed"
    }
}
