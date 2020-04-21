function update-critizer-icon-alttext {
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
                    $Base = "master:/sitecore/content/Klepierre/$RegionName/$mallName/Home/Services/Gift Card/$tab"

                    $GiftCards = Get-ChildItem -Path $Base | Where { $_.TemplateID -eq "{3AC7E7BC-C58D-4CE2-B10A-75353CA27B32}" } 
                    foreach ($GiftCard in $GiftCards) {
                        $GiftCardName = $GiftCard.Name
                        $gcPath = "$Base/$GiftCardName"
                        $item = Get-Item -Path $gcPath -Language $Language

                        $MobileImage = $item["MobileImage"].Value
                        $DesktopImage = $item["DesktopImage"].Value

                        $MobileImageID = [regex]::match($MobileImage, '\{.*?\}').Groups[0].Value
                        $DesktopImageID - [regex]::match($DesktopImage, '\{.*?\}').Groups[0].Value

                        $mi = Get-Item -Path master: -ID $MobileImageID
                        $desc = Get-Item -Path master: -ID $DesktopImage
                        $miName = $mi.Name
                        $descName = $desc.Name

                        $miNewValue = $MobileImage -replace ("alt=`"(.*?)`"", "alt=`"$miName`"")
                        $desNewValue = $DesktopImage -replace ("alt=`"(.*?)`"", "alt=`"$descName`"")

                        $item.Editing.BeginEdit()
                        $item["MobileImage"] = $miNewValue
                        $item["DesktopImage"] = $desNewValue
                        $item.Editing.EndEdit()

                    }
                }

                

            }
        }
    }
}

update-critizer-icon-alttext