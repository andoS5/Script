function Import-Content-Header {
    begin { 
        Write-Host "Import Practical Information - Begin"
        import-function Utils-Upload-CSV-File
    }
    process {
        Write-Host "Import Header Begin...."
        $data = Utils-Upload-CSV-File -Title "Import Header"
        $Region = $data[0]."Region Name"
        $Mall = $data[0]."Mall Name"
        $Mall = $Mall -Replace '[\W]', '-'
        $Language = $data[0]."Version"
        $pathMall = "master:/sitecore/content/Klepierre/$Region/$Mall"
        if(!(Test-Path -Path $pathMall -ErrorAction SilentlyContinue)){
            Write-Host "$Mall doesn't exist! Please create"
            Exit
        }
        $headerRepoPath = "master:/sitecore/content/Klepierre/$Region/$Mall/Home/Navigation Container/Header Repository"
        foreach ($d in $data) {
            $itemPath = $headerRepoPath + "/" + $d.Name
            if (!(Test-Path -Path $itemPath -ErrorAction SilentlyContinue)) {
                $tpl = "/sitecore/templates/Feature/Kortex/Navigation/Navigation"
                New-Item -Path $itemPath -ItemType $tpl -Language $Language | Out-Null
            }
            $link = ""
            if([string]::IsNullOrEmpty($d.Link)){
                if($itemPath -match "Information"){
                    $pathPracticalInfo = $pathMall + "/home/Practical Information"
                    $practicalInfoItem = Get-Item -Path $pathPracticalInfo -Language $Language
                    $id = $practicalInfoItem.ID 
                    $link = "<link id=`"$($id)`" querystring=`"`" text=`"`" anchor=`"`" title=`"`" class=`"`" linktype=`"internal`" />"
                }elseif($itemPath -match "Boutiques" -or $itemPath -match "Shop" -or $itemPath -match "Store"){
                    $pathShop = $pathMall + "/home/Shop Repository"
                    $shopItem = Get-Item -Path $pathShop -Language $Language
                    $id = $shopItem.ID 
                    $link = "<link id=`"$($id)`" querystring=`"`" text=`"`" anchor=`"`" title=`"`" class=`"`" linktype=`"internal`" />"
                }elseif($itemPath -match "service"){
                    $pathServices = $pathMall + "/home/Services"
                    $servicesItem = Get-Item -Path $pathServices -Language $Language
                    $id = $servicesItem.ID 
                    $link = "<link id=`"$($id)`" querystring=`"`" text=`"`" anchor=`"`" title=`"`" class=`"`" linktype=`"internal`" />"
                }
                elseif($itemPath -match "Bons" -or $itemPath -match 'deal'){
                    $pathDeals = $pathMall + "/home/Deals"
                    $dealsItem = Get-Item -Path $pathDeals -Language $Language
                    $id = $dealsItem.ID 
                    $link = "<link id=`"$($id)`" querystring=`"`" text=`"`" anchor=`"`" title=`"`" class=`"`" linktype=`"internal`" />"
                }
                elseif($itemPath -match "Eve"){
                    $pathEvents = $pathMall + "/home/Events and News/Events"
                    $eventItem = Get-Item -Path $pathEvents -Language $Language
                    $id = $eventItem.ID 
                    $link = "<link id=`"$($id)`" querystring=`"`" text=`"`" anchor=`"`" title=`"`" class=`"`" linktype=`"internal`" />"
                }else{
                    $pathNews = $pathMall + "/home/Events and News/News"
                    $newsItem = Get-Item -Path $pathNews -Language $Language
                    $id = $newsItem.ID 
                    $link = "<link id=`"$($id)`" querystring=`"`" text=`"`" anchor=`"`" title=`"`" class=`"`" linktype=`"internal`" />"
                }
            }
            $item = Get-Item -Path $itemPath -Language $Language
            try{
                $item.Editing.BeginEdit() | Out-Null
                    $item["Name"] = $d.Value
                    $item["Link"] = $link
                    $item["Is Active"] = $d."isActive"
                $item.Editing.EndEdit() | Out-Null
            }catch{
                Write-Host "failed...."
            }
        }
    }
    end {
        Write-Host "Import Header Done...."
    }
}
