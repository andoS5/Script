
$project = Get-Item -Path "master:/sitecore/content/Klepierre"
$Regions = $project.Children | Where { $_.TemplateID -eq "{CE91FBD6-4D89-42C9-B5BC-2A670439E1FF}" -and !($_.Name -match "^Master") }

 
foreach ($Region in $Regions) {
    $regionName = $Region.Name 

    $Malls = $Region.Children | Where { $_.TemplateID -eq "{46591E02-8902-4C2C-AF61-3EB92BE2489A}" -and !($_.Name -match "^Odysseum") }
    foreach ($Mall in $Malls) {
        $MallName = $Mall.Name
        $formsRAL = Get-Item "master:/sitecore/Forms/$regionName/$MallName/Rent A Local"
        $formsRALID = $formsRAL.ID

        $settingPath = "/sitecore/content/Klepierre/$regionName/$MallName/Settings/Site Grouping/$MallName"
        $settingItem = Get-Item -Path $settingPath
        $version = $settingItem["Language"]
        Write-Host "Startint update for - $regionName - $MallName"
        $ralPath = "master:/sitecore/content/Klepierre/$regionName/$MallName/Presentation/Partial Designs/Forms/Rent a Local"
        # $cpPath = "master:/sitecore/content/Klepierre/$RegionName/$MallName/Presentation/Partial Designs/Forms/Contact Page"
        $ralItem = Get-Item -Path $ralPath -Language $version
        $ralItem.Editing.BeginEdit() | Out-Null
        $rallValue = $ralItem["__Final Renderings"]
        $ralItem["__Renderings"] = $rallValue -replace ("ds=`"(.*?)`"", "ds=`"$formsRALID`"")
        $ralItem["__Final Renderings"] = $rallValue -replace ("ds=`"(.*?)`"", "ds=`"$formsRALID`"")
        $ralItem.Editing.EndEdit() | Out-Null
        Write-Host "Done" -ForegroundColor Green

    }
}