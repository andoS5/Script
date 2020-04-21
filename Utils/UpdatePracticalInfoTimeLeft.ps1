$country = "Germany"
$version ="de-DE"
$CountryPath = "master:/sitecore/content/Klepierre/$country"
$CountryMall = Get-ChildItem -Path $CountryPath -Language $version | Where { $_.TemplateID -eq "{46591E02-8902-4C2C-AF61-3EB92BE2489A}"}

foreach ($cm in $CountryMall) {
    $cmName = $cm.Name
    Write-Host $fmName
    # $mall = "master:/sitecore/content/Klepierre/France/$fmName/Resource Keys/Practical Info/Indicator time left" #atao remove version
    # $mall = "master:/sitecore/content/Klepierre/France/$fmName/Resource Keys/Practical Info/Indicator re-open time"
    $mall = "master:/sitecore/content/Klepierre/$country/$cmName/Home/Practical Information"

    Add-ItemVersion -Path $mall -Language $version
    $item = Get-Item -Path $mall -Language $version
    $item.Editing.BeginEdit() | Out-Null
    # $item["Phrase"] = "Suite aux décisions des autorités, seuls les commerces de première nécéssité restent ouverts avec des horaires aménagés"
    $item["Partial Opening Text"] = "Informationen zur aktuellen Situation und geöffneten Shops im News-Bereich."
    $item.Editing.EndEdit() | Out-Null
  
}

