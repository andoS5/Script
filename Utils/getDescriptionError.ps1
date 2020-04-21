function getDescriptionError {
    begin {
        Write-Host "Find Error in Description - Start"
    }

    process {
        $regions = Get-ChildItem -Path "/sitecore/content/Klepierre/" | Where { $_.TemplateID -eq "{CE91FBD6-4D89-42C9-B5BC-2A670439E1FF}" -and !($_.Name -match "^Master") }
        foreach ($region in $regions) {
            $RegionName = $region.Name
            Write-Host "$RegionName Finding - Begin"
            $malls = Get-ChildItem -Item $region | Where { $_.TemplateID -eq "{46591E02-8902-4C2C-AF61-3EB92BE2489A}" -and !($_.Name -match "^Alpha") -and !($_.Name -match "^Odysseum")}
            foreach ($mall in $malls) {
                $mallName = $mall.Name

                $settingPath = "$($mall.FullPath)/Settings/Site Grouping/$mallName"
                $settingItem = Get-Item -Path $settingPath
                $version = $settingItem["Language"]

                $path = "master:/sitecore/content/Klepierre/$RegionName/$mallName/Home/Shop Repository"
                $item = Get-ChildItem -Path $path -Language $version

                foreach($items in $item){
                    $name = $items.Name
                    $value = $items["Description"]

                    if($value.Contains("\n")){
                        Write-Host "$RegionName/$mallName/Home/Shop Repository/$name"
                    }
                }


            }
        }
    }

    end {
        Write-Host "Checking - Done"
    }
}
getDescriptionError