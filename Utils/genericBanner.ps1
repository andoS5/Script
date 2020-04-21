
$regions = Get-ChildItem -Path "/sitecore/content/Klepierre/" | Where { $_.TemplateID -eq "{CE91FBD6-4D89-42C9-B5BC-2A670439E1FF}" -and !($_.Name -match "^Master") }
foreach ($region in $regions) {
    $RegionName = $region.Name
    Write-Host " Update Starting for Region  $RegionName " -ForegroundColor Yellow
    # Write-Host "$RegionName Finding - Begin"
    $malls = Get-ChildItem -Item $region | Where { $_.TemplateID -eq "{46591E02-8902-4C2C-AF61-3EB92BE2489A}" -and !($_.Name -match "^Alpha") }
    foreach ($mall in $malls) {
        
        $mallName = $mall.Name
        Write-Host "Update for mall $mallName " -ForegroundColor Yellow
        $settingPath = "$($mall.FullPath)/Settings/Site Grouping/$mallName"
        $settingItem = Get-Item -Path $settingPath
        $version = $settingItem["Language"]

        #Home
        $homeRepo = "master:/sitecore/content/Klepierre/$RegionName/$mallName/Home"
        $itemHome = Get-Item -Path $homeRepo -Language $version

        $itemHome.Editing.BeginEdit() | Out-Null
        $itemHome["Page Title"] = "Page Title"
        $itemHome["Meta Description"] = "Meta Description"
        $itemHome.Editing.EndEdit() | Out-Null
        #Home

        #Deals
        $dealsLP = "master:/sitecore/content/Klepierre/$RegionName/$mallName/Home/Deals"

        $itemdealsLP = Get-Item -Path $dealsLP -Language $version

        $itemdealsLP.Editing.BeginEdit() | Out-Null
        $itemdealsLP["Page Title"] = "Page Title"
        $itemdealsLP["Meta Description"] = "Meta Description"
        $itemdealsLP.Editing.EndEdit() | Out-Null

        #Deals

        $newsAndEvent = "master:/sitecore/content/Klepierre/$RegionName/$mallName/Home/Events and News"
        $itemnewsAndEvent = Get-Item -Path $newsAndEvent -Language $version
        $itemnewsAndEvent.Editing.BeginEdit() | Out-Null
        $itemnewsAndEvent["Page Title"] = "Page Title"
        $itemnewsAndEvent["Meta Description"] = "Meta Description"
        $itemnewsAndEvent.Editing.EndEdit() | Out-Null

        $event = "master:/sitecore/content/Klepierre/$RegionName/$mallName/Home/Events and News/Events"
        $events = Get-ChildItem -Path  $event -Language $version | Where { $_.TemplateID -eq "{4058CE82-4516-4650-A69E-162D72F766D6}" -or $_.TemplateID -eq "{11C5961E-D173-485B-A328-D9A300302B86}" }

        foreach ($e in $events) {
            $e.Editing.BeginEdit() | Out-Null
            $e["Page Title"] = "Page Title"
            $e["Meta Description"] = "Meta Description"
            $e.Editing.EndEdit() | Out-Null
        }

        $new = "master:/sitecore/content/Klepierre/$RegionName/$mallName/Home/Events and News/News"
        $news = Get-ChildItem -Path  $new -Language $version | Where { $_.TemplateID -eq "{64476A1D-56A9-4525-95FB-569A19A69295}" -or $_.TemplateID -eq "{CD5164AE-FE0B-4A0B-BF3B-6DDEE8CFC3E9}" }

        foreach ($n in $news) {
            $n.Editing.BeginEdit() | Out-Null
            $n["Page Title"] = "Page Title"
            $n["Meta Description"] = "Meta Description"
            $n.Editing.EndEdit() | Out-Null
        }

        #job offers

        $jobOffers = "master:/sitecore/content/Klepierre/$RegionName/$mallName/Home/Job offers"

        $jItem = Get-Item -Path $jobOffers -Language $version

        $jItem.Editing.BeginEdit() | Out-Null
        $jItem["Page Title"] = "Page Title"
        $jItem["Meta Description"] = "Meta Description"
        $jItem.Editing.EndEdit() | Out-Null


        #services

        $servicesRepo = "master:/sitecore/content/Klepierre/$RegionName/$mallName/Home/Services"

        $SItem = Get-Item -Path $servicesRepo -Language $version

        $SItem.Editing.BeginEdit() | Out-Null
        $SItem["Page Title"] = "Page Title"
        $SItem["Meta Description"] = "Meta Description"
        $SItem.Editing.EndEdit() | Out-Null

        $childServices = Get-ChildItem -Path  $new -Language $version | Where { $_.TemplateID -eq "{80090502-71A4-42A5-8031-26A219977FBC}" -or $_.TemplateID -eq "{07D5A799-C4BA-4C82-ABEE-0E7E284D374D}" }
        foreach ($cs in $childServices) {
            $cs.Editing.BeginEdit() | Out-Null
            $cs["Page Title"] = "Page Title"
            $cs["Meta Description"] = "Meta Description"
            $cs.Editing.EndEdit() | Out-Null
        }

        #stores

        $storeRepo = "master:/sitecore/content/Klepierre/$RegionName/$mallName/Home/Shop Repository"

        $storeItem = Get-Item -Path $storeRepo -Language $version

        $storeItem.Editing.BeginEdit() | Out-Null
        $storeItem["Page Title"] = "Page Title"
        $storeItem["Meta Description"] = "Meta Description"
        $storeItem.Editing.EndEdit() | Out-Null

        $stores = Get-ChildItem -Path  $storeRepo -Language $version | Where { $_.TemplateID -eq "{80D19FA2-B1EF-4E32-93BD-4B2C650A126F}" -or $_.TemplateID -eq "{A496118C-D0EF-440D-8DF5-5DEFE47E662E}" }

        foreach ($st in $stores) {
            $st.Editing.BeginEdit() | Out-Null
            $st["Page Title"] = "Page Title"
            $st["Meta Description"] = "Meta Description"
            $st.Editing.EndEdit() | Out-Null
        }

        Write-Host "Update for  $mallName Done" -ForegroundColor Green
    }
    Write-Host "Update for  $RegionName Done" -ForegroundColor Green

}