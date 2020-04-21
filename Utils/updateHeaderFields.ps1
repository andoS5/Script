$project = Get-Item -Path "master:/sitecore/content/Klepierre"
$Regions = $project.Children | Where { $_.TemplateID -eq "{CE91FBD6-4D89-42C9-B5BC-2A670439E1FF}" -and !($_.Name -match "^Master") }

 
foreach ($Region in $Regions) {
    $regionName = $Region.Name 
    # $regionName = "France"
    $Malls = $Region.Children | Where { $_.TemplateID -eq "{46591E02-8902-4C2C-AF61-3EB92BE2489A}" }
    foreach ($Mall in $Malls) {
        $MallName = $Mall.Name
        if($regionName -eq "France"){
            # $eventPath ="master:/sitecore/content/Klepierre/France/$MallName/Home/Navigation Container/Header Repository/Events"
            $eventPath ="master:/sitecore/content/Klepierre/France/$MallName/Home/Navigation Container/Footer Repository/Mall/Evenements"
            $item = Get-Item -Path $eventPath -Language "fr-Fr"
            Write-Host "Editing for $MallName"
            $item.Editing.BeginEdit() | Out-Null
            $item["Name"] = "Événements"
            $item.Editing.EndEdit() | Out-Null
            Write-Host "Done"

        }
        

    }
}
Write-Host "All is Done"