
# Import-Function -Name "dowloadImage"
# Import-Function -Name "Extract-Open-Close-Hours"
# Import-Function -Name "ScrapWebElementByStringTag"
function Utils-Convert-PSObject-To-Hashtable {
    [CmdletBinding()]
    param (
        [Parameter(ValueFromPipeline)]
        $InputObject
    )
      
    begin {
        #Write-Host "Cmdlet Utils-Convert-PSObject-To-Hashtable - Begin"
    }
  
    process {
        if ($null -eq $InputObject) { return $null }
  
        if ($InputObject -is [System.Collections.IEnumerable] -and $InputObject -isnot [string]) {
            $collection = @(
                foreach ($object in $InputObject) { Utils-Convert-PSObject-To-Hashtable $object }
            )
  
            #Write-Output -NoEnumerate $collection
            $collection
        }
        elseif ($InputObject -is [psobject]) {
            $hash = @{ }
  
            foreach ($property in $InputObject.PSObject.Properties) {
                $hash[$property.Name] = Utils-Convert-PSObject-To-Hashtable $property.Value
            }
  
            $hash
        }
        else {
            $InputObject
        }
    }
      
    end {
        #Write-Host "Cmdlet Utils-Convert-PSObject-To-Hashtable - End"
    }
}
  
function Utils-Upload-CSV-File {
    param(
        [Parameter(Mandatory = $false)]
        [string]$title,
        [Parameter(Mandatory = $false)]
        [string]$delimiter = ",",
        [Parameter(Mandatory = $false)]
        [string]$description
    )
    $dataFolder = [Sitecore.Configuration.Settings]::DataFolder
    $tempFolder = $dataFolder + "\temp\upload"
    $filePath1 = Receive-File -Path $tempFolder -overwrite -Title $title -Description $description
    if (!(Test-Path -Path $filePath1 -ErrorAction SilentlyContinue)) {
        Write-Host "Canceled"
        Exit
    }
    $fileCSV = Import-Csv -Delimiter $delimiter  $filePath1
    $CSVToHash = Utils-Convert-PSObject-To-Hashtable $fileCSV
      
    return $CSVToHash
}

function ScrapDescription {
    param(
        [Parameter(Mandatory = $true, Position = 0 )]
        [string]$HTMLContent
    )

    process {
        $pattern = '<p>(.|\n)*?<\/p>'
        $ResultRegex = '^<p>((?!<a|<img).|\n)*<\/p>'
        $match = [regex]::Matches($HTMLContent, $pattern) | Select-Object -ExpandProperty Value
        $description = ""
        foreach ($m in $match) {
            $result = [regex]::Matches($m, $ResultRegex)
            if ($result.Success) {
                $description += $result.Value
            }
        }
        return $description -Replace 'class="(?<quote>.*")', ""
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
        try {
            if (!(Test-Path $outputPath -ErrorAction SilentlyContinue)) {

                New-Item -ItemType Directory -Force -Path $outputPath
    
                $WebClient = New-Object System.Net.WebClient
                $WebClient.DownloadFile($ImgUrl, "$outputPath/$imageName")
            }
            else {
                
                $WebClient = New-Object System.Net.WebClient
                $WebClient.DownloadFile($ImgUrl, "$outputPath/$imageName")
    
            }
            return $true
        }
        catch {
            return $false
        }
        

    }
}

