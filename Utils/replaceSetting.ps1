$regions = Get-ChildItem -Path "/sitecore/content/Klepierre/" | Where { $_.TemplateID -eq "{CE91FBD6-4D89-42C9-B5BC-2A670439E1FF}" -and !($_.Name -match "^Master") }
foreach ($region in $regions) {
    $RegionName = $region.Name
    Write-Host "$RegionName Update - Begin"
    $malls = Get-ChildItem -Item $region | Where { $_.TemplateID -eq "{46591E02-8902-4C2C-AF61-3EB92BE2489A}" }
    foreach ($mall in $malls) {
        $mallName = $mall.Name

        $settingPath = "$($mall.FullPath)/Settings/Site Grouping/$mallName"
        $settingItem = Get-Item -Path $settingPath
        $version = $settingItem["Language"]

        $settingsRepo = "master:/sitecore/content/Klepierre/$RegionName/$mallName/Settings"

        $item = Get-Item -Path $settingsRepo -Language $version

        $content = $item["RobotsContent"]

        if($content.Contains("Allow")){
            Write-Host "$RegionName / $mallName ==> $content" -ForegroundColor Yellow

            $content = $content.Replace("Allow","Disallow")
            
            $item.Editing.BeginEdit() |Out-Null
            $item["RobotsContent"] = $content
            Write-Host "$RegionName / $mallName ==> $content" -ForegroundColor Green
            $item.Editing.EndEdit() |Out-Null

        }

        

    }
}