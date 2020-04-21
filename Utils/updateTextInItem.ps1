function updateTextInItem {
    

    begin{
        Write-Host "Starting Update"
    }

    process{
        $Repository = "master:/sitecore/content/Klepierre/Norway/LorenskogScMetro/Home/Services"

        $childs = Get-ChildItem -Path $Repository | Where { $_.TemplateID -eq "{80090502-71A4-42A5-8031-26A219977FBC}" }

        foreach($child in $childs){
            $childsName = $child.Name

            $item = Get-Item -Path "$Repository/$childsName" -Language "nb-no"
            $pageTitle = $item["Page Title"]
            $metaDescription = $item["Meta Description"]

            if($pageTitle.Contains("Lorenskog Sc Metro")){
                $pageTitle = $pageTitle.Replace("Lorenskog Sc Metro","Metro senter")
            }
            if($metaDescription.Contains("Lorenskog Sc Metro")){
                $metaDescription = $metaDescription.Replace("Lorenskog Sc Metro","Metro senter")
            }
            $item.Editing.BeginEdit() | Out-Null
            $item["Page Title"] = $pageTitle
            $item["Meta Description"] = $metaDescription
            $item.Editing.EndEdit() | Out-Null
        }
    }

    end{
        Write-Host "Update Done"
    }
}

updateTextInItem