#$regions = Get-ChildItem -Path "/sitecore/content/Klepierre/" | Where {$_.TemplateID -eq "{CE91FBD6-4D89-42C9-B5BC-2A670439E1FF}" }
$regions = Get-ChildItem -Path "/sitecore/content/Klepierre/" | Where { $_.Name -eq "France" }
$reg = 0
$regCount = $regions.Count
foreach ($region in $regions) {
    $reg++
    Write-Host "[$($reg)/$($regCount)] $($region.Name)"
    $sites = Get-ChildItem -Item $region | Where { $_.TemplateID -eq "{46591E02-8902-4C2C-AF61-3EB92BE2489A}" -and ($_.Name -match "Courier") }
    foreach ($site in $sites) {
        $settingPath = "$($site.FullPath)/Settings/Site Grouping/$($site.Name)"
        $settingItem = Get-Item -Path $settingPath
        $version = $settingItem["Language"]
        $path = "master:/sitecore/content/Klepierre/$($region.Name)/$($site.Name)/Home/Services"#/sitecore/content/Klepierre/France/CentreDeux/Home/Services/credit-agricole-dab
        $t = Get-ChildItem -path $path -Language $version | ? { ($_.Name -match "recharge-telephone" ) }#-or $_.Name -match "kit-di" -or $_.Name -match "prim") }#-and !($_.Name -match "accessori-auto" -or $_.Name -match "accessibilite-chien")}
        # $t
        # continue
        $type = "default-shop"
        $service = "default"
        $pathTile = "/sitecore/media library/Project/Klepierre/shared/Services/$($service)/$($type)_378x227"
        $tile = Get-Item -Path $pathTile -ErrorAction SilentlyContinue
        $pathLarge = "/sitecore/media library/Project/Klepierre/shared/Services/$($service)/$($type)_1920x580"
        $large = Get-Item -Path $pathLarge -ErrorAction SilentlyContinue
        $pathDesk = "/sitecore/media library/Project/Klepierre/shared/Services/$($service)/$($type)_1200x580"
        $desk = Get-Item -Path $pathDesk -ErrorAction SilentlyContinue
        $pathMobile = "/sitecore/media library/Project/Klepierre/shared/Services/$($service)/$($type)_480x388"
        $mobile = Get-Item -Path $pathMobile -ErrorAction SilentlyContinue
        $pathTablet = "/sitecore/media library/Project/Klepierre/shared/Services/$($service)/$($type)_768x388"
        $tablet = Get-Item -Path $pathTablet -ErrorAction SilentlyContinue
        $pathCarousselDesk = "/sitecore/media library/Project/Klepierre/shared/Services/$($service)/$($type)_1180x448"
        $carousselDesk = Get-Item -Path $pathCarousselDesk -ErrorAction SilentlyContinue
        $pathCarousselTab = "/sitecore/media library/Project/Klepierre/shared/Services/$($service)/$($type)_768x448"
        $carousselTab = Get-Item -Path $pathCarousselTab -ErrorAction SilentlyContinue
        $pathCarousselMob = "/sitecore/media library/Project/Klepierre/shared/Services/$($service)/$($type)_303x156"
        $carousselMob = Get-Item -Path $pathCarousselMob -ErrorAction SilentlyContinue
        #Write-Host "<image mediaid=`"$($tile.ID)`" alt=`"dog`"  />"
		
        if ($null -ne $t) {
            foreach ($item in $t) {
                #if([string]::isNullOrEmpty($item["Background Image"])){
                $item.Editing.BeginEdit() | Out-Null
                $item["Tile Image"] = "<image mediaid=`"$($tile.ID)`" alt=`"$($tile.Name)`"  />"
                $item["Background Image"] = "<image mediaid=`"$($desk.ID)`" alt=`"$($desk.Name)`"  />"
                $item["Large Image"] = "<image mediaid=`"$($large.ID)`" alt=`"$($large.Name)`"  />"
                $item["Mobile Image"] = "<image mediaid=`"$($mobile.ID)`" alt=`"$($mobile.Name)`"  />"
                $item["Tablet Image"] = "<image mediaid=`"$($tablet.ID)`" alt=`"$($tablet.Name)`"  />"
                $item["Open Graph Image"] = "<image mediaid=`"$($mobile.ID)`" alt=`"$($mobile.Name)`"  />"
                $item["Desktop Carousel Image"] = "<image mediaid=`"$($carousselDesk.ID)`" alt=`"$($carousselDesk.Name)`"  />"
                $item["Tablet Carousel Image"] = "<image mediaid=`"$($carousselTab.ID)`" alt=`"$($carousselTab.Name)`"  />"
                $item["Mobile Carousel Image"] = "<image mediaid=`"$($carousselMob.ID)`" alt=`"$($carousselMob.Name)`"  />"
                $item["Show on Mobile"] = 1
                $item["__Workflow"] = "{ADFA8C60-8AF8-4B6F-8275-E28A105A6268}"
                $item["__Workflow state"] = "{1E4BF529-524E-4A9C-89E2-01F0BFAB4C31}"
                $item["__Default workflow"] = "{ADFA8C60-8AF8-4B6F-8275-E28A105A6268}"
                $item.Editing.EndEdit() | Out-Null
                Write-Host "done for $($item.Name)/$($site.Name)"
                #}
        
            }
        }
    }
}