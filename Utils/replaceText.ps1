function replaceText {
    begin {
        Write-Host "Start finding the text"
    }
    process {
        $mallRepository = "master:/sitecore/content/Klepierre/France"

        $Children = Get-ChildItem -Path $mallRepository | Where { $_.TemplateID -eq "{46591E02-8902-4C2C-AF61-3EB92BE2489A}" }

        foreach ($Child in $Children) {
            $mallName = $Child.Name
            $eventRepo = "master:/sitecore/content/Klepierre/France/$mallName/Home/Events and News/Events"

            $Events = Get-ChildItem -Path $eventRepo | Where { $_.TemplateID -eq "{4058CE82-4516-4650-A69E-162D72F766D6}" }
            foreach ($Event in $Events) {
                $EventName = $Event.Name
                $item = Get-Item -Path "$eventRepo/$EventName" -Language "Fr-fr"
                
                # Write-Host $item["Abstract"]
                $descr = $item["Abstract"]

                # if($descr.Contains('De (\d{2}\/\d{2}\/\d{4}) à')){
                #     Write-Host "$mallName - $EventName"
                #     Write-Host $descr
                # }
                $startDate = $item["Event date Start"]
                $EndDate = $item["Event date End"]

                if($startDate -ne $EndDate -and $descr -match 'De (\d{1,2}) à'){
                    Write-Host "$mallName - $EventName"
                    Write-Host $descr
                    # Write-Host "Start " $startDate
                    # Write-Host "End  " $EndDate
                }


            }

        }


    }
    end {
        Write-Host "Text replaced successfully"
    }
}
replaceText