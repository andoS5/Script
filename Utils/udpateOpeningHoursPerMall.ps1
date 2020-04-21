$regions = Get-ChildItem -Path "/sitecore/content/Klepierre/" | Where { $_.TemplateID -eq "{CE91FBD6-4D89-42C9-B5BC-2A670439E1FF}" -and !($_.Name -match "^Master") }
foreach ($region in $regions) {
    $RegionName = $region.Name
    # Write-Host " Update Starting for Region  $RegionName " -ForegroundColor Yellow
    # Write-Host "$RegionName Finding - Begin"
    $malls = Get-ChildItem -Item $region | Where { $_.TemplateID -eq "{46591E02-8902-4C2C-AF61-3EB92BE2489A}" -and !($_.Name -match "^Alpha") }
    foreach ($mall in $malls) {
        
        $mallName = $mall.Name
        Write-Host "Update for mall $mallName " -ForegroundColor Yellow
        $settingPath = "$($mall.FullPath)/Settings/Site Grouping/$mallName"
        $settingItem = Get-Item -Path $settingPath
        $version = $settingItem["Language"]
        $country = "Norway"
        if($RegionName -eq $country){

            $hoursRepository = "master:/sitecore/content/Klepierre/$country/$mallName/Home/Practical Information/Opening Hours Repository"
            $days = Get-ChildItem -Path $hoursRepository -Language $version | Where { $_.TemplateID -eq "{6C32F517-77B1-4E0C-B8CE-D1FE77E25563}" }

            foreach($day in $days){ 
                Write-Host "Update for $mallName $($day.Name)" -ForegroundColor Yellow
                $day.Editing.BeginEdit() | Out-Null
                $day["Close"] = 1
                $day.Editing.EndEdit() | Out-Null
            }
        }
        Write-Host "All is Done"
    }
}