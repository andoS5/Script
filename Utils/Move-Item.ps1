function A-To-B{

    begin{
        Write-Host "Moving item - Start"
    }

    process{
        $projetctPaht = "master:/sitecore/content/Klepierre"

        $Regions = Get-ChildItem -Path $projetctPaht | Where {$_.TemplateID -eq "{CE91FBD6-4D89-42C9-B5BC-2A670439E1FF}" -and !($_.Name -match "^Master") }

        foreach ($region in $Regions) {
            $regionName = $region.Name
            $malls = Get-ChildItem -Path $region.FullPath | Where {$_.TemplateID -eq "{46591E02-8902-4C2C-AF61-3EB92BE2489A}" -and !($_.Name -match "^Alpha")}

            foreach($mall in $malls){
                $mallName = $mall.Name
                
                #practical infos to practical info
                # $regionName = "Belgium"
                # $mallName = "LesplanadeNL"
                $sourcePracticalInfo = "master:/sitecore/content/Klepierre/$regionName/$mallName/Resource Keys/Practical Infos"
                $practicalInfoChildren = Get-ChildItem -Path $sourcePracticalInfo | Where {$_.TemplateID -eq "{87B5C7E6-1EFF-4AE2-8E28-AB3668399F91}" }

                $destinationPath = "master:/sitecore/content/Klepierre/$regionName/$mallName/Resource Keys/Practical Info"
                foreach($child in $practicalInfoChildren){
                    $childName = $child.Name

                    $isExist = "$destinationPath/$childName"

                    if(!(Test-Path -Path  $isExist -ErrorAction SilentlyContinue)){
                        Write-Host "Moving " $child.FullPath " to " $destinationPath  -ForegroundColor White
                        Move-Item -Path $child.FullPath -Destination $destinationPath
                        Write-Host "Done " -ForegroundColor Green
                    }

                }

                # #store to stores
                $sourceStorePath = "master:/sitecore/content/Klepierre/$regionName/$mallName/Resource Keys/Store"
                $storeChildren = Get-ChildItem -Path $sourceStorePath | Where {$_.TemplateID -eq "{87B5C7E6-1EFF-4AE2-8E28-AB3668399F91}" }
                $destinationStorePath = "master:/sitecore/content/Klepierre/$regionName/$mallName/Resource Keys/Stores"
                
                foreach($childs in $storeChildren){
                    $childName = $child.Name
                    $isExist = "$destinationStorePath/$childName"
                    if(!(Test-Path -Path $isExist -ErrorAction SilentlyContinue)){
                        Write-Host "Moving " $child.FullPath " to " $destinationStorePath -ForegroundColor White
                        Move-Item -Path $childs.FullPath -Destination $destinationStorePath
                        Write-Host "Done " -ForegroundColor Green
                    }
                }
            }
        }
    }
    end{
        Write-Host "Moving item - Done"
    }
}

A-To-B