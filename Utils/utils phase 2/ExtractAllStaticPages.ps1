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
function ExtractAllStaticPages {
    param (
        [Parameter(Mandatory = $true, Position = 0 )]
        [string]$RegionName,
        [Parameter(Mandatory = $true, Position = 1 )]
        [string]$MallName,
        [Parameter(Mandatory = $true, Position = 2 )]
        [string]$Language
    )

    process {
        $outputFilePath = "$($AppPath)/Deals pages - $MallName.csv"
        $array = New-Object System.Collections.ArrayList
        $cpt = 1

        $StaticPagesRepository = "master:/sitecore/content/Klepierre/$RegionName/$MallName/Home/Static Pages Repository"
        $staticPages = Get-ChildItem -Path $StaticPagesRepository -Language $Language | Where { $_.TemplateID -eq "{2662003A-1138-4790-A109-24335392765F}" }
        $count = $staticPages.Count

        foreach ($staticPage in $staticPages) {
            $PageName = $staticPage.Name
            $BodyText = $staticPage['Body Text']
            $BannerTitle = $staticPage['Banner Title']

            $BackgroundImage = if (![string]::IsNullOrEmpty($staticPage['Background Image'])) { Get-Name-By-ID (Get-Image-Item-Id $staticPage['Background Image']) }else { "" } 
            $LargeImage = if (![string]::IsNullOrEmpty($staticPage['Large Image'])) { Get-Name-By-ID (Get-Image-Item-Id $staticPage['Large Image']) }else { "" } 
            $MobileImage = if (![string]::IsNullOrEmpty($staticPage['Mobile Image'])) { Get-Name-By-ID (Get-Image-Item-Id $staticPage['Mobile Image']) }else { "" } 
            $TabletImage = if (![string]::IsNullOrEmpty($staticPage['Tablet Image'])) { Get-Name-By-ID (Get-Image-Item-Id $staticPage['Tablet Image']) }else { "" } 

            $ButtonLinkOne = if (![string]::IsNullOrEmpty($staticPage['Button Link One'])) { Get-Name-By-ID (Get-Image-Item-Id $staticPage['Button Link One']) }else { "" } 
            $ButtonActivationOne =  $staticPage['Button Activation One']
            $ButtonLinkTwo = if (![string]::IsNullOrEmpty($staticPage['Button Link Two'])) { Get-Name-By-ID (Get-Image-Item-Id $staticPage['Button Link Two']) }else { "" } 
            $ButtonActivationTwo = $staticPage['Button Activation Two']
            $CanonicalUrl = $staticPage['Canonical Url']
            $ShowonMobile = $staticPage['Show on Mobile']
            $OpenGraphImage = if (![string]::IsNullOrEmpty($staticPage['Open Graph Image'])) { Get-Name-By-ID (Get-Image-Item-Id $staticPage['Open Graph Image']) }else { "" }  

            $obj = New-Object System.Object

            $obj | Add-Member -MemberType NoteProperty -Name "PageName"-Value $PageName
            $obj | Add-Member -MemberType NoteProperty -Name "BodyText"-Value $BodyText
            $obj | Add-Member -MemberType NoteProperty -Name "BannerTitle"-Value $BannerTitle
            $obj | Add-Member -MemberType NoteProperty -Name "BackgroundImage"-Value $BackgroundImage
            $obj | Add-Member -MemberType NoteProperty -Name "LargeImage"-Value $LargeImage
            $obj | Add-Member -MemberType NoteProperty -Name "MobileImage"-Value $MobileImage
            $obj | Add-Member -MemberType NoteProperty -Name "TabletImage"-Value $TabletImage
            $obj | Add-Member -MemberType NoteProperty -Name "ButtonLinkOne"-Value $ButtonLinkOne
            $obj | Add-Member -MemberType NoteProperty -Name "ButtonActivationOne"-Value $ButtonActivationOne
            $obj | Add-Member -MemberType NoteProperty -Name "ButtonLinkTwo"-Value $ButtonLinkTwo
            $obj | Add-Member -MemberType NoteProperty -Name "ButtonActivationTwo"-Value $ButtonActivationTwo
            $obj | Add-Member -MemberType NoteProperty -Name "CanonicalUrl"-Value $CanonicalUrl
            $obj | Add-Member -MemberType NoteProperty -Name "ShowonMobile"-Value $ShowonMobile
            $obj | Add-Member -MemberType NoteProperty -Name "OpenGraphImage"-Value $OpenGraphImage

            $array.Add($obj) | Out-Null         
            Write-Host "[$($cpt)/$($count)]  ---- done" -ForegroundColor Green
            $cpt ++;

        }
        $array | Select-Object pageName, BodyText,BannerTitle,BackgroundImage,LargeImage,MobileImage,TabletImage,ButtonLinkOne,ButtonActivationOne,ButtonLinkTwo,ButtonActivationTwo,CanonicalUrl,ShowonMobile,OpenGraphImage | Export-Csv -Encoding UTF8 -notypeinformation -Path $outputFilePath
        Try {
            Send-File -Path $outputFilePath
        }
        Finally {
            Remove-Item -Path $outputFilePath
        }

    }
}

$RegionName = "France"
$MallName = "RivesDarcins"
$Language = "fr-fr"
ExtractAllStaticPages $RegionName $MallName $Language