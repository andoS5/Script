function Update-back-rk {
    begin {
        Write-Host "Remove show on mobile - Begin"
    }

    process {

        $regions = Get-ChildItem -Path "/sitecore/content/Klepierre/" | Where { $_.TemplateID -eq "{CE91FBD6-4D89-42C9-B5BC-2A670439E1FF}" -and !($_.Name -match "^Master") }
        foreach ($region in $regions) {
            $RegionName = $region.Name
            Write-Host "$RegionName Update - Begin"
            $malls = Get-ChildItem -Item $region | Where { $_.TemplateID -eq "{46591E02-8902-4C2C-AF61-3EB92BE2489A}" -and !($_.Name -match "^Alpha") -and !($_.Name -match "^Odysseum") }
            $Back = ""

            if($RegionName -eq "France"){
                $Back = "Retour"
            }else{
                $Back = "Back"
            }
            foreach ($mall in $malls) {
                $mallName = $mall.Name

                $settingPath = "$($mall.FullPath)/Settings/Site Grouping/$mallName"
                $settingItem = Get-Item -Path $settingPath
                $version = $settingItem["Language"]

                $ButtonPath ="/sitecore/content/Klepierre/$RegionName/$mallName/Resource Keys/Button/Back"

                $buttonItem = Get-Item -Path $ButtonPath -Language $version

                $value = if(![string]::IsNullOrEmpty($buttonItem["Phrase"])){$buttonItem["Phrase"]} else{""}

                if($value -eq ""){
                    $buttonItem.Editing.BeginEdit() | Out-Null
                    $buttonItem["Phrase"] = $Back
                    $buttonItem.Editing.EndEdit() | Out-Null
                }

            }
        }

    }

    end {
        Write-Host "Done"
    }
}
Update-back-rk