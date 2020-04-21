function updateCategories {
    begin {

        Write-Host "Starting Update"
        Import-Function Utils-Remove-Diacritics
        Import-Function Utils-Upload-CSV-File
    }

    process {
        $region = "France"
        $mallName = "ValDeuropeEn"
        $Language = "en"

        $Datas = Utils-Upload-CSV-File -Title "Update Categories"
        $path = "master:/sitecore/content/Klepierre/$region/$mallName/Home/Shop Repository"
        

        $shops = Get-ChildItem -Path $path -Language $Language | Where { $_.TemplateID -eq "{80D19FA2-B1EF-4E32-93BD-4B2C650A126F}" }
        

        foreach ($Data in $Datas) {
            $friendlyUrl = Utils-Remove-Diacritics $Data["Friendly URL"]
            $category = Utils-Remove-Diacritics $Data["Category 1"]
            $categ2 = if (![string]::IsNullOrEmpty($Data["Category 2"])) { Utils-Remove-Diacritics $Data["Category 2"] }else { }
            $categ3 = if (![string]::IsNullOrEmpty($Data["Category 3"])) { Utils-Remove-Diacritics $Data["Category 3"] }else { }

            $subCat = if (![string]::IsNullOrEmpty($Data["Sub-Category 1"])) { Utils-Remove-Diacritics $Data["Sub-Category 1"] }else { }
            $subCat2 = if (![string]::IsNullOrEmpty($Data["Sub-Category 2"])) { Utils-Remove-Diacritics $Data["Sub-Category 2"] }else { }
            $subCat3 = if (![string]::IsNullOrEmpty($Data["Sub-Category 3"])) { Utils-Remove-Diacritics $Data["Sub-Category 3"] }else { }

            foreach ($shop in $shops) {
                $shopName = $shop.Name
                if ($shopName -eq $friendlyUrl) {
                    Write-Host "nahita"
                    $item = Get-Item -Path "$path/$shopName" -Language $Language
                    $cat = "master:/sitecore/content/Klepierre/$region/Category Repository/$category"
                    $cat2 = "master:/sitecore/content/Klepierre/$region/Category Repository/$categ2"
                    $cat3 = "master:/sitecore/content/Klepierre/$region/Category Repository/$categ3"

                    $subcats = "master:/sitecore/content/Klepierre/$region/Category Repository/$category/$subCat"
                    $subcats2 = "master:/sitecore/content/Klepierre/$region/Category Repository/$category/$subCat2"
                    $subcats3 = "master:/sitecore/content/Klepierre/$region/Category Repository/$category/$subCat3"

                 
                    $CatItem = if ((Test-Path -Path $cat -ErrorAction SilentlyContinue)) { Get-Item -Path $cat -Language $Language } else { }
                    $CatItem2 = if ((Test-Path -Path $cat2 -ErrorAction SilentlyContinue)) { Get-Item -Path $cat2 -Language $Language } else { }
                    $CatItem3 = if ((Test-Path -Path $cat3 -ErrorAction SilentlyContinue)) { Get-Item -Path $cat3 -Language $Language } else { }

                    $item.Editing.BeginEdit() | Out-Null
                    $categoryValue = $item["Category"]
                    $categ1ID = $CatItem.ID
                    $categ2ID = $CatItem2.ID
                    $categ3ID = $CatItem3.ID
                    Write-Host "manova le categ  $categ1ID"
                    if (!$categoryValue.Contains("$categ1ID")) {
                        $item["Category"] = $CatItem.ID
                    }if (!$categoryValue.Contains("$categ2ID")) {
                        $item["Category"] = "$categoryValue|$categ2ID"
                    }if (!$categoryValue.Contains("$categ3ID")) {
                        $item["Category"] = "$categoryValue|$categ3ID"
                    }

                    if ((Test-Path -Path $subcats -ErrorAction SilentlyContinue)) {
                        $subCatItem = if ((Test-Path -Path $subcats -ErrorAction SilentlyContinue)) { Get-Item -Path $subcats -Language $Language }else { }
                        $subCatItem2 = if ((Test-Path -Path $subcats2 -ErrorAction SilentlyContinue)) { Get-Item -Path $subcats2 -Language $Language }else { }
                        $subCatItem3 = if ((Test-Path -Path $subcats3 -ErrorAction SilentlyContinue)) { Get-Item -Path $subcats3 -Language $Language }else { }
                        $subCatValue = $item["Sub Category"]
                        $sc1ID = $subCatItem.ID
                        $sc2ID = $subCatItem2.ID
                        $sc3ID = $subCatItem3.ID
                        if (!$subCatValue.Contains("$sc1ID")) {
                            $item["Sub Category"] = $subCatItem.ID
                        } if (!$subCatValue.Contains("$sc2ID")) {
                            $item["Sub Category"] = "$subCatValue|$sc2ID"
                        } if (!$subCatValue.Contains("$sc3ID")) {
                            $item["Sub Category"] = "$subCatValue|$sc3ID"
                        }
                    }
                    $item.Editing.EndEdit() | Out-Null
                    
                }
            }

        }
    }
    end {
        Write-Host "Done"
    }
}

updateCategories