function Extract-Open-Close-Hours {
    param(
        [Parameter(Mandatory = $true, Position = 0 )]
        [string]$string
    )
    $usefulText = $string.Substring($string.IndexOf("de") + 2)
    $openingHourText = $usefulText -replace '\s', ''
    return $openingHourText.Split("à")
    
}
function ScrappingShop {
    

    $URLS = @(
        "http://www.centremayol.com/magasins/histoire-dor/",
        "http://www.centremayol.com/magasins/la-boutique-du-coiffeur/",
        "http://www.centremayol.com/magasins/marc-orian/",
        "http://www.centremayol.com/magasins/mode-femme/",
        "http://www.centremayol.com/magasins/pandora/",
        "http://www.centremayol.com/magasins/rituals/",
        "http://www.centremayol.com/magasins/sephora/",
        "http://www.centremayol.com/magasins/tresor/",
        "https://www.centremayol.com/magasins/action/",
        "https://www.centremayol.com/magasins/adopt/",
        "https://www.centremayol.com/magasins/amazon-locker/",
        "https://www.centremayol.com/magasins/asie-fast-food/",
        "https://www.centremayol.com/magasins/atlantic/",
        "https://www.centremayol.com/magasins/autour-de-la-vape/",
        "https://www.centremayol.com/magasins/biotech/",
        "https://www.centremayol.com/magasins/bleu-cerise/",
        "https://www.centremayol.com/magasins/body-minute/",
        "https://www.centremayol.com/magasins/bonobo/",
        "https://www.centremayol.com/magasins/bouygues/",
        "https://www.centremayol.com/magasins/brioche-doree/",
        "https://www.centremayol.com/magasins/burger-king/",
        "https://www.centremayol.com/magasins/burton-of-london/",
        "https://www.centremayol.com/magasins/ca/",
        "https://www.centremayol.com/magasins/calzedonia/",
        "https://www.centremayol.com/magasins/carrefour/",
        "https://www.centremayol.com/magasins/celio/",
        "https://www.centremayol.com/magasins/claires/",
        "https://www.centremayol.com/magasins/comptoir-des-cotonniers/",
        "https://www.centremayol.com/magasins/courir/",
        "https://www.centremayol.com/magasins/darjeeling/",
        "https://www.centremayol.com/magasins/depil-tech/",
        "https://www.centremayol.com/magasins/devred/",
        "https://www.centremayol.com/magasins/du-pareil-au-meme/",
        "https://www.centremayol.com/magasins/espace-sfr/",
        "https://www.centremayol.com/magasins/etam-lingerie/",
        "https://www.centremayol.com/magasins/fitness-park/",
        "https://www.centremayol.com/magasins/fnac/",
        "https://www.centremayol.com/magasins/free/",
        "https://www.centremayol.com/magasins/generale-doptique/",
        "https://www.centremayol.com/magasins/go-sport/",
        "https://www.centremayol.com/magasins/grain-de-malice/",
        "https://www.centremayol.com/magasins/grandoptical/",
        "https://www.centremayol.com/magasins/innovaclean/",
        "https://www.centremayol.com/magasins/jcp/",
        "https://www.centremayol.com/magasins/jd-sports/",
        "https://www.centremayol.com/magasins/jean-louis-david/",
        "https://www.centremayol.com/magasins/jeff-de-bruges/",
        "https://www.centremayol.com/magasins/jemk/",
        "https://www.centremayol.com/magasins/jm/",
        "https://www.centremayol.com/magasins/kiko/",
        "https://www.centremayol.com/magasins/la-barbe-de-papa/",
        "https://www.centremayol.com/magasins/la-piadina/",
        "https://www.centremayol.com/magasins/la-royale/",
        "https://www.centremayol.com/magasins/le-kudeta/",
        "https://www.centremayol.com/magasins/le-salon/",
        "https://www.centremayol.com/magasins/louis-pion/",
        "https://www.centremayol.com/magasins/manege/",
        "https://www.centremayol.com/magasins/mangos/",
        "https://www.centremayol.com/magasins/master-case/",
        "https://www.centremayol.com/magasins/mayoloto/",
        "https://www.centremayol.com/magasins/mcdonalds/",
        "https://www.centremayol.com/magasins/micromania/",
        "https://www.centremayol.com/magasins/misako/",
        "https://www.centremayol.com/magasins/morgan/",
        "https://www.centremayol.com/magasins/nocibe-parfumerie/",
        "https://www.centremayol.com/magasins/okaidi/",
        "https://www.centremayol.com/magasins/olly-gan/",
        "https://www.centremayol.com/magasins/optic-2000/",
        "https://www.centremayol.com/magasins/orange/",
        "https://www.centremayol.com/magasins/oxbow/",
        "https://www.centremayol.com/magasins/pascal-coste/",
        "https://www.centremayol.com/magasins/paul/",
        "https://www.centremayol.com/magasins/petit-bateau/",
        "https://www.centremayol.com/magasins/pharmacie-mayol/",
        "https://www.centremayol.com/magasins/photomaton/",
        "https://www.centremayol.com/magasins/pimkie/",
        "https://www.centremayol.com/magasins/promovacances/",
        "https://www.centremayol.com/magasins/rct-cafe/",
        "https://www.centremayol.com/magasins/rct-store/",
        "https://www.centremayol.com/magasins/riu-paris/",
        "https://www.centremayol.com/magasins/san-marina/",
        "https://www.centremayol.com/magasins/sergent-major/",
        "https://www.centremayol.com/magasins/twenty-nails/",
        "https://www.centremayol.com/magasins/undiz/",
        "https://www.centremayol.com/magasins/waffle-factory/",
        "https://www.centremayol.com/magasins/wefix/",
        "https://www.centremayol.com/magasins/yves-rocher/",
        "https://www.centremayol.com/magasins/zara/"


    )
    $Count = $URLS.Count
    $cpt = 1
    $date = Get-Date
    $fileTime = $date.ToFileTime()
    $outputFilePath = "C:\Users\aramanam\Documents\Scrapping/mayol-$fileTime.csv"
    $array = New-Object System.Collections.ArrayList
    $OutPath = "C:\Users\aramanam\Documents\Scrapping"
    foreach ($url in $URLS) {
        # $siteUrl = "https://www.centremayol.com/magasins/depil-tech/"
        # $siteUrl = $url["url"]
        $HTML = Invoke-WebRequest $url -UseBasicParsing
        $HTMLContent = $HTML.Content

    
        
    

        $Pattern = 'style="color: #000000;">(?<quote>.*</)'
        $OCResultRegex = "(?<=>)(.*)(?=<)"
        $ResultName = "Opening Hours"
        $openingAndClosingText = ScrapWebElementByStringTag $HTMLContent $Pattern $OCResultRegex $ResultName
        $OCH = Extract-Open-Close-Hours $openingAndClosingText
        $openingHour = $OCH[0] -replace 'h', ':'
        $closingHour = $OCH[1] -replace 'h', ':'

        # Write-Host " Open : $openingHour - Close : $closingHour"
        # Write-Host " "

        $description = ScrapDescription $HTMLContent
        # Write-Host "description = " $description
        # Write-Host " "

        $ContactPattern = '<span style="color: #000000; font-size: 14px;">(?<quote>.*)<br />'
        $ContactResultRegex = "(?<=>)(.*)(?=<)"
        $ContactResultName = "Contact"
        $contact = ScrapWebElementByStringTag $HTMLContent $ContactPattern $ContactResultRegex $ContactResultName
        # Write-Host "Contact = "$contact
        # Write-Host " "

        $CanonicalPattern = '<link rel="canonical" href="(?<quote>.*)" />'
        $CanonicalResultRegex = '(?<=canonical" href=")(.*)(?=" />)'
        $CanonicalResultName = "Canonical URL"
        $canonicalUrl = ScrapWebElementByStringTag $HTMLContent $CanonicalPattern $CanonicalResultRegex $CanonicalResultName
        # Write-Host "Canonical Url = " $canonicalUrl
        # Write-Host " "
    
        $SitePattern = '</span><a href="(?<quote>.*)/"'
        $siteResultRegex = '(?<=href=")(.*)(?=/")'
        $siteResultName = "Store Website Url"
        $sitewebUrl = ScrapWebElementByStringTag $HTMLContent $SitePattern $siteResultRegex $siteResultName
        # Write-Host "Store Website Url = "$sitewebUrl
        # Write-Host " "
    
        $OgPattern = '<meta property="og:image" content="(?<quote>.*)" />'
        $OgResultRegex = '(?<=content=")(.*)(?=" />)'
        $OgResultName = "Open graph image URL"
        $openGraphImageUrl = ScrapWebElementByStringTag $HTMLContent $OgPattern $OgResultRegex $OgResultName
        
        $folderName = "Og image"
        $openGraphImage = dowloadImage $openGraphImageUrl $OutPath $folderName #download
        $opengraphImageName = ""
        if ($openGraphImage) {
            $imageNameSplited = $openGraphImageUrl.Split("/")
            $opengraphImageName = $imageNameSplited[$imageNameSplited.Count - 1]
        }
        

        $folderName = "logo image"
        $logoImage = dowloadImage $openGraphImageUrl $OutPath $folderName #download
    
        $boxPattern = 'vc_box_shadow_border  vc_box_border_grey"><img class="vc_single_image-img " src="(?<quote>.*)" width'
        $boxResultRegex = '(?<=src=")(.*)(?=" width)'
        $boxResultName = "Description image"
        $boxFolderName = "Description image"
        $descriptionImageUrl = ScrapWebElementByStringTag $HTMLContent $boxPattern $boxResultRegex $boxResultName
        $boximgUrl = (Select-String '(http[s]?)(:\/\/)([^\s,]+)(?=")' -Input $descriptionImageUrl).Matches.Value
        $ImagedescriptionURL = ""
        
        if (![string]::IsNullOrEmpty($boximgUrl)) {
            $ImagedescriptionURL = $boximgUrl
        }
        else {
            $ImagedescriptionURL = $descriptionImageUrl
        }

        # $descimageNameSplited = $ImagedescriptionURL.Split("/")
        $descImageName = ""# $descimageNameSplited[$descimageNameSplited.Count - 1]

        # $descriptionImage = dowloadImage $ImagedescriptionURL $OutPath $boxFolderName #download

        $obj = New-Object System.Object

        $obj | Add-Member -MemberType NoteProperty -Name "Breadcrumbtitle" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "Showonbreadcrumb" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "PageDesign" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "BannerTitle" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "BackgroundImage" -Value  $descImageName
        $obj | Add-Member -MemberType NoteProperty -Name "LargeImage" -Value  $descImageName
        $obj | Add-Member -MemberType NoteProperty -Name "MobileImage" -Value  $descImageName
        $obj | Add-Member -MemberType NoteProperty -Name "TabletImage" -Value  $descImageName
        $obj | Add-Member -MemberType NoteProperty -Name "ShopOrRestaurantImage" -Value  $descImageName
        $obj | Add-Member -MemberType NoteProperty -Name "ShopOrRestaurantTitle" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "Description" -Value  $description
        $obj | Add-Member -MemberType NoteProperty -Name "Contact" -Value  $contact
        $obj | Add-Member -MemberType NoteProperty -Name "Playfull" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "Brand" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "OpeningDate" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "popUp" -Value   ""
        $obj | Add-Member -MemberType NoteProperty -Name "Parking" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "Gate"     -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "Category" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "SubCategory" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "canonicalUrl" -Value  $canonicalUrl
        $obj | Add-Member -MemberType NoteProperty -Name "Services" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "OpenGraphImage" -Value  $opengraphImageName
        $obj | Add-Member -MemberType NoteProperty -Name "placeId" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "placeAlias" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "ShowOnMobile" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "FacebookUrl" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "TwitterUrl" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "InstagramUrl" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "StoreWebsiteUrl" -Value  $sitewebUrl
        $obj | Add-Member -MemberType NoteProperty -Name "MondayOpening" -Value  $openingHour
        $obj | Add-Member -MemberType NoteProperty -Name "MondayClosing" -Value  $closingHour
        $obj | Add-Member -MemberType NoteProperty -Name "isClosedMonday" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "TuesdayOpening" -Value  $openingHour
        $obj | Add-Member -MemberType NoteProperty -Name "TuesdayClosing" -Value  $closingHour
        $obj | Add-Member -MemberType NoteProperty -Name "isClosedTuesday" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "WednesdayOpening" -Value  $openingHour
        $obj | Add-Member -MemberType NoteProperty -Name "WednesdayClosing" -Value  $closingHour
        $obj | Add-Member -MemberType NoteProperty -Name "isClosedWednesday" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "ThursdayOpening" -Value  $openingHour
        $obj | Add-Member -MemberType NoteProperty -Name "ThursdayClosing" -Value  $closingHour
        $obj | Add-Member -MemberType NoteProperty -Name "isClosedThursday" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "FridayOpening" -Value  $openingHour
        $obj | Add-Member -MemberType NoteProperty -Name "FridayClosing" -Value  $closingHour
        $obj | Add-Member -MemberType NoteProperty -Name "isClosedFriday" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "SaturdayOpening" -Value  $openingHour
        $obj | Add-Member -MemberType NoteProperty -Name "SaturdayClosing" -Value  $closingHour
        $obj | Add-Member -MemberType NoteProperty -Name "isClosedSaturday" -Value  ""
        $obj | Add-Member -MemberType NoteProperty -Name "SundayOpening" -Value  $openingHour
        $obj | Add-Member -MemberType NoteProperty -Name "SundayClosing" -Value  $closingHour
        $obj | Add-Member -MemberType NoteProperty -Name "isClosedSunday" -Value  ""

        $array.Add($obj) | Out-Null
        Write-Host "[$($cpt)/$($count)] $url ---- done" -ForegroundColor Green
        $cpt ++
    }
    $array | Select-Object Breadcrumbtitle, Showonbreadcrumb, PageDesign, BannerTitle, BackgroundImage, LargeImage , MobileImage, TabletImage, ShopOrRestaurantImage, ShopOrRestaurantTitle, Description, Contact, Playfull, Brand, OpeningDate, popUp, Parking, Gate, Category, SubCategory, Services, canonicalUrl, OpenGraphImage, placeId, placeAlias, ShowOnMobile, FacebookUrl, TwitterUrl, InstagramUrl, StoreWebsiteUrl, MondayOpening, MondayClosing, isClosedMonday, TuesdayOpening, TuesdayClosing, isClosedTuesday, WednesdayOpening, WednesdayClosing, isClosedWednesday, ThursdayOpening, ThursdayClosing, isClosedThursday, FridayOpening, FridayClosing, isClosedFriday, SaturdayOpening, SaturdayClosing, isClosedSaturday, SundayOpening, SundayClosing, isClosedSunday | Export-Csv -Encoding UTF8 -notypeinformation -Path $outputFilePath

}

cls
ScrappingShop