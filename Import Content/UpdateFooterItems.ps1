$project = Get-Item -Path "master:/sitecore/content/Klepierre"
$Regions = $project.Children | Where { $_.TemplateID -eq "{CE91FBD6-4D89-42C9-B5BC-2A670439E1FF}" -and !($_.Name -match "^Master") }

 
foreach ($Region in $Regions) {
    $regionName = $Region.Name 
    # $regionName = "France"
    $Malls = $Region.Children | Where { $_.TemplateID -eq "{46591E02-8902-4C2C-AF61-3EB92BE2489A}" -and $regionName -eq "France"}
    foreach ($Mall in $Malls) {
        $MallName = $Mall.Name
        # $MallName = "Avenir"

        $CGU = Get-Item -Path "master:/sitecore/content/Klepierre/$regionName/$MallName/Home/Navigation Container/Footer Repository/LegalPages/Terms of service page link" -Language "fr-fr"

        foreach($cond in $CGU){
            Write-Host " Editing $($MallName) - Start" -ForegroundColor Yellow
            $cond.Editing.BeginEdit()  | Out-Null
            $cond["Name"] = "CGU"
            $cond.Editing.EndEdit()  | Out-Null
            Write-Host "Done" -ForegroundColor Green
        }
    }
}