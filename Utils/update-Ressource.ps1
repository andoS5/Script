function update-Ressource{
    begin {
        Write-Host "Update image start"
    }

    process {
        $regions = Get-ChildItem -Path "/sitecore/content/Klepierre/" | Where { $_.TemplateID -eq "{CE91FBD6-4D89-42C9-B5BC-2A670439E1FF}" -and !($_.Name -match "^Master") }
        foreach ($region in $regions) {
            $RegionName = $region.Name
            Write-Host "$RegionName Update - Begin"
            $malls = Get-ChildItem -Item $region | Where { $_.TemplateID -eq "{46591E02-8902-4C2C-AF61-3EB92BE2489A}" -and !($_.Name -match "^Alpha") -and !($_.Name -match "^Odysseum")}
            foreach ($mall in $malls) {
                $mallName = $mall.Name

                $settingPath = "$($mall.FullPath)/Settings/Site Grouping/$mallName"
                $settingItem = Get-Item -Path $settingPath
                $Language = $settingItem["Language"]

                $path = "master:/sitecore/content/Klepierre/$RegionName/$mallName/Home/Forms Repository/Contact Forms Page"

                if((Test-Path -Path $path -ErrorAction SilentlyContinue)){
                    $item = Get-Item -Path $path -Language $Language

                    $item.Editing.BeginEdit() | Out-Null
                    $item[""] = ""
                    $item.Editing.EndEdit() | Out-Null
                }
            }
        }
    }
    end{
        Write-Host "Update image Done"
    }
}

update-Ressource