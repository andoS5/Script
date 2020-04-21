function Update-Social-Media-URL {
    begin {
        Write-Host "Update Social Media URL - Begin"
    }

    process {

        
        $regions = Get-ChildItem -Path "/sitecore/content/Klepierre/" | Where { $_.TemplateID -eq "{CE91FBD6-4D89-42C9-B5BC-2A670439E1FF}" -and !($_.Name -match "^Master") -and ($_.Name -match "^Norway") }
        foreach ($region in $regions) {
            $RegionName = $region.Name
            Write-Host "$RegionName Update - Begin"
            $malls = Get-ChildItem -Item $region | Where { $_.TemplateID -eq "{46591E02-8902-4C2C-AF61-3EB92BE2489A}" -and !($_.Name -match "^Alpha")}
            foreach ($mall in $malls) {
                $mallName = $mall.Name

                $settingPath = "$($mall.FullPath)/Settings/Site Grouping/$mallName"
                $settingItem = Get-Item -Path $settingPath
                $version = $settingItem["Language"]

                $path = Get-Item -Path "master:/sitecore/content/Klepierre/$RegionName/$mallName/Home/Shop Repository" 

                $Stores = Get-ChildItem -Item $path | Where { $_.TemplateID -eq "{80D19FA2-B1EF-4E32-93BD-4B2C650A126F}" -or $_.TemplateID -eq "{A496118C-D0EF-440D-8DF5-5DEFE47E662E}"}
                
                
                foreach($Store in $Stores){
                    $StoreName = $Store.Name
                    $sunday = Get-Item -Path "master:/sitecore/content/Klepierre/$RegionName/$mallName/Home/Shop Repository/$StoreName/Opening Hours/Sunday" -Language $version
                    $openingTime = $sunday["Opening Time"]
                    $closingTime = $sunday["Closing Time"]
                    # T000000
                    if(($openingTime.Contains("T000000") -and $closingTime.Contains("T000000")) -or [string]::IsNullOrEmpty($openingTime) -or [string]::IsNullOrEmpty($closingTime)){
                        Write-Host "Close $RegionName/$mallName/Home/Shop Repository/$StoreName - Start" -ForegroundColor Yellow
                        $sunday.Editing.BeginEdit() | Out-Null
                        $sunday["Close"] = 1
                        $sunday.Editing.EndEdit() | Out-Null
                        Write-Host "Done" -ForegroundColor Green
                    }
                }
            }
        }
    }

    end {
        Write-Host "Update URL - Done" -ForegroundColor Green
    }
}
Update-Social-Media-URL