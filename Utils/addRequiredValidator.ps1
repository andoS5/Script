function addRequiredValidator {
    begin {
        Write-Host "Adding Required Validator on All Forms - Start" -ForegroundColor Yellow
    }
    process {
        $regions = Get-ChildItem -Path "/sitecore/content/Klepierre/" | Where { $_.TemplateID -eq "{CE91FBD6-4D89-42C9-B5BC-2A670439E1FF}" -and !($_.Name -match "^Master") }
        foreach ($region in $regions) {
            $RegionName = $region.Name
            # Write-Host "$RegionName Finding - Begin"
            $malls = Get-ChildItem -Item $region | Where { $_.TemplateID -eq "{46591E02-8902-4C2C-AF61-3EB92BE2489A}" -and !($_.Name -match "^Alpha") }
            foreach ($mall in $malls) {
                $mallName = $mall.Name
                $settingPath = "$($mall.FullPath)/Settings/Site Grouping/$mallName"
                $settingItem = Get-Item -Path $settingPath
                $version = $settingItem["Language"]

                $path = "master:/sitecore/Forms/$RegionName/$mallName/Rent A Local/Page/Phone"

                $item = Get-Item -Path $path -Language $version
                $value = $item["Validations"]
                if(!$value.Contains("{95EA4BB6-0A25-4C78-84B5-4E623DE35573}")){
                    $newValue = "{95EA4BB6-0A25-4C78-84B5-4E623DE35573}|$value"
                    Write-Host "$RegionName/$mallName" -ForegroundColor Yellow
                    Write-Host "updating $value to $newValue" -ForegroundColor Yellow
                    $item.Editing.BeginEdit() | Out-Null
                    $item["Validations"] = $newValue
                    $item.Editing.EndEdit() | Out-Null
                    Write-Host "Updated" -ForegroundColor Green
                }
            }
        }
    }
}
addRequiredValidator