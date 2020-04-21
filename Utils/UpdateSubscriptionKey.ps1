function UpdateSubscriptionKey {
    begin {
        Write-Host "Update Subscription key - Begin"
    }

    process {

        
        $regions = Get-ChildItem -Path "/sitecore/content/Klepierre/" | Where { $_.TemplateID -eq "{CE91FBD6-4D89-42C9-B5BC-2A670439E1FF}" -and !($_.Name -match "^Master") }
        foreach ($region in $regions) {
            $RegionName = $region.Name
            Write-Host "$RegionName Update - Begin"
            $malls = Get-ChildItem -Item $region | Where { $_.TemplateID -eq "{46591E02-8902-4C2C-AF61-3EB92BE2489A}" -and !($_.Name -match "^Alpha") }
            foreach ($mall in $malls) {
                $mallName = $mall.Name

                $settingPath = "$($mall.FullPath)/Settings/Site Grouping/$mallName"
                $settingItem = Get-Item -Path $settingPath
                $version = $settingItem["Language"]

                
                $sk = "master:/sitecore/content/Klepierre/$RegionName/$mallName/Settings/Mall Settings"

                $item = Get-Item -Path $sk -Language $version

                # $val = $item["subscription-key"]

                # Write-Host "$RegionName == $mallName == $val " 
                $item.Editing.BeginEdit() | Out-Null
                Write-Host "Starting update for $RegionName / $mallName" -ForegroundColor Green
                $item["subscription-key"] = "7_p2Mh7wAhxY-VIu40VlcjoyqoNWMSsWXXmpLKxNJds"
                # "s_6wsMMh8Jtewg_AE6JoHiy7EOzHuSpRUonOhfw6hSg"
                $item.Editing.EndEdit() | Out-Null
            }
        }
    }

    end{
        Write-Host "Update - Done"
    }
}

UpdateSubscriptionKey