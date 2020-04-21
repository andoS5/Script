$shopRepo = "master:/sitecore/content/Klepierre/France/EcullyGrandOuest/Home/Shop Repository"
$Stores = Get-ChildItem -Path $shopRepo | Where { $_.TemplateID -eq "{80D19FA2-B1EF-4E32-93BD-4B2C650A126F}" -or $_.TemplateID -eq "{A496118C-D0EF-440D-8DF5-5DEFE47E662E}"}

foreach($Store in $Stores){
    $StoreName = $Store.Name
    # Write-Host $StoreName
    $oh = "master:/sitecore/content/Klepierre/France/EcullyGrandOuest/Home/Shop Repository/$StoreName/Opening Hours"
    $Days =  Get-ChildItem -Path  $oh -Language "Fr-fr" | Where { $_.TemplateID -eq "{6C32F517-77B1-4E0C-B8CE-D1FE77E25563}"}

    foreach($Day in $Days){
        $DayName = $Day.Name

        $item = Get-Item -Path "$oh/$DayName" -Language "Fr-fr"
        $opening = $item["Opening Time"]
        $closing = $item["Closing Time"]
        $Close = $item["Close"]

        Write-Host  "$StoreName#$DayName#$opening#$closing#$Close"-ForegroundColor Yellow
    }
}