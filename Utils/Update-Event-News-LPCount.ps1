function Update-Event-News-LPCount {

    begin {
        Write-Host "Update-Event-News-LPCount - Begin"
    }
    process {
        
        $regions = Get-ChildItem -Path "/sitecore/content/Klepierre/" | Where { $_.TemplateID -eq "{CE91FBD6-4D89-42C9-B5BC-2A670439E1FF}" -and !($_.Name -match "^Master") }
        foreach ($region in $regions) {
            $RegionName = $region.Name
            $malls = Get-ChildItem -Item $region | Where { $_.TemplateID -eq "{46591E02-8902-4C2C-AF61-3EB92BE2489A}" -and !($_.Name -match "^Alpha") }
            foreach ($mall in $malls) {
                $mallName = $mall.Name

                $settingPath = "$($mall.FullPath)/Settings/Site Grouping/$mallName"
                $settingItem = Get-Item -Path $settingPath
                $version = $settingItem["Language"]

                $NewsAndEventPath = "master:/sitecore/content/Klepierre/$RegionName/$mallName/Home/Events and News"

                Write-Host "update for $RegionName/$mallName Start" -ForegroundColor Yellow
                $item = Get-Item -Path $NewsAndEventPath -Language $version
                $item.Editing.BeginEdit() | Out-Null
                $item["Event First load"] = "2"
                $item["Event Load Page"] = "2"
                $item["News First Load"] = "6"
                $item["News Load Page"] = "6"
                $item.Editing.EndEdit() | Out-Null
                Write-Host "Done" -BackgroundColor Green
                

            }
        }
    }

    end {
        Write-Host "Update-Event-News-LPCount - end"
    }
}
Update-Event-News-LPCount