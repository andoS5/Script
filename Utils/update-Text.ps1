function update-Text {
    begin{
        Write-Host "update text begin"
    }

    process{
        $shopRepo = "master:/sitecore/content/Klepierre/France/EspaceCoty/Home/Shop Repository"
        $stores = Get-ChildItem -Path $shopRepo -Language "Fr-fr" | Where { $_.TemplateID -eq "{80D19FA2-B1EF-4E32-93BD-4B2C650A126F}" -or $_.TemplateID -eq "{A496118C-D0EF-440D-8DF5-5DEFE47E662E}"}

        foreach($store in $stores){
            $itemPath = "$shopRepo/$($store.Name)"
            # Write-Host $itemPath
            $item = Get-Item -Path $itemPath -Language "Fr-fr"

            $pageTitle = $item["Page Title"]
            $metadescription = $item["Meta Description"]

            if($pageTitle.Contains("Espace Coty")){
                $pageTitle = $pageTitle.Replace("Espace Coty","Coty")
            }

            if($metadescription.Contains("Espace Coty")){
                $metadescription = $metadescription.Replace("Espace Coty","Coty")
            }

            $item.Editing.BeginEdit() | Out-Null
            Write-Host "Page Title = $pageTitle" -ForegroundColor Yellow
            $item["Page Title"] = $pageTitle
            Write-Host "Meta Description = $metadescription" -ForegroundColor Green
            $item["Meta Description"] = $metadescription
            $item.Editing.EndEdit() | Out-Null
            
        }

    }

    end{
        Write-Host "update text end" 
    }
}
update-Text