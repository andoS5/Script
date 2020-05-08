function update-workflow {
    begin {
        Write-Host "Update Workflow - Start"
    }

    process {
        
        $regions = Get-ChildItem -Path "/sitecore/content/Klepierre/" | Where { $_.TemplateID -eq "{CE91FBD6-4D89-42C9-B5BC-2A670439E1FF}" -and !($_.Name -match "^Master") }
        foreach ($region in $regions) {
            $RegionName = $region.Name
            Write-Host "$RegionName Finding - Begin"
            if($RegionName -match "^France"){
                $malls = Get-ChildItem -Item $region | Where { $_.TemplateID -eq "{46591E02-8902-4C2C-AF61-3EB92BE2489A}" -and !($_.Name -match "^Alpha") }
            foreach ($mall in $malls) {
                $mallName = $mall.Name

                $settingPath = "$($mall.FullPath)/Settings/Site Grouping/$mallName"
                $settingItem = Get-Item -Path $settingPath
                $version = $settingItem["Language"]

                # $path = "master:/sitecore/content/Klepierre/$RegionName/$mallName/Home"
                $path = "master:/sitecore/content/Klepierre/$RegionName/$mallName/Home/Events and News/News/solidarite entre voisins"

                $item = Get-Item -Path $path -Language $version
                Write-Host "Editing $RegionName/$mallName - Start"
                $item.Editing.BeginEdit() | Out-Null
                $item["__Workflow state"] = "{1E4BF529-524E-4A9C-89E2-01F0BFAB4C31}"
                # $item["__Workflow"] = "{ADFA8C60-8AF8-4B6F-8275-E28A105A6268}"
                # $item["__Default workflow"] = "{ADFA8C60-8AF8-4B6F-8275-E28A105A6268}"
                $item.Editing.EndEdit() | Out-Null


            }
            }
            
        }
    }

    end {
        Write-Host "Done"
    }
}

update-workflow