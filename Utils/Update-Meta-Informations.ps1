function Update-Meta-Informations {
    begin {
        Write-Host "Update Meta Information - Begin"
        import-function Utils-Upload-CSV-File
    }

    process {
        $Datas = Utils-Upload-CSV-File -Title "Update News and Events Meta Information"

        foreach ($data in $Datas) {
            $Region = $data.Region
            $Mall = $data.Mall

            $settingPath = "master:/sitecore/content/Klepierre/$Region/$Mall/Settings/Site Grouping/$Mall"
            $settingItem = Get-Item -Path $settingPath
            $Language = $settingItem["Language"]
                
            $EventAndNewsPath = "master:/sitecore/content/Klepierre/$Region/$Mall/Home/Events and News"

            if ((Test-Path -Path $EventAndNewsPath -ErrorAction SilentlyContinue)) {

                Write-Host $EventAndNewsPath 
                $item = Get-Item -Path $EventAndNewsPath -Language $Language

                $item.Editing.BeginEdit()
                $item["Page Title"] = $data.Title
                $item["Meta Description"] = $data.MetaDescription
                $item["Open Graph Image"] = $item["Mobile Image"]
                $item.Editing.EndEdit()

                Write-Host $EventAndNewsPath "Done" -ForegroundColor Green
            }
            
        }

        
    }

    end {
        Write-Host "Update Done"
    }
}