$project = Get-Item -Path "master:/sitecore/content/Klepierre"
$Regions = $project.Children | Where { $_.TemplateID -eq "{CE91FBD6-4D89-42C9-B5BC-2A670439E1FF}" -and !($_.Name -match "^Master") }
foreach ($Region in $Regions) {
    $regionName = $Region.Name
    $Malls = $Region.Children | Where { $_.TemplateID -eq "{46591E02-8902-4C2C-AF61-3EB92BE2489A}"}
    foreach ($Mall in $Malls) {
        $MallName = $Mall.Name
        # $MallName = "Beaulieu"

        $settingPath = "/sitecore/content/Klepierre/$regionName/$MallName/Settings/Site Grouping/$MallName"
        $settingItem = Get-Item -Path $settingPath
        $version = $settingItem["Language"]

        # $linkSettingRule = "master:/sitecore/content/Klepierre/$regionName/$MallName/Settings/URL Routing/Link Settings Rules"
        $linkSettingRule = "master:/sitecore/content/Klepierre/$regionName/$MallName/Settings/URL Routing/Rewrite Rules"

        # $LinkSettings = Get-ChildItem -Path  $linkSettingRule -Language $version | Where { $_.TemplateID -eq "{0AF03584-55B2-471F-8496-5EEBAF35F68E}" }
        $LinkSettings = Get-ChildItem -Path  $linkSettingRule -Language $version | Where { $_.TemplateID -eq "{7ED4DE90-F271-4EC3-B596-A30772A813BD}" }

        foreach($link in $LinkSettings){
            # Write-Host $link.Name

            $pattern = $link["Pattern"]
            $path = $link["Path"]

            # Write-Host "pattern : $pattern | $($pattern.Substring($pattern.Length -1))| - Path : $path |$($path.Substring($path.Length -1))|"

            $patternChecking = $pattern.Substring($pattern.Length -1)
            $pathChecking = $path.Substring($path.Length -1)

            if($patternChecking.Contains("/")){

                Write-Host " $regionName - $MallName Pattern : $pattern"
            }
            if($pathChecking.Contains("/")){
                Write-Host "$regionName - $MallName Path : $path"
            }
        }
    }
}