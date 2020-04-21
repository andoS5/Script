$regions = Get-ChildItem -Path "/sitecore/content/Klepierre/" | Where { $_.TemplateID -eq "{CE91FBD6-4D89-42C9-B5BC-2A670439E1FF}" -and !($_.Name -match "^Master") }
foreach ($region in $regions) {
    $RegionName = $region.Name
    $malls = Get-ChildItem -Item $region | Where { $_.TemplateID -eq "{46591E02-8902-4C2C-AF61-3EB92BE2489A}" -and !($_.Name -match "^Alpha") }
    
    foreach ($mall in $malls) {
        $mallName = $mall.Name
        if ($mallName -eq "Nordbyen") {
            $settingPath = "$($mall.FullPath)/Settings/Site Grouping/$mallName"
            $settingItem = Get-Item -Path $settingPath
            $Language = $settingItem["Language"]

            $shopRepo = "master:/sitecore/content/Klepierre/$RegionName/$mallName/Home/Shop Repository"
            $Stores = Get-ChildItem -Path $shopRepo -Language $Language | Where { $_.TemplateID -eq "{80D19FA2-B1EF-4E32-93BD-4B2C650A126F}" -or $_.TemplateID -eq "{A496118C-D0EF-440D-8DF5-5DEFE47E662E}" } 

            foreach ($Store in $Stores) {

                $path = $Store.FullPath
                Get-Item -Path "master:$path" -Language $Language | Unlock-Item -PassThru
                
            }
        }
        
    }
}