function formatDateHour($RawValueDate) {
    if ($null -ne $RawValueDate -and $RawValueDate.Contains('T')) {
        return "$($RawValueDate.Substring(4,2))-$($RawValueDate.Substring(6,2))-$($RawValueDate.Substring(0,4)) $($RawValueDate.Substring(9,2)):$($RawValueDate.Substring(11,2))"
    }
}

function Get-Name-By-ID($ID) {
    $listId = $null
    $listName = $null
    if ($ID.Contains('|')) {
        $listId = $ID.split('|')
        foreach ($list in $listId) {
            if ($list.Trim() -ne $null -and $list.Contains("{")) {
                $var = Get-Item master: -ID $list
                $listName = "$($listName)|$($var.Name)".substring(1)
            }
        }
    }
    else {
        # $listId = $ID
        $var = if(![string]::IsNullOrEmpty($ID)){
            $var = Get-Item master: -ID $ID
            $listName = "$($var.Name)"
        }else{
            $listName = ""
        }
        
    }
    return $listName
}

function Get-Image-Item-Id {
    param (
        [Parameter(Mandatory = $true, Position = 0 )]
        [string]$RawValue
    )
    process {
        $ResultRegex = "(?<={)(.*)(?=})"

        $Regex = [Regex]::new("$ResultRegex")       
        $Result = $Regex.Match($RawValue)   
        if ($Result.Success) {           
            return "{$($Result.Value)}"         
        }
    }
}
function ExtractNews {

    param (
        [Parameter(Mandatory = $true, Position = 0 )]
        [string]$RegionName,
        [Parameter(Mandatory = $true, Position = 1 )]
        [string]$MallName,
        [Parameter(Mandatory = $true, Position = 2 )]
        [string]$Language
    )

    # $myFolder ="C:\Users\aramanam\Documents\WORKSPACE"
    $outputFilePath = "$($AppPath)/News - $MallName.csv"
    $array = New-Object System.Collections.ArrayList

    $EventsRepository = "master:/sitecore/content/Klepierre/$RegionName/$MallName/Home/Events and News/News"
    

    $NewsItem = Get-ChildItem -Path $EventsRepository -Language $Language | Where { $_.TemplateID -eq "{64476A1D-56A9-4525-95FB-569A19A69295}" -or $_.TemplateID -eq "{CD5164AE-FE0B-4A0B-BF3B-6DDEE8CFC3E9}" }
    $count = $NewsItem.Count
    $cpt = 1
    foreach ($News in $NewsItem) {

        $TemplateId = $News.TemplateID
        $brand = ""
        $NewsTilesmallImage = ""
        $IsLoginRequired = ""
        if ($News.TemplateID -eq "{CD5164AE-FE0B-4A0B-BF3B-6DDEE8CFC3E9}") {
            $brand = Get-Name-By-ID($News['Brands']) #if with brand
            $NewsTilesmallImage = if (![string]::IsNullOrEmpty($News['News tile small image'])) { Get-Name-By-ID (Get-Image-Item-Id $News['News tile small image']) }else { "" }    #if with brand
            $IsLoginRequired = $News['IsLoginRequired']
        }
        
        $BreadcrumbTitle = $News['Breadcrumb title']
        $Showonbreadcrumb = $News['Show on breadcrumb']
        $DisplayDealsCTA = $News['Display Deals CTA']
        $Script = $News['Script']
        $PlayLabel = $News['Play']
        $BannerTitle = $News['Banner Title']

        $LargeDesktopImage = if (![string]::IsNullOrEmpty($News['Background Image'])) { Get-Name-By-ID (Get-Image-Item-Id $News['Background Image']) }else { "" }  

        $DesktopImage = if (![string]::IsNullOrEmpty($News['Large Image'])) { Get-Name-By-ID (Get-Image-Item-Id $News['Large Image']) }else { "" }   
        $TabletImage = if (![string]::IsNullOrEmpty($News['Tablet Image'])) { Get-Name-By-ID (Get-Image-Item-Id $News['Tablet Image']) }else { "" }  
        $MobileImage = if (![string]::IsNullOrEmpty($News['Mobile Image'])) { Get-Name-By-ID (Get-Image-Item-Id $News['Mobile Image']) }else { "" }  
        $NewsTileLargeImage = if (![string]::IsNullOrEmpty($News['News tile large image'])) { Get-Name-By-ID (Get-Image-Item-Id $News['News tile large image']) }else { "" }  

        $NewsTitle = $News['Event title']
        $Description = $News['Abstract']
        $FirstTitleNews = $News['First Title Event']
        $FirstDescriptionNews = $News['First Description Event']
        $FirstImage = $News['First Image']
        $SecondTitleNews = $News['Second Title Event']
        $SecondDescriptionNews = $News['Second Description']
        $SecondImage = $News['Second Image']
        $SeeMoreCTA = $News['See More CTA']
        $CanonicalURL = $News['Canonical Url']
        $OpenGraphImage = if (![string]::IsNullOrEmpty($News['Open Graph Image'])) { Get-Name-By-ID (Get-Image-Item-Id $News['Open Graph Image']) }else { "" }  
        $ShowonMobile = $News['Show on Mobile']


        $obj = New-Object System.Object

        $obj | Add-Member -MemberType NoteProperty -Name "TemplateId"-Value $TemplateId
        $obj | Add-Member -MemberType NoteProperty -Name "Brand"-Value $brand
        $obj | Add-Member -MemberType NoteProperty -Name "BreadcrumbTitle"-Value $BreadcrumbTitle
        $obj | Add-Member -MemberType NoteProperty -Name "Showonbreadcrumb"-Value $Showonbreadcrumb
        $obj | Add-Member -MemberType NoteProperty -Name "DisplayDealsCTA"-Value $DisplayDealsCTA
        $obj | Add-Member -MemberType NoteProperty -Name "Script"-Value $Script
        $obj | Add-Member -MemberType NoteProperty -Name "PlayLabel"-Value $PlayLabel
        $obj | Add-Member -MemberType NoteProperty -Name "IsLoginRequired"-Value $IsLoginRequired #ampiana refa le temp mavo
        $obj | Add-Member -MemberType NoteProperty -Name "BannerTitle"-Value $BannerTitle
        $obj | Add-Member -MemberType NoteProperty -Name "LargeDesktopImage"-Value $LargeDesktopImage
        $obj | Add-Member -MemberType NoteProperty -Name "DesktopImage"-Value $DesktopImage
        $obj | Add-Member -MemberType NoteProperty -Name "TabletImage"-Value $TabletImage
        $obj | Add-Member -MemberType NoteProperty -Name "MobileImage"-Value $MobileImage
        $obj | Add-Member -MemberType NoteProperty -Name "NewsTileLargeImage"-Value $NewsTileLargeImage
        $obj | Add-Member -MemberType NoteProperty -Name "NewsTilesmallImage"-Value $NewsTilesmallImage
        $obj | Add-Member -MemberType NoteProperty -Name "NewsTitle"-Value $NewsTitle
        $obj | Add-Member -MemberType NoteProperty -Name "Description"-Value $Description
        $obj | Add-Member -MemberType NoteProperty -Name "FirstTitleNews"-Value $FirstTitleNews
        $obj | Add-Member -MemberType NoteProperty -Name "FirstDescriptionNews"-Value $FirstDescriptionNews
        $obj | Add-Member -MemberType NoteProperty -Name "FirstImage"-Value $FirstImage
        $obj | Add-Member -MemberType NoteProperty -Name "SecondTitleNews"-Value $SecondTitleNews
        $obj | Add-Member -MemberType NoteProperty -Name "SecondDescriptionNews"-Value $SecondDescriptionNews
        $obj | Add-Member -MemberType NoteProperty -Name "SecondImage"-Value $SecondImage
        $obj | Add-Member -MemberType NoteProperty -Name "SeeMoreCTA"-Value $SeeMoreCTA
        $obj | Add-Member -MemberType NoteProperty -Name "CanonicalURL"-Value $CanonicalURL
        $obj | Add-Member -MemberType NoteProperty -Name "OpenGraphImage"-Value $OpenGraphImage
        $obj | Add-Member -MemberType NoteProperty -Name "ShowonMobile"-Value $ShowonMobile


        $array.Add($obj) | Out-Null
            
        Write-Host "[$($cpt)/$($count)]  ---- done" -ForegroundColor Green
        $cpt ++;
        
    }
    $array | Select-Object TemplateId, Brand, BreadcrumbTitle, Showonbreadcrumb, DisplayDealsCTA, Script, PlayLabel,IsLoginRequired, BannerTitle, LargeDesktopImage, DesktopImage, TabletImage,	MobileImage, NewsTileLargeImage, NewsTilesmallImage, NewsTitle,	Description, FirstTitleNews, FirstDescriptionNews, FirstImage, SecondTitleNews, SecondDescriptionNews, SecondImage, SeeMoreCTA, CanonicalURL, OpenGraphImage, ShowonMobile | Export-Csv -Encoding UTF8 -notypeinformation -Path $outputFilePath
    Try {
        Send-File -Path $outputFilePath
    }
    Finally {
        Remove-Item -Path $outputFilePath
    }

}


$RegionName = "France"
$MallName = "Odysseum"
$Language = "fr-fr"
ExtractNews $RegionName $MallName $Language