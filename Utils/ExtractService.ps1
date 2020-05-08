# • Mall ID	
# • All the services name
# • Services detail pages URL
# • Services thumbnail URL



$regions = Get-ChildItem -Path "/sitecore/content/Klepierre/" | Where { $_.TemplateID -eq "{CE91FBD6-4D89-42C9-B5BC-2A670439E1FF}" -and !($_.Name -match "^Master") }
$cdnLink = "https://cdn.klepierremalls.com/-/jssmedia"
foreach ($region in $regions) {
    $RegionName = $region.Name
    Write-Host "$RegionName - Begin"
    
    $malls = Get-ChildItem -Item $region | Where { $_.TemplateID -eq "{46591E02-8902-4C2C-AF61-3EB92BE2489A}" }
    
    foreach ($mall in $malls) {
        $mallName = $mall.Name
        # if ($mallName -eq "Arcades") {

            
            $outputFilePath = "$($AppPath)/$($RegionName)_$($MallName).csv"
            $array = New-Object System.Collections.ArrayList

            $settingPath = "$($mall.FullPath)/Settings/Site Grouping/$mallName"
            $settingItem = Get-Item -Path $settingPath
            $version = $settingItem["Language"]
            $TargetHostName = "https://" + $settingItem["TargetHostName"]

            $mallSettingsPath = "master:/sitecore/content/Klepierre/$RegionName/$mallName/Settings/Mall Settings" 
            $mallSettingsItem = Get-Item -Path $mallSettingsPath -Language $version
            $MallID = $mallSettingsItem["Sapid"]
        
            $serviceRepo = "master:/sitecore/content/Klepierre/$RegionName/$mallName/Home/Services"
            $services = Get-ChildItem -Path $serviceRepo -Language $version | Where { $_.TemplateID -eq "{80090502-71A4-42A5-8031-26A219977FBC}" }

            $ServicesRulesPath = "master:/sitecore/content/Klepierre/$RegionName/$mallName/Settings/URL Routing/Link Settings Rules/Service Repository"
            $rulesItem = Get-Item -Path $ServicesRulesPath -Language $version
            $rulesPath = $rulesItem["Path"]

            foreach ($service in $services) {
                $Fields = $service.Fields
                $serviceName = $service.Name
                $imageSource = $Fields['Tile Image']
                $regpattern = "({)(.*)(})"
                $ImageID = [regex]::Match($imageSource, $regpattern)
                # Write-Host $ImageID 
                # Exit
                # $imagePath = "master:/sitecore/media library/" + $imageSource
                $item = Get-Item -Path "master:" -ID "$ImageID"
                $imageSourceRaw = $item.FullPath

                $imageSource = $imageSourceRaw.Replace("/sitecore/media library","")
                $imageExtension ="."+$item.Extension
                $thumbnailUrl = $cdnLink + $imageSource + $imageExtension
                $servicePageUrl = $TargetHostName + $rulesPath +"/"+$serviceName

                $obj = New-Object System.Object

                $obj | Add-Member -MemberType NoteProperty -Name "RegionName" -Value  $RegionName
                $obj | Add-Member -MemberType NoteProperty -Name "MallName" -Value  $MallName
                $obj | Add-Member -MemberType NoteProperty -Name "MallID" -Value  $MallID
                $obj | Add-Member -MemberType NoteProperty -Name "ServiceName" -Value  $Fields['Title'].Value
                $obj | Add-Member -MemberType NoteProperty -Name "ServicesDetailPagesURL" -Value $servicePageUrl
                $obj | Add-Member -MemberType NoteProperty -Name "ThumbnailURL" -Value  $thumbnailUrl


                $array.Add($obj) | Out-Null
            }
            $array | Select-Object RegionName, MallName, MallID, ServiceName, ServicesDetailPagesURL, ThumbnailURL | Export-Csv -Encoding UTF8 -notypeinformation -Path $outputFilePath
            Try {
                Send-File -Path $outputFilePath
            }
            Finally {
                Remove-Item -Path $outputFilePath
            }
        # }
    }
}  

