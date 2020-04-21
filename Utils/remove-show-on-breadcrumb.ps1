$project = Get-Item -Path "master:/sitecore/content/Klepierre"
$Regions = $project.Children | Where { $_.TemplateID -eq "{CE91FBD6-4D89-42C9-B5BC-2A670439E1FF}" -and !($_.Name -match "^Master") }

 
foreach ($Region in $Regions) {
    $regionName = $Region.Name 
    # $regionName = "France"
    $Malls = $Region.Children | Where { $_.TemplateID -eq "{46591E02-8902-4C2C-AF61-3EB92BE2489A}" }
    foreach ($Mall in $Malls) {
        $MallName = $Mall.Name
        # $MallName = "Avenir"

        $settingPath = "/sitecore/content/Klepierre/$regionName/$MallName/Settings/Site Grouping/$MallName"
        $settingItem = Get-Item -Path $settingPath
        $version = $settingItem["Language"]

        $Repository = Get-ChildItem "master:/sitecore/content/Klepierre/$regionName/$MallName/Home" -Language $version | Where { $_.TemplateID -eq "{969029A9-3A2A-443B-9DFF-43F46C04A2C1}" -or $_.TemplateID -eq "{18DFEC37-2FA7-45E0-A02E-4DBB61E4B1D1}" }

        # Write-Host $Repository.Name
      
        $contact = Get-Item -Path "master:/sitecore/content/Klepierre/$regionName/$MallName/Home/Forms Repository/Contact Forms Page" -Language $version
        $rentLocal = Get-Item -Path "master:/sitecore/content/Klepierre/$regionName/$MallName/Home/Forms Repository/Rent Permanent Space Page" -Language $version
        $rentPermanentLocal = Get-Item -Path "master:/sitecore/content/Klepierre/$regionName/$MallName/Home/Forms Repository/Rent Temporary Space Page" -Language $version
        
        Write-Host "Contact us BreadCrumb"
        $contact.Editing.BeginEdit() | Out-Null
        $contact["Show on breadcrumb"] = 0
        $contact.Editing.EndEdit() | Out-Null
        Write-Host "Updated" -ForegroundColor Yellow
        Write-Host "rent a local BreadCrumb"
        $rentLocal.Editing.BeginEdit() | Out-Null
        $rentLocal["Show on breadcrumb"] = 0
        $rentLocal.Editing.EndEdit() | Out-Null
        Write-Host "Updated" -ForegroundColor Yellow
        Write-Host "rent a permanent local BreadCrumb"
        $rentPermanentLocal.Editing.BeginEdit() | Out-Null
        $rentPermanentLocal["Show on breadcrumb"] = 0
        $rentPermanentLocal.Editing.EndEdit() | Out-Null
        Write-Host "Updated" -ForegroundColor Yellow


    }
    Write-Host "All is Done" -ForegroundColor Green
}