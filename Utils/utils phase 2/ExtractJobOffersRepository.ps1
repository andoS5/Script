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
        $var = if (![string]::IsNullOrEmpty($ID)) {
            $var = Get-Item master: -ID $ID
            $listName = "$($var.Name)"
        }
        else {
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
function ExtractJobOffers {
    param (
        [Parameter(Mandatory = $true, Position = 0 )]
        [string]$RegionName,
        [Parameter(Mandatory = $true, Position = 1 )]
        [string]$MallName,
        [Parameter(Mandatory = $true, Position = 2 )]
        [string]$Language
    )

    process {
        $outputFilePath = "$($AppPath)/Job offers pages - $MallName.csv"
        $array = New-Object System.Collections.ArrayList

        $jobOffersRepository = "master:/sitecore/content/Klepierre/$RegionName/$MallName/Home/Job offers"
        $jobOffers = Get-Item -Path $jobOffersRepository -Language $Language

        $Breadcrumbtitle = $jobOffers['Breadcrumb title']
        $Showonbreadcrumb = $jobOffers['Show on breadcrumb']
        $BannerTitle = $jobOffers['Banner Title']
        $pageTitle = $jobOffers['Page Title']
        $MetaDescription = $jobOffers['Meta Description']

        $BackgroundImage = if (![string]::IsNullOrEmpty($jobOffers['Background Image'])) { Get-Name-By-ID (Get-Image-Item-Id $jobOffers['Background Image']) }else { "" }
        $LargeImage = if (![string]::IsNullOrEmpty($jobOffers['Large Image'])) { Get-Name-By-ID (Get-Image-Item-Id $jobOffers['Large Image']) }else { "" }
        $TabletImage = if (![string]::IsNullOrEmpty($jobOffers['Tablet Image'])) { Get-Name-By-ID (Get-Image-Item-Id $jobOffers['Tablet Image']) }else { "" }
        $MobileImage = if (![string]::IsNullOrEmpty($jobOffers['Mobile Image'])) { Get-Name-By-ID (Get-Image-Item-Id $jobOffers['Mobile Image']) }else { "" }
        $OpenGraphImage = if (![string]::IsNullOrEmpty($jobOffers['Open Graph Image'])) { Get-Name-By-ID (Get-Image-Item-Id $jobOffers['Open Graph Image']) }else { "" }

        $CanonicalUrl = $jobOffers['Canonical Url']
        $ShowonMobile = $jobOffers['Show on Mobile']

        $obj = New-Object System.Object
        $obj | Add-Member -MemberType NoteProperty -Name "Breadcrumbtitle"-Value $Breadcrumbtitle
        $obj | Add-Member -MemberType NoteProperty -Name "Showonbreadcrumb"-Value $Showonbreadcrumb
        $obj | Add-Member -MemberType NoteProperty -Name "BannerTitle"-Value $BannerTitle
        $obj | Add-Member -MemberType NoteProperty -Name "BackgroundImage"-Value $BackgroundImage
        $obj | Add-Member -MemberType NoteProperty -Name "LargeImage"-Value $LargeImage
        $obj | Add-Member -MemberType NoteProperty -Name "TabletImage"-Value $TabletImage
        $obj | Add-Member -MemberType NoteProperty -Name "MobileImage"-Value $MobileImage
        $obj | Add-Member -MemberType NoteProperty -Name "OpenGraphImage"-Value $OpenGraphImage
        $obj | Add-Member -MemberType NoteProperty -Name "CanonicalUrl"-Value $CanonicalUrl
        $obj | Add-Member -MemberType NoteProperty -Name "ShowonMobile"-Value $ShowonMobile
        $obj | Add-Member -MemberType NoteProperty -Name "pageTitle"-Value $pageTitle
        $obj | Add-Member -MemberType NoteProperty -Name "MetaDescription"-Value $MetaDescription

        $array.Add($obj) | Out-Null         
        Write-Host "[$($cpt)]  ---- done" -ForegroundColor Green
       

        $array | Select-Object Breadcrumbtitle, Showonbreadcrumb, BannerTitle, BackgroundImage, LargeImage, TabletImage, MobileImage, OpenGraphImage, CanonicalUrl, ShowonMobile,pageTitle,MetaDescription | Export-Csv -Encoding UTF8 -notypeinformation -Path $outputFilePath
        Try {
            Send-File -Path $outputFilePath
        }
        Finally {
            Remove-Item -Path $outputFilePath
        }

    }
    
}

$RegionName = "Denmark"
$MallName = "Fields"
$Language = "da"
ExtractJobOffers $RegionName $MallName $Language