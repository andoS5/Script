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
function ExtractEvents {
    param (
        [Parameter(Mandatory = $true, Position = 0 )]
        [string]$RegionName,
        [Parameter(Mandatory = $true, Position = 1 )]
        [string]$MallName,
        [Parameter(Mandatory = $true, Position = 2 )]
        [string]$Language
    )

    $EventsRepository = "master:/sitecore/content/Klepierre/$RegionName/$MallName/Home/Events and News/Events"
    $outputFilePath = "$($AppPath)/Events-$($MallName).csv"
    $array = New-Object System.Collections.ArrayList
    $EventsItem = Get-ChildItem -Path $EventsRepository -Language $Language | Where { $_.TemplateID -eq "{4058CE82-4516-4650-A69E-162D72F766D6}" }
    $count = $EventsItem.Count
    $cpt = 1
    foreach ($Event in $EventsItem) {

        $BreadcrumbTitle = $Event['Breadcrumb title']
        $Showonbreadcrumb = $Event['Show on breadcrumb']
        $DisplayDealsCTA = $Event['Display Deals CTA']
        $EreservationId = $Event['E-reservation Id']
        $BannerTitle = $Event['Banner Title']

        $LargeDesktopImage = if (![string]::IsNullOrEmpty($Event['Background Image'])) { Get-Name-By-ID (Get-Image-Item-Id $Event['Background Image']) }else { "" }  
        $DesktopImage = if (![string]::IsNullOrEmpty($Event['Large Image'])) { Get-Name-By-ID (Get-Image-Item-Id $Event['Large Image']) }else { "" }   
        $TabletImage = if (![string]::IsNullOrEmpty($Event['Tablet Image'])) { Get-Name-By-ID (Get-Image-Item-Id $Event['Tablet Image']) }else { "" }  
        $MobileImage = if (![string]::IsNullOrEmpty($Event['Mobile Image'])) { Get-Name-By-ID (Get-Image-Item-Id $Event['Mobile Image']) }else { "" }   
        $EventTileLargeImage = if (![string]::IsNullOrEmpty($Event['Event tile large image'])) { Get-Name-By-ID (Get-Image-Item-Id $Event['Event tile large image']) }else { "" }  

        $EventTitle = $Event['Event title']

        $EventStartDate = formatDateHour($Event['Event date Start']) #need to be formated
        $EventEndDate = formatDateHour($Event['Event date End'])#need to be formated

        $EventShortDescription = $Event['Event short description']
        $Description = $Event['Abstract']
        $EventLocation = $Event['Event location']
        $FirstTitleEvent = $Event['First Title Event']
        $FirstDescription = $Event['First Description Event']
        $FirstImage = $Event['First Image']
        $SecondTitleEvent = $Event['Second Title Event']
        $SecondDescription = $Event['Second Description']
        $SecondImage = $Event['Second Image']
        $SeeMoreCTA = $Event['See More CTA']
        $CanonicalUrl = $Event['Canonical Url']

        $OpenGraphImage = if (![string]::IsNullOrEmpty($Event['Open Graph Image'])) { Get-Name-By-ID (Get-Image-Item-Id $Event['Open Graph Image']) }else { "" }   

        $ShowonMobile = $Event['Show on Mobile']
        $obj = New-Object System.Object

        $obj | Add-Member -MemberType NoteProperty -Name "BreadcrumbTitle"-Value $BreadcrumbTitle
        $obj | Add-Member -MemberType NoteProperty -Name "Showonbreadcrumb"-Value $Showonbreadcrumb
        $obj | Add-Member -MemberType NoteProperty -Name "DisplayDealsCTA"-Value $DisplayDealsCTA
        $obj | Add-Member -MemberType NoteProperty -Name "EreservationId"-Value $EreservationId
        $obj | Add-Member -MemberType NoteProperty -Name "BannerTitle"-Value $BannerTitle
        $obj | Add-Member -MemberType NoteProperty -Name "LargeDesktopImage"-Value $LargeDesktopImage
        $obj | Add-Member -MemberType NoteProperty -Name "DesktopImage"-Value $DesktopImage
        $obj | Add-Member -MemberType NoteProperty -Name "TabletImage"-Value $TabletImage
        $obj | Add-Member -MemberType NoteProperty -Name "MobileImage"-Value $MobileImage
        $obj | Add-Member -MemberType NoteProperty -Name "EventTileLargeImage"-Value $EventTileLargeImage
        $obj | Add-Member -MemberType NoteProperty -Name "EventTitle" -Value $EventTitle
        $obj | Add-Member -MemberType NoteProperty -Name "EventStartDate"-Value $EventStartDate
        $obj | Add-Member -MemberType NoteProperty -Name "EventEndDate"-Value $EventEndDate
        $obj | Add-Member -MemberType NoteProperty -Name "EventShortDescription"-Value $EventShortDescription
        $obj | Add-Member -MemberType NoteProperty -Name "Description"-Value $Description
        $obj | Add-Member -MemberType NoteProperty -Name "EventLocation"-Value $EventLocation
        $obj | Add-Member -MemberType NoteProperty -Name "FirstTitleEvent"-Value $FirstTitleEvent
        $obj | Add-Member -MemberType NoteProperty -Name "FirstDescription"-Value $FirstDescription
        $obj | Add-Member -MemberType NoteProperty -Name "FirstImage" -Value $FirstImage
        $obj | Add-Member -MemberType NoteProperty -Name "SecondTitleEvent"-Value $SecondTitleEvent
        $obj | Add-Member -MemberType NoteProperty -Name "SecondDescription"-Value $SecondDescription
        $obj | Add-Member -MemberType NoteProperty -Name "SecondImage"-Value $SecondImage
        $obj | Add-Member -MemberType NoteProperty -Name "SeeMoreCTA"-Value $SeeMoreCTA
        $obj | Add-Member -MemberType NoteProperty -Name "CanonicalUrl"-Value $CanonicalUrl
        $obj | Add-Member -MemberType NoteProperty -Name "OpenGraphImage"-Value $OpenGraphImage
        $obj | Add-Member -MemberType NoteProperty -Name "ShowonMobile"-Value $ShowonMobile

        $array.Add($obj) | Out-Null
            
        Write-Host "[$($cpt)/$($count)]  ---- done" -ForegroundColor Green
        $cpt ++;
    }
    $array | Select-Object BreadcrumbTitle, Showonbreadcrumb, DisplayDealsCTA, EreservationId, BannerTitle, LargeDesktopImage, DesktopImage, TabletImage, MobileImage, EventTileLargeImage, EventTitle, EventStartDate, EventEndDate, EventShortDescription, Description, EventLocation, FirstTitleEvent, FirstDescription, FirstImage, SecondTitleEvent, SecondDescription, SecondImage, SeeMoreCTA,CanonicalUrl, OpenGraphImage, ShowonMobile | Export-Csv -Encoding UTF8 -notypeinformation -Path $outputFilePath
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
ExtractEvents $RegionName $MallName $Language
