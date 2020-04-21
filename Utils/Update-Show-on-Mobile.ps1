$project = Get-Item -Path "master:/sitecore/content/Klepierre"
$Regions = $project.Children | Where { $_.TemplateID -eq "{CE91FBD6-4D89-42C9-B5BC-2A670439E1FF}" -and !($_.Name -match "^Master") }

 
foreach ($Region in $Regions) {
    $regionName = $Region.Name 
    # $regionName = "France"
    $Malls = $Region.Children | Where { $_.TemplateID -eq "{46591E02-8902-4C2C-AF61-3EB92BE2489A}"}
    foreach ($Mall in $Malls) {
        $MallName = $Mall.Name
        # $MallName = "Avenir"

        $settingPath = "/sitecore/content/Klepierre/$regionName/$MallName/Settings/Site Grouping/$MallName"
        $settingItem = Get-Item -Path $settingPath
        $version = $settingItem["Language"]

        $Repository = Get-ChildItem "master:/sitecore/content/Klepierre/$regionName/$MallName/Home" -Language $version | Where { $_.TemplateID -eq "{969029A9-3A2A-443B-9DFF-43F46C04A2C1}" -or $_.TemplateID -eq "{18DFEC37-2FA7-45E0-A02E-4DBB61E4B1D1}"}

        # Write-Host $Repository.Name
        foreach($repo in $Repository){
            $child = $repo.Children | Where { $_.TemplateID -eq "{80090502-71A4-42A5-8031-26A219977FBC}" -or $_.TemplateID -eq "{80D19FA2-B1EF-4E32-93BD-4B2C650A126F}" -or $_.TemplateID -eq "{A496118C-D0EF-440D-8DF5-5DEFE47E662E}"} 
            foreach($ch in $child){
                Write-Host "Setting Show on Mobile to 1 for $($regionName+"/"+$MallName+"/"+$ch.Name) - Started" -ForegroundColor Yellow
                $ch.Editing.BeginEdit()
                $ch["Show on Mobile"] = 1
                $ch.Editing.EndEdit()
                Write-Host "Done" -ForegroundColor Green
            }
        }


    }
}