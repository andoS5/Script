$NewsSource = "master://sitecore/content/Klepierre/France/Arcades/Home/Events and News/News/sauve ton commerce"
# $BannerSource = "master:/sitecore/content/Klepierre/France/Arcades/Home/Banner Repository/Homepage Banner/solidarite entre voisins"
$Region = "France"
$version = "fr-FR"
$RegionRepository = "master:/sitecore/content/Klepierre/$Region"

$malls = Get-ChildItem -Path $RegionRepository | Where { $_.TemplateID -eq "{46591E02-8902-4C2C-AF61-3EB92BE2489A}" }

foreach ($mall in $malls) {
    $mallName = $mall.Name
    $NewsDestination = "master:/sitecore/content/Klepierre/$Region/$mallName/Home/Events and News/News/sauve ton commerce"
    # $NewsDestination = "master:/sitecore/content/Klepierre/$Region/$mallName/Home/Events and News/News/sauve ton commerce"
    # $BannerDestination = "master:/sitecore/content/Klepierre/$Region/$mallName/Home/Banner Repository/Homepage Banner/solidarite entre voisins"
    if (!($mallName -match "^Arcades") -and !($mallName -match "^Avenir") -and !($mallName -match "^Odysseum")) { #-and !($mallName -match "^Odysseum")
        if (!(Test-Path -Path $NewsDestination -ErrorAction SilentlyContinue)) {
            Write-Host "Adding for $mallName" -ForegroundColor Yellow
            Copy-Item -Path $NewsSource -Destination $NewsDestination
        }
        # if (!(Test-Path -Path $BannerDestination -ErrorAction SilentlyContinue)) {
        #     Copy-Item -Path $BannerSource -Destination $BannerDestination

        #     $NewsItem = Get-Item $NewsDestination -Language  $version
        #     $NewsID = $NewsItem.ID

        #     $BannerItem = Get-Item $BannerDestination -Language  $version

        #     $BannerItem.Editing.BeginEdit() | Out-Null
        #     $BannerItem["CTA Button"] = "<link text=`"`" anchor=`"`" linktype=`"internal`" class=`"`" title=`"`"  querystring=`"`" id=`"$NewsID`" />"
        #     # $BannerItem["Is Active"] = 0
        #     # $BannerItem["__Never publish"] = 1
        #     $BannerItem.Editing.EndEdit() | Out-Null
        # }
        
    }
    
}