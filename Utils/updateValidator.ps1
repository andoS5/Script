function updateValidator {
    begin {
        Write-Host "Update Validator - Start" -ForegroundColor Blue -BackgroundColor White
    }

    process {
        $ValidatorsPath = "master:/sitecore/system/Settings/Forms/Validations"
        $regions = Get-ChildItem -Path "/sitecore/content/Klepierre/" | Where { $_.TemplateID -eq "{CE91FBD6-4D89-42C9-B5BC-2A670439E1FF}" -and !($_.Name -match "^Master") }
        foreach ($region in $regions) {
            $RegionName = $region.Name
            $var = ""
            if ($RegionName -eq "Czech Republic") {
                $var = "Czech"
            }
            else {
                $var = $RegionName
            }
            # Write-Host "$RegionName Update - Begin"
            $malls = Get-ChildItem -Item $region | Where { $_.TemplateID -eq "{46591E02-8902-4C2C-AF61-3EB92BE2489A}" -and !($_.Name -match "^Alpha") -and !($_.Name -match "^Odysseum") }
            foreach ($mall in $malls) {
                $mallName = $mall.Name

                $settingPath = "$($mall.FullPath)/Settings/Site Grouping/$mallName"
                $settingItem = Get-Item -Path $settingPath
                $version = $settingItem["Language"]
                $phoneFormsPath = "master:/sitecore/Forms/$RegionName/$mallName/Contact Page/Page/Phone"
                $postCodeFormsPath = "master:/sitecore/Forms/$RegionName/$mallName/Contact Page/Page/Post Code"
                $cityFormsPath = "master:/sitecore/Forms/$RegionName/$mallName/Contact Page/Page/City"
                $rentALocalPath ="master:/sitecore/Forms/$RegionName/$mallName/Rent A Local/Page/Phone"

                $rentALocalItem = Get-Item -Path $rentALocalPath -Language $version
                $PhoneItem = Get-Item -Path $phoneFormsPath -Language $version
                $postCodeItem = Get-Item -Path $postCodeFormsPath -Language $version
                $cityItem = Get-Item -Path $cityFormsPath -Language $version

                $validators = Get-ChildItem -Path $ValidatorsPath | where { $_.TemplateID -eq "{0A1A6DCE-078A-4ECE-9FCE-71CADE57C7B8}" }
               

                foreach ($validator in $validators) {
                    $validatorName = $validator.Name
                    
                    # Write-Host "xxx $var" $validatorName

                    if ($validatorName.Contains($var)) {
                        $item = Get-Item -Path "$ValidatorsPath/$validatorName"
                        $itemName = $item.Name
                        $itemID = $item.ID
                        if ($itemName.Contains("Phone")) {
                            
                            Write-Host "$ValidatorsPath/$validatorName - Start" -ForegroundColor Yellow
                            $PhoneItem.Editing.BeginEdit() | Out-Null
                            $PhoneItem["Validations"] = "{95EA4BB6-0A25-4C78-84B5-4E623DE35573}|$itemID"
                            $PhoneItem.Editing.EndEdit() | Out-Null

                            $rentALocalItem.Editing.BeginEdit() | Out-Null
                            $rentALocalItem["Validations"] = "{95EA4BB6-0A25-4C78-84B5-4E623DE35573}|$itemID"
                            $rentALocalItem.Editing.EndEdit() | Out-Null
                            Write-Host "Done" -ForegroundColor Green
                        }

                        # if ($itemName.Contains("Post")) {
                            
                        #     Write-Host "$ValidatorsPath/$validatorName - Start" -ForegroundColor Yellow
                        #     $postCodeItem.Editing.BeginEdit() | Out-Null
                        #     $postCodeItem["Validations"] = $item.ID
                        #     $postCodeItem.Editing.EndEdit() | Out-Null
                        #     Write-Host "Done" -ForegroundColor Green
                        # }

                        # if ($itemName.Contains("City")) {
                        #     Write-Host "$ValidatorsPath/$validatorName - Start" -ForegroundColor Yellow
                        #     $cityItem.Editing.BeginEdit() | Out-Null
                        #     $cityItem["Validations"] = $item.ID
                        #     $cityItem.Editing.EndEdit() | Out-Null
                        #     Write-Host "Done" -ForegroundColor Green
                        # }
                    }
                  
                }

            }
        }

    }

    end {
        Write-Host "All Updates are Done" -ForegroundColor Green
    }
    
}
updateValidator