$project = Get-Item -Path "master:/sitecore/content/Klepierre"
$Regions = $project.Children | Where { $_.TemplateID -eq "{CE91FBD6-4D89-42C9-B5BC-2A670439E1FF}" -and !($_.Name -match "^Master") }

 
foreach ($Region in $Regions) {
    $regionName = $Region.Name 
    # $regionName = "France"
    $Malls = $Region.Children | Where { $_.TemplateID -eq "{46591E02-8902-4C2C-AF61-3EB92BE2489A}" -and !($_.Name -match "^Odysseum") }
    foreach ($Mall in $Malls) {
        $MallName = $Mall.Name
  
        $path = "master:/sitecore/content/Klepierre/$regionName/$MallName/Home/Navigation Container/Footer Repository/Mobile App Repository"
        Write-Host "Renaming -- $path - Start" -ForegroundColor Yellow
        Rename-Item -Path $path -NewName "NA Mobile App Repository"
        Write-Host "Done" -ForegroundColor Green

    }
}