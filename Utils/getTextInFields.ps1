function getTextInFields {
    begin {
        Write-Host "Starting search ..." -ForegroundColor Yellow
    }

    process {
        $Repository = "master:/sitecore/content/Klepierre/Netherlands"
        $childs = Get-ChildItem -Path $Repository -Language "nl-nl" #| Where { $_.TemplateID -eq "{80D19FA2-B1EF-4E32-93BD-4B2C650A126F}" -or $_.TemplateID -eq "{A496118C-D0EF-440D-8DF5-5DEFE47E662E}" }

        foreach ($child in $childs) {
            $childsName = $child.Name
            Write-Host $childsName
            $petiFils = Get-ChildItem -item $child -Language "nl-nl"
            if($petiFils){
                foreach($petiFil in $petiFils){
                    $pfname = $petiFils.Name
                    # Write-Host $pfname
                }
            }


            $item = Get-Item -Path "$Repository/$childsName" -Language "nl-nl"
            $fields = $item.Fields

            foreach ($field in $fields) {
                $fieldsName = $field.Name

                $Text = $item[$fieldsName]
                if ($null -ne $Text -and $Text.Contains(" : ")  ) {
                    Write-Host "$childsName/$fieldsName"
                    Write-Host $Text 
            #         Write-Host "Update text ... " -ForegroundColor Yellow
            #         Write-Host "Replace the value "
            #         $Text = $Text.Replace("Lorenskog Sc Metro","Metro senter")
            #         Write-Host "New value " -ForegroundColor Blue
            #         Write-Host $Text 
            #         $item.Editing.BeginEdit() | Out-Null
            #         $item[$fieldsName] = $Text
            #         $item.Editing.EndEdit() | Out-Null
            #         Write-Host "Update Done " -ForegroundColor Green
                }
                
            }
        }
    }

    end {
        Write-Host "... Done" -ForegroundColor Green
    }
}

getTextInFields