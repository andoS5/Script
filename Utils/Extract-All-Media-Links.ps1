function Extract-All-Media-Links {
    process {
        $outputFilePath = "$($AppPath)/MediaLink.csv"
        $array = New-Object System.Collections.ArrayList

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

                # Write-Host "shop name" $shopName
                $fbpath = "master:/sitecore/content/Klepierre/$RegionName/$mallName/Home/Forms Repository/Contact Forms Page/Social Media Repository/Facebook"
                $instapath = "master:/sitecore/content/Klepierre/$RegionName/$mallName/Home/Forms Repository/Contact Forms Page/Social Media Repository/Instagram"
                $fb = Get-Item -Path $fbpath -Language $version
                $insta = Get-Item -Path $instapath -Language $version

                $fbRawVal = if($fb){$fb["Social Media Link"]}else{""}
                $instaRawVal = if($insta){$insta["Social Media Link"]}else{""}

                Write-Host "Processing starting  for $RegionName/$mallName"
                $fbVal = if($fbRawVal.Contains("http")){((Select-String '(http[s]?)(:\/\/)([^\s,]+)(?=")' -Input $fbRawVal).Matches.Value)}else{""}
                $instaVal = if($instaRawVal.Contains("http")){((Select-String '(http[s]?)(:\/\/)([^\s,]+)(?=")' -Input $instaRawVal).Matches.Value)}else{""}
                
                $obj = New-Object System.Object

                $obj | Add-Member -MemberType NoteProperty -Name "Region" -Value  $RegionName
                $obj | Add-Member -MemberType NoteProperty -Name "MallName" -Value  $mallName
                $obj | Add-Member -MemberType NoteProperty -Name "FacebookUrl" -Value  $fbVal
                $obj | Add-Member -MemberType NoteProperty -Name "InstagramUrl" -Value  $instaVal

                $array.Add($obj) | Out-Null
            
                Write-Host "done" -ForegroundColor Green
    
                
                
            }
        }   
        $array | Select-Object Region,MallName,FacebookUrl, InstagramUrl | Export-Csv -Encoding UTF8 -notypeinformation -Path $outputFilePath
        Try {
            Send-File -Path $outputFilePath
        }
        Finally {
            Remove-Item -Path $outputFilePath
        }     
    }
}
Extract-All-Media-Links