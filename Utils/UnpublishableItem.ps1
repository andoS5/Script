function UnpublishItem{
    begin{
        Write-Host "Starting to update the Item"
    }

    process{
        $mallRepository = "master:/sitecore/content/Klepierre/France"

        $Children = Get-ChildItem -Path $mallRepository -Language "Fr-Fr"| Where { $_.TemplateID -eq "{46591E02-8902-4C2C-AF61-3EB92BE2489A}" }
        foreach ($Child in $Children) {
            $mallName = $Child.Name
            $HomepageBanner = "master:/sitecore/content/Klepierre/France/$mallName/Home/Banner Repository/Homepage Banner"
            $Sliders = Get-ChildItem -Path $HomepageBanner -Language "Fr-Fr" | Where { $_.TemplateID -eq "{CCAB194E-53F8-47FB-9119-15C923A0B865}" }
            $SliderCount = $Sliders.Length
            

            if( $SliderCount -ne 1){
                # Write-Host "$mallName Count = $SliderCount"
                foreach($Slider in $Sliders){
                    $SliderName = $Slider.Name
                    
                    $Item = Get-Item -Path "$HomepageBanner/$SliderName" -Language "Fr-Fr"
                    $Title = if(![string]::IsNullOrEmpty($Item["Title"])){$Item["Title"]}else{""}
                    $ShortDescription = if(![string]::IsNullOrEmpty($Item["Short Description"])){$Item["Short Description"]}else{""} 

                    if($null -ne $Title -and $Title.Contains("SOLDE")){
                        Write-Host "Count == $SliderCount"
                        # Write-Host "$mallName ==> $SliderName"
                        # Write-Host "$Title ==== $ShortDescription"
                        $publishable = $Item["__Never publish"]
                        Write-Host "publishable === $publishable"

                    }

                }
            }
            
        }
    }

    end{
        Write-Host "Update Done"
    }
}

UnpublishItem