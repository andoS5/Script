function dowloadImage {
    param(
        [Parameter(Mandatory)]
        [string]$ImgUrl,
        [Parameter(Mandatory)]
        [string]$OutPath,
        [Parameter(Mandatory)]
        [string]$folderName
    )

    process {
        
        $imageNameSplited = $ImgUrl.Split("/")
        $imageName = $imageNameSplited[$imageNameSplited.Count - 1]

        #Output
        $outputPath = "$OutPath/$folderName"
        if (!(Test-Path $outputPath -ErrorAction SilentlyContinue)) {

            New-Item -ItemType Directory -Force -Path $outputPath

            $WebClient = New-Object System.Net.WebClient
            $WebClient.DownloadFile($ImgUrl, "$outputPath/$imageName")
        }
        else {
            
            $WebClient = New-Object System.Net.WebClient
            $WebClient.DownloadFile($ImgUrl, "$outputPath/$imageName")
        }
        return $imageName
    }
}

function ScrapWebElementByStringTag {
    param(
        [Parameter(Mandatory)]
        $HTMLContent,
        [Parameter(Mandatory)]
        [string]$Pattern,
        [Parameter(Mandatory)]
        [string]$ResultRegex,
        [Parameter(Mandatory)]
        [string]$ResultName
    )

    Begin {
        Write-Host "Starting Scrapping $ResultName" -ForegroundColor Yellow
    }
       
    Process {
        $RawResult = ([regex]$Pattern).Matches($HTMLContent)
        $Regex = [Regex]::new("$ResultRegex")       
        $Result = $Regex.Match($RawResult)           
        if ($Result.Success) {           
            return $Result.Value           
        }
    }
}
function scrapAngouleme {


    $URLS = @(
        "https://www.ccchampdemars.com/boutique/cosmo-kids/",
        "https://www.ccchampdemars.com/boutique/armand-thiery/",
        "https://www.ccchampdemars.com/boutique/cosmopolite/",
        "https://www.ccchampdemars.com/boutique/cyrillus/",
        "https://www.ccchampdemars.com/boutique/centre-information-jeunesse/",
        "https://www.ccchampdemars.com/boutique/camaieu/",
        "https://www.ccchampdemars.com/boutique/agence-mobilite/",
        "https://www.ccchampdemars.com/boutique/bershka/",
        "https://www.ccchampdemars.com/boutique-categorie/mode-homme/",
        "https://www.ccchampdemars.com/boutique/familly-bulle/",
        "https://www.ccchampdemars.com/boutique/naf-naf/",
        "https://www.ccchampdemars.com/boutique/sephora/",
        "https://www.ccchampdemars.com/boutique/maroquinerie-collin/",
        "https://www.ccchampdemars.com/boutique/zara/",
        "https://www.ccchampdemars.com/boutique/hm/",
        "https://www.ccchampdemars.com/boutique/jott/",
        "https://www.ccchampdemars.com/boutique/serge_blanco/",
        "https://www.ccchampdemars.com/boutique/grain-de-malice/",
        "https://www.ccchampdemars.com/boutique/la-pharmacie-joubert/",
        "https://www.ccchampdemars.com/boutique/mango/",
        "https://www.ccchampdemars.com/boutique/les-nouveaux-bijoutiers/",
        "https://www.ccchampdemars.com/boutique/grand-optical/",
        "https://www.ccchampdemars.com/boutique/jd/",
        "https://www.ccchampdemars.com/boutique/ip-store/",
        "https://www.ccchampdemars.com/boutique/darjeeling/",
        "https://www.ccchampdemars.com/boutique-categorie/services/",
        "https://www.ccchampdemars.com/boutique/omalo/",
        "https://www.ccchampdemars.com/boutique/pull-and-bear/",
        "https://www.ccchampdemars.com/boutique/photomaton/",
        "https://www.ccchampdemars.com/boutique/quiksilver/",
        "https://www.ccchampdemars.com/boutique-categorie/culture-loisirs/",
        "https://www.ccchampdemars.com/boutique/la-croissanterie/"



    )

    $Count = $URLS.Count
    $cpt = 1
    $date = Get-Date
    $fileTime = $date.ToFileTime()
    $outputFilePath = "C:\Users\aramanam\Documents\Scrapping/Angouleme-$fileTime.csv"
    $array = New-Object System.Collections.ArrayList
    $OutPath = "C:\Users\aramanam\Documents\Scrapping"

    foreach ($url in $URLS) {
        $IE = new-object -com internetexplorer.application
        $IE.navigate2($url)
        $IE.visible = $false
        while ($ie.ReadyState -ne 4) { start-sleep -m 100 }
        
        #description
        $description = ""
        $ie.document.getElementsByClassName("woocommerce-product-details__short-description") | ForEach-Object {
            $description = $_.innerhtml
        }

        
        #category
        $ie.document.getElementsByClassName("posted_in") | ForEach-Object {
            #%{Write-Host $_.innerhtml
            $rawCateg = $_.innerhtml
        }
        $category = ""
        $Regex = [Regex]::new('(?<=>)(.*)(?=<)')       
        $Result = $Regex.Match($rawCateg)   
        if ($Result.Success) {           
            $category = $Result.Value           
        }


        $ImgUrl = ""
        $ie.document.getElementsByClassName("woocommerce-product-gallery__image") | ForEach-Object {
            $img = $_.innerhtml
        }
    
        $ImgUrl = if ($img) { ((Select-String '(http[s]?)(:\/\/)([^\s,]+)(?=")' -Input $img).Matches.Value) } else { "" }

        #canonical url
        $HTML = Invoke-WebRequest $url -UseBasicParsing
        $HTMLContent = $HTML.Content
        $CanonicalPattern = '<link rel="canonical" href="(?<quote>.*)" />'
        $CanonicalResultRegex = '(?<=canonical" href=")(.*)(?=" />)'
        $CanonicalResultName = "Canonical URL"
        $canonicalUrl = ScrapWebElementByStringTag $HTMLContent $CanonicalPattern $CanonicalResultRegex $CanonicalResultName


        $folderName = "Angouleme"
        $image = dowloadImage $ImgUrl $OutPath $folderName #download

        $obj = New-Object System.Object

        $obj | Add-Member -MemberType NoteProperty -Name "URL" -Value  $url
        $obj | Add-Member -MemberType NoteProperty -Name "Type" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "Breadcrumbtitle" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "Showonbreadcrumb" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "PageDesign" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "BannerTitle" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "BackgroundImage" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "LargeImage" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "MobileImage" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "TabletImage" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "ShopOrRestaurantImage" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "ShopOrRestaurantTitle" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "Description" -Value  $description
        $obj | Add-Member -MemberType NoteProperty -Name "Contact" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "Playfull" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "Brand" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "OpeningDate" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "popUp" -Value   ""
        $obj | Add-Member -MemberType NoteProperty -Name "Parking" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "Gate"     -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "Category" -Value  $category
        $obj | Add-Member -MemberType NoteProperty -Name "SubCategory" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "canonicalUrl" -Value  $canonicalUrl
        $obj | Add-Member -MemberType NoteProperty -Name "Services" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "OpenGraphImage" -Value  $image
        $obj | Add-Member -MemberType NoteProperty -Name "placeId" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "placeAlias" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "ShowOnMobile" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "FacebookUrl" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "TwitterUrl" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "InstagramUrl" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "StoreWebsiteUrl" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "MondayOpening" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "MondayClosing" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "isClosedMonday" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "TuesdayOpening" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "TuesdayClosing" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "isClosedTuesday" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "WednesdayOpening" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "WednesdayClosing" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "isClosedWednesday" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "ThursdayOpening" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "ThursdayClosing" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "isClosedThursday" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "FridayOpening" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "FridayClosing" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "isClosedFriday" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "SaturdayOpening" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "SaturdayClosing" -Value ""
        $obj | Add-Member -MemberType NoteProperty -Name "isClosedSaturday" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "SundayOpening" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "SundayClosing" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "isClosedSunday" -Value  ""

        $array.Add($obj) | Out-Null
        Write-Host "[$($cpt)/$($count)] $url ---- done" -ForegroundColor Green
        $cpt ++
        $IE.Quit()
        [System.Runtime.Interopservices.Marshal]::ReleaseComObject($ie) | Out-Null
        [System.GC]::Collect()
        [System.GC]::WaitForPendingFinalizers()
    }
    $array | Select-Object URL, Type, Breadcrumbtitle, Showonbreadcrumb, PageDesign, BannerTitle, BackgroundImage, LargeImage , MobileImage, TabletImage, ShopOrRestaurantImage, ShopOrRestaurantTitle, Description, Contact, Playfull, Brand, OpeningDate, popUp, Parking, Gate, Category, SubCategory, Services, canonicalUrl, OpenGraphImage, placeId, placeAlias, ShowOnMobile, FacebookUrl, TwitterUrl, InstagramUrl, StoreWebsiteUrl, MondayOpening, MondayClosing, isClosedMonday, TuesdayOpening, TuesdayClosing, isClosedTuesday, WednesdayOpening, WednesdayClosing, isClosedWednesday, ThursdayOpening, ThursdayClosing, isClosedThursday, FridayOpening, FridayClosing, isClosedFriday, SaturdayOpening, SaturdayClosing, isClosedSaturday, SundayOpening, SundayClosing, isClosedSunday | Export-Csv -Encoding UTF8 -notypeinformation -Path $outputFilePath


    
}

    


cls
scrapAngouleme