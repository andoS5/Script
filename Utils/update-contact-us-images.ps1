function update-contact-us-images {
    begin {
        Write-Host "Update image start"
    }

    process {
        $regions = Get-ChildItem -Path "/sitecore/content/Klepierre/" | Where { $_.TemplateID -eq "{CE91FBD6-4D89-42C9-B5BC-2A670439E1FF}" -and !($_.Name -match "^Master") }
        foreach ($region in $regions) {
            $RegionName = $region.Name
            Write-Host "$RegionName Update - Begin"
            $malls = Get-ChildItem -Item $region | Where { $_.TemplateID -eq "{46591E02-8902-4C2C-AF61-3EB92BE2489A}" -and !($_.Name -match "^Alpha") -and !($_.Name -match "^Odysseum")}
            foreach ($mall in $malls) {
                $mallName = $mall.Name

                $settingPath = "$($mall.FullPath)/Settings/Site Grouping/$mallName"
                $settingItem = Get-Item -Path $settingPath
                $Language = $settingItem["Language"]

                $contactUsPath = "master:/sitecore/content/Klepierre/$RegionName/$mallName/Home/Forms Repository/Contact Forms Page"

                if((Test-Path -Path $contactUsPath -ErrorAction SilentlyContinue)){
                    $item = Get-Item -Path $contactUsPath -Language $Language

                    $item.Editing.BeginEdit() | Out-Null
                    $item["Background Image"] = "<image mediaid=`"{A4D64889-FC33-48CB-A884-9028F4135C0E}`" alt=`"ContactUs_1920x580`" height=`"`" width=`"`" hspace=`"`" vspace=`"`" />"
                    $item["Large Image"] = "<image mediaid=`"{6D4EF17C-3100-410A-AFD2-B46929C8D1C1}`" alt=`"ContactUs_1200x580`" height=`"`" width=`"`" hspace=`"`" vspace=`"`" />"
                    $item["Tablet Image"] = "<image mediaid=`"{1E6B0FE7-D32A-4B48-9AB9-FE6342C457E8}`" alt=`"ContactUs_768x388`" height=`"`" width=`"`" hspace=`"`" vspace=`"`" />"
                    $item["Mobile Image"] = "<image mediaid=`"{92EF7506-8F41-452F-9F0B-7DA927FCA7B5}`" alt=`"ContactUs_480x388`" height=`"`" width=`"`" hspace=`"`" vspace=`"`" />"
                    $item.Editing.EndEdit() | Out-Null
                }
            }
        }
    }
    end{
        Write-Host "Update image Done"
    }
}

update-contact-us-images