$Region = "master:/sitecore/content/Klepierre/Netherlands"

$Malls = Get-ChildItem -Path $Region | Where { $_.TemplateID -eq "{46591E02-8902-4C2C-AF61-3EB92BE2489A}"}

foreach($Mall in $Malls){
    $shopRepo = "master:/sitecore/content/Klepierre/Netherlands/$($Mall.Name)/Home/Shop Repository"

    $Stores = Get-ChildItem -Path $shopRepo -Language "nl-Nl" | Where { $_.TemplateID -eq "{80D19FA2-B1EF-4E32-93BD-4B2C650A126F}" -or $_.TemplateID -eq "{A496118C-D0EF-440D-8DF5-5DEFE47E662E}"}

    foreach($Store in $Stores){
        $storeName = $Store.Name
        $brandID = $Store["Brand"]
  
        if(![string]::IsNullOrEmpty($brandID)){
            $item =  Get-Item -Path master:"$brandID" -Language "nl-Nl"
            $BrandName = $item["Brand Name"]
            Write-Host "Mall : $($Mall.Name) Store : $storeName Brand : $BrandName"
        }else{

        }
    }
}

