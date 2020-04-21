function updateBrand{

    param (
        [Parameter(Mandatory = $true, Position = 0 )]
        [string]$RegionName,
    
        [Parameter(Mandatory = $true, Position = 1 )]
        [string]$Language,
    
        [Parameter(Mandatory = $true, Position = 2 )]
        [string]$MallName
    )

    begin{
        Write-Host "Update Brand - Start" -ForegroundColor Yellow
    }

    process{
        $shopRepo = "master:/sitecore/content/Klepierre/$RegionName/$MallName/Home/Shop Repository"
        $shops = Get-ChildItem -Path $shopRepo -Language $Language | Where { $_.TemplateID -eq "{80D19FA2-B1EF-4E32-93BD-4B2C650A126F}" -or $_.TemplateID -eq "{A496118C-D0EF-440D-8DF5-5DEFE47E662E}"}
        
        foreach($shop in $shops){
            $shopName = $shop.Name
            $brand = "master:/sitecore/content/Klepierre/$RegionName/Brand Repository/$shopName"
            $brandItem = Get-Item -Path $brand -Language $Language

            $brandID = $brandItem.ID
            Write-Host "Changing $shopName Brand"
            $shop.Editing.BeginEdit() | Out-Null
            $shop["Brand"] = $brandID
            $shop.Editing.EndEdit() | Out-Null
            Write-Host "Done" -ForegroundColor Yellow


        }
    
    }
    end{
        Write-Host "All is Done" -ForegroundColor Green
    }

}
updateBrand "France" "fr-Fr" "Blagnac"