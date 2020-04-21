function update-gift-card-icon-alttext {
    begin {
        Write-Host "Update Icon Alt Text - Begin"
    }

    process {
        $regions = Get-ChildItem -Path "/sitecore/content/Klepierre/" | Where { $_.TemplateID -eq "{CE91FBD6-4D89-42C9-B5BC-2A670439E1FF}" -and !($_.Name -match "^Master") }
        foreach ($region in $regions) {
            $RegionName = $region.Name

            $malls = Get-ChildItem -Item $region | Where { $_.TemplateID -eq "{46591E02-8902-4C2C-AF61-3EB92BE2489A}" -and !($_.Name -match "^Alpha") }
            foreach ($mall in $malls) {
                $mallName = $mall.Name


                $settingPath = "$($mall.FullPath)/Settings/Site Grouping/$mallName"
                $settingItem = Get-Item -Path $settingPath
                $Language = $settingItem["Language"]

                $array = @("Company", "Personal")

                foreach ($tab in $array) {
                    $Base = "master:/sitecore/content/Klepierre/$RegionName/$mallName/Home/Media Repository"
                    if ((Test-Path -Path $Base -ErrorAction SilentlyContinue)) {
                        $ItemsToUpdate = Get-ChildItem -Path $Base | Where { $_.TemplateID -eq "{671D7F4C-12A0-48B0-9AA8-3E5CB49E47C1}" } 
                        foreach ($record in $ItemsToUpdate) {
                            Write-Host $RegionName $record.Name
                            $recordName = $record.Name
                            $child = "$Base/$recordName"
                            $item = Get-Item -Path $child -Language $Language

                            $image = $item["image"]
                    
                            
                            $MobileImageID = [regex]::match($image, '\{.*?\}').Groups[0].Value
                            $mi = Get-Item -Path master: -ID $MobileImageID
                            $miName = $mi.Name
                            $miNewValue = ""
                            if ($image.Contains("alt=")) {
                                $miNewValue = $image -replace ("alt=`"(.*?)`"", "alt=`"$miName`"")
                            }
                            else {
                                $miNewValue = $image -replace (" />", " alt=`"$miName`" />")

                            }
    
                            $item.Editing.BeginEdit()
                            $item["image"] = $miNewValue
                            $item.Editing.EndEdit()
                            Write-Host "Done" -ForegroundColor Green
    
                        }
                    }
                    
                }
            }
        }
    }

    end {
        Write-Host "All is Done"
    }
}

update-gift-card-icon-alttext