function Get-Name-By-ID($ID) {
    $listId = $null
    $listName = $null
    if ($ID.Contains('|')) {
        $listId = $ID.split('|')
        foreach ($list in $listId) {
            if ($list.Trim() -ne $null -and $list.Contains("{")) {
                $var = Get-Item $list
                $listName = "$($listName)|$($var.Name)".substring(1)
            }
        }
    }
    else {
        # $listId = $ID
        $var = Get-Item $ID
        $listName = "$($var.Name)"
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

function getSelectedItemName {
    param (
        [Parameter(Mandatory = $true, Position = 0 )]
        [string]$selectedRawData,
        [Parameter(Mandatory = $true, Position = 1 )]
        [string]$Language
    )
    $SelectedNames = ""
    if (![string]::IsNullOrEmpty($selectedRawData)) {
        $selectedDatas = if ($selectedRawData.Contains("|")) { $selectedRawData.split("|") }
        $Count = $selectedDatas.Count
        if ($Count -gt 1) {
            foreach ($selectedData in $selectedDatas) {
                $item = Get-Item master: -ID $selectedData -Language 'da'
                $names += "$($item.Name)|"
            }
            $SelectedNames = $names.Trim("|")
        }
        else {
            $selectedItem = Get-Item master: -ID $selectedRawData -Language 'da'
            $SelectedNames = $selectedItem.Name
        }
    }
    return $SelectedNames
}

function ExportShopingCenterLP {
    param (
        [Parameter(Mandatory = $true, Position = 0 )]
        [string]$RegionName,
        [Parameter(Mandatory = $true, Position = 1 )]
        [string]$MallName,
        [Parameter(Mandatory = $true, Position = 2 )]
        [string]$Language
    )

    process {

        $shoppingCenterRepository = "master:/sitecore/content/Klepierre/$RegionName/$MallName/Home/Shopping Center"
        $outputFilePath = "$($AppPath)/ShopingCenter_$($MallName).csv"
        $array = New-Object System.Collections.ArrayList

        $scItem = Get-Item -Path $shoppingCenterRepository -Language $Language

        $BreadcrumbTitle = $scItem['Breadcrumb title']
        $Showonbreadcrumb = $scItem['Show on breadcrumb']
        $IntroTitle = $scItem['Intro Title']
        $IntroDescription = $scItem['Intro Description']
        $IntroSideImage = if (![string]::IsNullOrEmpty($scItem['Intro Side Image'])) { Get-Name-By-ID (Get-Image-Item-Id $scItem['Intro Side Image']) }else { "" }  
        $CTAPracticalInfoLabel = $scItem['CTA Practical Info Label']
        $CTAPracticalInfoLink = Get-Name-By-ID(Get-Image-Item-Id $scItem['CTA Practical Info Link']) 
        $BannerTitle = $scItem['Banner Title']

        $LargeDesktopImage = if (![string]::IsNullOrEmpty($scItem['Background Image'])) { Get-Name-By-ID (Get-Image-Item-Id $scItem['Background Image']) }else { "" }
        $DesktopImage = if (![string]::IsNullOrEmpty($scItem['Large Image'])) { Get-Name-By-ID (Get-Image-Item-Id $scItem['Large Image']) }else { "" }
        $TabletImage = if (![string]::IsNullOrEmpty($scItem['Tablet Image'])) { Get-Name-By-ID (Get-Image-Item-Id $scItem['Tablet Image']) }else { "" } 
        $MobileImage = if (![string]::IsNullOrEmpty($scItem['Mobile Image'])) { Get-Name-By-ID (Get-Image-Item-Id $scItem['Mobile Image']) }else { "" }  
        $AuthorImage = if (![string]::IsNullOrEmpty($scItem['Author Image'])) { Get-Name-By-ID (Get-Image-Item-Id $scItem['Author Image']) }else { "" }   

        $AuthorName = $scItem['Author Name']
        $AuthorTitle = $scItem['Author Title']
        $CTAContactUsLabel = $scItem['CTA Contact Us Label']
        $CTAContactUsLink = Get-Name-By-ID(Get-Image-Item-Id $scItem['CTA Contact Us Link']) 
        $DetailTitle = $scItem['Detail Title']
        $CreationDate = $scItem['Creation Date']
        $IsCertified = $scItem['Is Certified']
        $DetailImage = if (![string]::IsNullOrEmpty($scItem['Detail Image'])) { Get-Name-By-ID (Get-Image-Item-Id $scItem['Detail Image']) }else { "" }    
        $ServiceTitle = $scItem['Service Title']

        $servicePicker = $scItem['Service Picker']
        $selectedservices = getSelectedItemName $servicePicker $Language
     
        $CTAServiceLabel = $scItem['CTA Service Label']
        $CTAServiceLink = Get-Name-By-ID(Get-Image-Item-Id $scItem['CTA Service Link']) 
        $SocialFirstImage = if (![string]::IsNullOrEmpty($scItem['Social First Image'])) { Get-Name-By-ID (Get-Image-Item-Id $scItem['Social First Image']) }else { "" }
        $SocialSecondImage = if (![string]::IsNullOrEmpty($scItem['Social Second Image'])) { Get-Name-By-ID (Get-Image-Item-Id $scItem['Social Second Image']) }else { "" }
        $SocialThirdImage = if (![string]::IsNullOrEmpty($scItem['Social Third Image'])) { Get-Name-By-ID (Get-Image-Item-Id $scItem['Social Third Image']) }else { "" }
        $SocialTitle = $scItem['Social Title']
        $SocialDescription = $scItem['Social Description']

        $NewsandEventsSelection = getSelectedItemName $scItem['News and Events Selection'] $Language

        $SocialSecondDescription = $scItem['Social Second Description']
        $StoryTitle = $scItem['Story Title']

        $EventandNewsPicker = getSelectedItemName $scItem['Event and News Picker'] $Language

        $CTANewsandEventsLabel = $scItem['CTA News and Events Label']
        $CTANewsandEventsLink = Get-Name-By-ID(Get-Image-Item-Id $scItem['CTA News and Events Link']) 
        $SocialMediaTitle = $scItem['Social Media Title']
        $FacebookValue = $scItem['Facebook Value']
        $FacebookLabel = $scItem['Facebook Label']
        $CTAFacebookLabel = $scItem['CTA Facebook Label'] 
        $fblink = $scItem['CTA Facebook Link']
        $CTAFacebookLink = ((Select-String '(http[s]?)(:\/\/)([^\s,]+)(?=")' -Input $fblink).Matches.Value) 
        $InstagramValue = $scItem['Instagram Value']
        $InstagramLabel = $scItem['Instagram Label']
        $CTAInstagramLabel = $scItem['CTA Instagram Label']
        $instaLink = $scItem['CTA Instagram Link']
        $CTAInstagramLink = ((Select-String '(http[s]?)(:\/\/)([^\s,]+)(?=")' -Input $instaLink).Matches.Value) 
        $OpenGraphImage = if (![string]::IsNullOrEmpty($scItem['Open Graph Image'])) { Get-Name-By-ID (Get-Image-Item-Id $scItem['Open Graph Image']) }else { "" } 
        $ShowonMobile = $scItem['Show on Mobile']

        $obj = New-Object System.Object
        $obj | Add-Member -MemberType NoteProperty -Name "BreadcrumbTitle"-Value $BreadcrumbTitle
        $obj | Add-Member -MemberType NoteProperty -Name "Showonbreadcrumb"-Value $Showonbreadcrumb
        $obj | Add-Member -MemberType NoteProperty -Name "IntroTitle"-Value $IntroTitle
        $obj | Add-Member -MemberType NoteProperty -Name "IntroDescription"-Value $IntroDescription
        $obj | Add-Member -MemberType NoteProperty -Name "IntroSideImage"-Value $IntroSideImage
        $obj | Add-Member -MemberType NoteProperty -Name "CTAPracticalInfoLabel"-Value $CTAPracticalInfoLabel
        $obj | Add-Member -MemberType NoteProperty -Name "CTAPracticalInfoLink"-Value $CTAPracticalInfoLink
        $obj | Add-Member -MemberType NoteProperty -Name "BannerTitle"-Value $BannerTitle
        $obj | Add-Member -MemberType NoteProperty -Name "LargeDesktopImage"-Value $LargeDesktopImage
        $obj | Add-Member -MemberType NoteProperty -Name "DesktopImage"-Value $DesktopImage
        $obj | Add-Member -MemberType NoteProperty -Name "TabletImage"-Value $TabletImage
        $obj | Add-Member -MemberType NoteProperty -Name "MobileImage"-Value $MobileImage
        $obj | Add-Member -MemberType NoteProperty -Name "AuthorImage"-Value $AuthorImage
        $obj | Add-Member -MemberType NoteProperty -Name "AuthorName"-Value $AuthorName
        $obj | Add-Member -MemberType NoteProperty -Name "AuthorTitle"-Value $AuthorTitle
        $obj | Add-Member -MemberType NoteProperty -Name "CTAContactUsLabel"-Value $CTAContactUsLabel
        $obj | Add-Member -MemberType NoteProperty -Name "CTAContactUsLink"-Value $CTAContactUsLink
        $obj | Add-Member -MemberType NoteProperty -Name "DetailTitle"-Value $DetailTitle
        $obj | Add-Member -MemberType NoteProperty -Name "CreationDate"-Value $CreationDate
        $obj | Add-Member -MemberType NoteProperty -Name "IsCertified"-Value $IsCertified
        $obj | Add-Member -MemberType NoteProperty -Name "DetailImage"-Value $DetailImage
        $obj | Add-Member -MemberType NoteProperty -Name "ServiceTitle"-Value $ServiceTitle
        $obj | Add-Member -MemberType NoteProperty -Name "selectedservices"-Value $selectedservices
        $obj | Add-Member -MemberType NoteProperty -Name "CTAServiceLabel"-Value $CTAServiceLabel
        $obj | Add-Member -MemberType NoteProperty -Name "CTAServiceLink"-Value $CTAServiceLink
        $obj | Add-Member -MemberType NoteProperty -Name "SocialFirstImage"-Value $SocialFirstImage
        $obj | Add-Member -MemberType NoteProperty -Name "SocialSecondImage"-Value $SocialSecondImage
        $obj | Add-Member -MemberType NoteProperty -Name "SocialThirdImage"-Value $SocialThirdImage
        $obj | Add-Member -MemberType NoteProperty -Name "SocialTitle"-Value $SocialTitle
        $obj | Add-Member -MemberType NoteProperty -Name "SocialDescription"-Value $SocialDescription
        $obj | Add-Member -MemberType NoteProperty -Name "NewsandEventsSelection"-Value $NewsandEventsSelection
        $obj | Add-Member -MemberType NoteProperty -Name "SocialSecondDescription"-Value $SocialSecondDescription
        $obj | Add-Member -MemberType NoteProperty -Name "StoryTitle"-Value $StoryTitle
        $obj | Add-Member -MemberType NoteProperty -Name "EventandNewsPicker"-Value $EventandNewsPicker
        $obj | Add-Member -MemberType NoteProperty -Name "CTANewsandEventsLabel"-Value $CTANewsandEventsLabel
        $obj | Add-Member -MemberType NoteProperty -Name "CTANewsandEventsLink"-Value $CTANewsandEventsLink
        $obj | Add-Member -MemberType NoteProperty -Name "SocialMediaTitle"-Value $SocialMediaTitle
        $obj | Add-Member -MemberType NoteProperty -Name "FacebookValue"-Value $FacebookValue
        $obj | Add-Member -MemberType NoteProperty -Name "FacebookLabel"-Value $FacebookLabel
        $obj | Add-Member -MemberType NoteProperty -Name "CTAFacebookLabel"-Value $CTAFacebookLabel
        $obj | Add-Member -MemberType NoteProperty -Name "CTAFacebookLink"-Value $CTAFacebookLink
        $obj | Add-Member -MemberType NoteProperty -Name "InstagramValue"-Value $InstagramValue
        $obj | Add-Member -MemberType NoteProperty -Name "InstagramLabel"-Value $InstagramLabel
        $obj | Add-Member -MemberType NoteProperty -Name "CTAInstagramLabel"-Value $CTAInstagramLabel
        $obj | Add-Member -MemberType NoteProperty -Name "CTAInstagramLink"-Value $CTAInstagramLink
        $obj | Add-Member -MemberType NoteProperty -Name "CanonicalUrl"-Value $scItem['Canonical Url'].Value ###A ajouter
        $obj | Add-Member -MemberType NoteProperty -Name "OpenGraphImage"-Value $OpenGraphImage
        $obj | Add-Member -MemberType NoteProperty -Name "ShowonMobile"-Value $ShowonMobile
        $array.Add($obj) | Out-Null

        $array | Select-Object BreadcrumbTitle,Showonbreadcrumb,	IntroTitle,	IntroDescription,	IntroSideImage,	CTAPracticalInfoLabel,	CTAPracticalInfoLink,	BannerTitle,	LargeDesktopImage,	DesktopImage,	TabletImage,	MobileImage,	AuthorImage,	AuthorName,	AuthorTitle,	CTAContactUsLabel,	CTAContactUsLink,	DetailTitle,	CreationDate,	IsCertified,	DetailImage,	ServiceTitle,	selectedservices,	CTAServiceLabel,	CTAServiceLink,	SocialFirstImage,	SocialSecondImage,	SocialThirdImage,	SocialTitle,	SocialDescription,	NewsandEventsSelection,	SocialSecondDescription,	StoryTitle,	EventandNewsPicker,	CTANewsandEventsLabel,	CTANewsandEventsLink,	SocialMediaTitle,	FacebookValue,	FacebookLabel,	CTAFacebookLabel,	CTAFacebookLink,InstagramValue,	InstagramLabel,	CTAInstagramLabel,	CTAInstagramLink,	OpenGraphImage,	ShowonMobile | Export-Csv -Encoding UTF8 -notypeinformation -Path $outputFilePath
        Try {
            Send-File -Path $outputFilePath
        }
        Finally {
            Remove-Item -Path $outputFilePath
        }

    }
}

$RegionName = "France"
$MallName = "Odysseum"
$Language = "fr-fr"
ExportShopingCenterLP $RegionName $MallName $Language
