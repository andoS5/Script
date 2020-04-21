function Extract-Url($rawString){
    $ID = ((Select-String 'id="(.*)}"' -Input $rawString).Matches.Value).replace("id=","").replace("`"","")
    $item =  Get-Item $ID
    return $item.FullPath
}

function Extract-Footer-Contents {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0 )]
        [string]$RegionName,
    
        [Parameter(Mandatory = $true, Position = 1 )]
        [string]$Language,
    
        [Parameter(Mandatory = $true, Position = 2 )]
        [string]$MallName
    )
    begin {
        Write-Host "Export-Footer-Contents Begin"
    }

    process {

        $outputFilePath = "$($AppPath)/Footer_$($MallName).csv"
        $array = New-Object System.Collections.ArrayList

        $navigationContainer = "master:/sitecore/content/Klepierre/$($RegionName)/$($Language)/Home/Navigation Container"
        $childOfNavCont = Get-ChildItem -Path $navigationContainer -Language $Language
        $FooterRepositoryFullPath = $null
        foreach ($childOfNavConts in $childOfNavCont) {
            if ($childOfNavConts.Name -like "footer *") {
                $FooterRepositoryFullPath = $childOfNavConts.FullPath
            }
        }

        $FooterRepositoryChildrens = Get-ChildItem -Path $FooterRepositoryFullPath -Language $Language

        #Mobile App Repository
        $MobileAppRepositoryItem = Get-Item -Path $FooterRepositoryChildrens[0].FullPath -Language $Language
        $MobileAppRepository = $MobileAppRepositoryItem.Fields

        $MobileAppChildrens = Get-ChildItem -Path $MobileAppRepositoryItem.FullPath -Language $Language

        $AppleStoreItem = Get-Item -Path $MobileAppChildrens[0].FullPath -Language $Language
        $AppleStore = $AppleStoreItem.Fields
        $AppleStoreLink = ""
        if($AppleStore['Link'].Value -ne $null){
            $AppleStoreLinkRaw = ((Select-String '(http[s]?)(:\/\/)([^\s,]+)(?=")' -Input $AppleStore['Link'].Value).Matches.Value)
            $AppleStoreLink = if (![string]::IsNullOrEmpty($AppleStoreLinkRaw)) { $AppleStoreLinkRaw } else { Extract-Url($AppleStore['Link'].Value) }
        }

        $PlayStoreLink =  ""
        $PlayStoreItem = Get-Item -Path $MobileAppChildrens[1].FullPath -Language $Language
        $PlayStore = $PlayStoreItem.Fields
        if($PlayStore['Link'].Value -ne $null){
            $PlayStoreLinkRaw = ((Select-String '(http[s]?)(:\/\/)([^\s,]+)(?=")' -Input $PlayStore['Link'].Value).Matches.Value)
            $PlayStoreLink = if (![string]::IsNullOrEmpty($PlayStoreLinkRaw)) { $PlayStoreLinkRaw } else { Extract-Url($PlayStore['Link'].Value) }
        }
        
        #Contact
        $ContactLink = ""
        $ContactItem = Get-Item -Path $FooterRepositoryChildrens[2].FullPath -Language $Language
        $Contact = $ContactItem.Fields
        if($Contact['Link'].Value -ne $null){
            $ContactLinkRaw = ((Select-String '(http[s]?)(:\/\/)([^\s,]+)(?=")' -Input $Contact['Link'].Value).Matches.Value)
            $ContactLink = if (![string]::IsNullOrEmpty($ContactLinkRaw)) { $ContactLinkRaw } else { Extract-Url($Contact['Link'].Value) }
        }

        $ContactChildrens = Get-ChildItem -Path $ContactItem.FullPath -Language $Language

        $TempSpaceLink = ""
        $TemporarySpaceItem = Get-Item -Path $ContactChildrens[0].FullPath -Language $Language
        $TemporarySpace = $TemporarySpaceItem.Fields
        if($TemporarySpace['Link'].Value -ne $null){
            $TempSpaceLinkRaw = ((Select-String '(http[s]?)(:\/\/)([^\s,]+)(?=")' -Input $TemporarySpace['Link'].Value).Matches.Value)
            $TempSpaceLink = if (![string]::IsNullOrEmpty($TempSpaceLinkRaw)) { $TempSpaceLinkRaw } else { Extract-Url($TemporarySpace['Link'].Value) }
        }

        $LocalRentLink = ""
        $LocalRentItem = Get-Item -Path $ContactChildrens[1].FullPath -Language $Language
        $LocalRent = $LocalRentItem.Fields
        if($LocalRent['Link'].Value -ne $null){
            $LocalRentLinkRaw = ((Select-String '(http[s]?)(:\/\/)([^\s,]+)(?=")' -Input $LocalRent['Link'].Value).Matches.Value)
            $LocalRentLink = if (![string]::IsNullOrEmpty($LocalRentLinkRaw)) { $LocalRentLinkRaw } else { Extract-Url($LocalRent['Link'].Value)}
        }

        $ContactUsLink = ""
        $ContacUsItem = Get-Item -Path $ContactChildrens[2].FullPath -Language $Language 
        $ContactUs = $ContacUsItem.Fields
        if($ContactUs['Link'].Value -ne $null){
            $ContactUsLinkRaw = ((Select-String '(http[s]?)(:\/\/)([^\s,]+)(?=")' -Input $ContactUs['Link'].Value).Matches.Value)
            $ContactUsLink = if (![string]::IsNullOrEmpty($ContactUsLinkRaw)) { $ContactUsLinkRaw } else {Extract-Url($ContactUs['Link'].Value)}
        }

        $RecruitLink = ""
        $RecruitItem = Get-Item -Path $ContactChildrens[3].FullPath -Language $Language
        $Recruit = $RecruitItem.Fields
        if($Recruit['Link'].Value -ne $null){
            $RecruitLinkRaw = ((Select-String '(http[s]?)(:\/\/)([^\s,]+)(?=")' -Input $Recruit['Link'].Value).Matches.Value)
            $RecruitLink = if (![string]::IsNullOrEmpty($RecruitLinkRaw)) { $RecruitLinkRaw } else {Extract-Url($Recruit['Link'].Value)}
        }

        #Legal Page
        $LegalPageLink =""
        $LegalPageItem = Get-Item -Path $FooterRepositoryChildrens[3].FullPath -Language $Language
        $LegalPage = $LegalPageItem.Fields
        if($LegalPage['Link'].Value -ne $null){
            $LegalPageLinkRaw = ((Select-String '(http[s]?)(:\/\/)([^\s,]+)(?=")' -Input $LegalPage['Link'].Value).Matches.Value)
            $LegalPageLink = if (![string]::IsNullOrEmpty($LegalPageLinkRaw)) { $LegalPageLinkRaw } else {Extract-Url($LegalPage['Link'].Value)}
        }

        $LegalPageChildrens = Get-ChildItem -Path $LegalPageItem.FullPath -Language $Language

        $DataPrivacyLegalPageLink = ""
        $DataPrivacyLegalPageItem = Get-Item -Path $LegalPageChildrens[0].FullPath -Language $Language
        $DataPrivacyLegalPage = $DataPrivacyLegalPageItem.Fields
        if($DataPrivacyLegalPage['Link'].Value -ne $null){
            $DataPrivacyLegalPageLinkRaw = ((Select-String '(http[s]?)(:\/\/)([^\s,]+)(?=")' -Input $DataPrivacyLegalPage['Link'].Value).Matches.Value)
            $DataPrivacyLegalPageLink = if (![string]::IsNullOrEmpty($DataPrivacyLegalPageLinkRaw)) { $DataPrivacyLegalPageLinkRaw } else {Extract-Url($DataPrivacyLegalPage['Link'].Value)}
        }
        
        $LegalNoticePageLink =""
        $LegalNoticePageItem = Get-Item -Path $LegalPageChildrens[1].FullPath -Language $Language
        $LegalNoticePage = $LegalNoticePageItem.Fields
        if($LegalNoticePage['Link'].Value -ne $null){
            $LegalNoticePageLinkRaw = ((Select-String '(http[s]?)(:\/\/)([^\s,]+)(?=")' -Input $LegalNoticePage['Link'].Value).Matches.Value)
            $LegalNoticePageLink = if (![string]::IsNullOrEmpty($LegalNoticePageLinkRaw)) { $LegalNoticePageLinkRaw } else {Extract-Url($LegalNoticePage['Link'].Value)}
        }

        $TermOfServicePageLink =""
        $TermOfServicePageItem = Get-Item -Path $LegalPageChildrens[2].FullPath -Language $Language 
        $TermOfServicePage = $TermOfServicePageItem.Fields
        if($TermOfServicePage['Link'].Value -ne $null){
            $TermOfServicePageLinkRaw = ((Select-String '(http[s]?)(:\/\/)([^\s,]+)(?=")' -Input $TermOfServicePage['Link'].Value).Matches.Value)
            $TermOfServicePageLink = if (![string]::IsNullOrEmpty($TermOfServicePageLinkRaw)) { $TermOfServicePageLinkRaw } else {Extract-Url($TermOfServicePage['Link'].Value)}    
        }
        
        #Mall
        $MallLink =""
        $MallItem = Get-Item -Path $FooterRepositoryChildrens[4].FullPath -Language $Language
        $Mall = $MallItem.Fields
        if($Mall['Link'].Value -ne $null){
            $MallLinkRaw = ((Select-String '(http[s]?)(:\/\/)([^\s,]+)(?=")' -Input $Mall['Link'].Value).Matches.Value)
            $MallLink = if (![string]::IsNullOrEmpty($MallLinkRaw)) { $MallLinkRaw } else {Extract-Url($Mall['Link'].Value)}
        }

        $MallChildrens = Get-ChildItem -Path $MallItem.FullPath -Language $Language
        $ActusLink = ""
        $ActusItem = Get-Item -Path $MallChildrens[0].FullPath -Language $Language
        $Actus = $ActusItem.Fields
        if($Actus['Link'].Value -ne $null){
            $ActusLinkRaw = ((Select-String '(http[s]?)(:\/\/)([^\s,]+)(?=")' -Input $Actus['Link'].Value).Matches.Value)
            $ActusLink = if (![string]::IsNullOrEmpty($ActusLinkRaw)) { $ActusLinkRaw } else {Extract-Url($Actus['Link'].Value)}
        }

        $BonPlanLink = ""
        $BonPlanItem = Get-Item -Path $MallChildrens[1].FullPath -Language $Language
        $BonPlan = $BonPlanItem.Fields
        if($BonPlan['Link'].Value -ne $null){
            $BonPlanLinkRaw = ((Select-String '(http[s]?)(:\/\/)([^\s,]+)(?=")' -Input $BonPlan['Link'].Value).Matches.Value)
            $BonPlanLink = if (![string]::IsNullOrEmpty($BonPlanLinkRaw)) { $BonPlanLinkRaw } else {Extract-Url($BonPlan['Link'].Value)}
        }

        $BoutiquesLink = ""
        $BoutiquesItem = Get-Item -Path $MallChildrens[2].FullPath -Language $Language 
        $Boutiques = $BoutiquesItem.Fields
        if($Boutiques['Link'].Value -ne $null){
            $BoutiquesLinkRaw = ((Select-String '(http[s]?)(:\/\/)([^\s,]+)(?=")' -Input $Boutiques['Link'].Value).Matches.Value)
            $BoutiquesLink = if (![string]::IsNullOrEmpty($BoutiquesLinkRaw)) { $BoutiquesLinkRaw } else {Extract-Url($Boutiques['Link'].Value)}
        }

        $EventLink = ""
        $EventItem = Get-Item -Path $MallChildrens[3].FullPath -Language $Language
        $Event = $EventItem.Fields
        if($Event['Link'].Value -ne $null){
            $EventLinkRaw = ((Select-String '(http[s]?)(:\/\/)([^\s,]+)(?=")' -Input $Event['Link'].Value).Matches.Value)
            $EventLink = if (![string]::IsNullOrEmpty($EventLinkRaw)) { $EventLinkRaw } else {Extract-Url($Event['Link'].Value)}
        }

        $InfoPratiquesLink = ""
        $InfoPratiquesItem = Get-Item -Path $MallChildrens[4].FullPath -Language $Language
        $InfoPratiques = $InfoPratiquesItem.Fields
        if($InfoPratiques['Link'].Value -ne $null){
            $InfoPratiquesLinkRaw = ((Select-String '(http[s]?)(:\/\/)([^\s,]+)(?=")' -Input $InfoPratiques['Link'].Value).Matches.Value)
            $InfoPratiquesLink = if (![string]::IsNullOrEmpty($InfoPratiquesLinkRaw)) { $InfoPratiquesLinkRaw } else {Extract-Url($InfoPratiques['Link'].Value)}
        }

        $MallServicesLink =""
        $MallServicesItem = Get-Item -Path $MallChildrens[5].FullPath -Language $Language 
        $MallServices = $MallServicesITem.Fields
        if($MallServices['Link'].Value -ne $null){
            $MallServicesLinkRaw = ((Select-String '(http[s]?)(:\/\/)([^\s,]+)(?=")' -Input $MallServices['Link'].Value).Matches.Value)
            $MallServicesLink = if (![string]::IsNullOrEmpty($MallServicesLinkRaw)) { $MallServicesLinkRaw } else {Extract-Url($MallServices['Link'].Value)}
        }


        $obj = New-Object System.Object
        $obj | Add-Member -MemberType NoteProperty -Name "MobileAppRepositoryTitle" -Value  $MobileAppRepository['Title'].value
        $obj | Add-Member -MemberType NoteProperty -Name "MobileAppRepositoryDescription" -Value  $MobileAppRepository['Description'].Value
        $obj | Add-Member -MemberType NoteProperty -Name "AppleStoreName" -Value  $AppleStore["Name"].value
        $obj | Add-Member -MemberType NoteProperty -Name "AppleStoreLink" -Value  $AppleStoreLink
        $obj | Add-Member -MemberType NoteProperty -Name "PlayStoreName" -Value  $PlayStore['Name'].value
        $obj | Add-Member -MemberType NoteProperty -Name "PlayStoreLink" -Value  $PlayStoreLink
        $obj | Add-Member -MemberType NoteProperty -Name "ContactName" -Value  $Contact['Name'].value
        $obj | Add-Member -MemberType NoteProperty -Name "ContactLink" -Value  $ContactLink
        $obj | Add-Member -MemberType NoteProperty -Name "TempSpaceName" -Value  $TemporarySpace['Name'].value
        $obj | Add-Member -MemberType NoteProperty -Name "TempSpaceLink" -Value  $TempSpaceLink
        $obj | Add-Member -MemberType NoteProperty -Name "LocalRentName" -Value  $LocalRent['Name'].value
        $obj | Add-Member -MemberType NoteProperty -Name "LocalRentLink" -Value  $LocalRentLink
        $obj | Add-Member -MemberType NoteProperty -Name "ContactUsName" -Value  $ContactUs['Name'].value
        $obj | Add-Member -MemberType NoteProperty -Name "ContactUsLink" -Value  $ContactUsLink
        $obj | Add-Member -MemberType NoteProperty -Name "RecruitName" -Value  $Recruit['Name'].value
        $obj | Add-Member -MemberType NoteProperty -Name "RecruitLink" -Value  $RecruitLink
        $obj | Add-Member -MemberType NoteProperty -Name "LegalPageName" -Value  $LegalPage['Name'].value
        $obj | Add-Member -MemberType NoteProperty -Name "LegalPageLink" -Value  $LegalPageLink
        $obj | Add-Member -MemberType NoteProperty -Name "DataPrivacyLegalPageName" -Value  $DataPrivacyLegalPage['Name'].value
        $obj | Add-Member -MemberType NoteProperty -Name "DataPrivacyLegalPageLink" -Value  $DataPrivacyLegalPageLink
        $obj | Add-Member -MemberType NoteProperty -Name "LegalNoticePageName" -Value  $LegalNoticePage['Name'].value
        $obj | Add-Member -MemberType NoteProperty -Name "LegalNoticePageLink" -Value  $LegalNoticePageLink
        $obj | Add-Member -MemberType NoteProperty -Name "TermOfServicePageName" -Value  $TermOfServicePage['Name'].value
        $obj | Add-Member -MemberType NoteProperty -Name "TermOfServicePageLink" -Value  $TermOfServicePageLink
        $obj | Add-Member -MemberType NoteProperty -Name "MallName" -Value  $Mall['Name'].value
        $obj | Add-Member -MemberType NoteProperty -Name "MallLink" -Value  $MallLink
        $obj | Add-Member -MemberType NoteProperty -Name "ActusName" -Value  $Actus['Name'].value
        $obj | Add-Member -MemberType NoteProperty -Name "ActusLink" -Value  $ActusLink
        $obj | Add-Member -MemberType NoteProperty -Name "BonPlanName" -Value  $BonPlan['Name'].value
        $obj | Add-Member -MemberType NoteProperty -Name "BonPlanLink" -Value  $BonPlanLink
        $obj | Add-Member -MemberType NoteProperty -Name "BoutiquesName" -Value  $Boutiques['Name'].value
        $obj | Add-Member -MemberType NoteProperty -Name "BoutiquesLink" -Value  $BoutiquesLink
        $obj | Add-Member -MemberType NoteProperty -Name "EventName" -Value  $Event['Name'].value
        $obj | Add-Member -MemberType NoteProperty -Name "EventLink" -Value  $EventLink
        $obj | Add-Member -MemberType NoteProperty -Name "InfoPratiquesName" -Value  $InfoPratiques['Name'].value
        $obj | Add-Member -MemberType NoteProperty -Name "InfoPratiquesLink" -Value  $InfoPratiquesLink
        $obj | Add-Member -MemberType NoteProperty -Name "MallServicesName" -Value  $MallServices['Name'].value
        $obj | Add-Member -MemberType NoteProperty -Name "MallServicesLink" -Value  $MallServicesLink

        $array.Add($obj) | Out-Null
            
        Write-Host "done" -ForegroundColor Green
    
        $array | Select-Object MobileAppRepositoryTitle, MobileAppRepositoryDescription, AppleStoreName, AppleStoreLink, PlayStoreName, PlayStoreLink, ContactName, ContactLink, TempSpaceName, TempSpaceLink, LocalRentName, LocalRentLink, ContactUsName, ContactUsLink, RecruitName, RecruitLink, LegalPageName, LegalPageLink, DataPrivacyLegalPageName, DataPrivacyLegalPageLink, LegalNoticePageName, LegalNoticePageLink, TermOfServicePageName, TermOfServicePageLink, MallName, MallLink, ActusName, ActusLink, BonPlanName, BonPlanLink, BoutiquesName, BoutiquesLink, EventName, EventLink, InfoPratiquesName, InfoPratiquesLink, MallServicesName, MallServicesLink | Export-Csv -Encoding UTF8 -notypeinformation -Path $outputFilePath
        Try {
            Send-File -Path $outputFilePath
        }
        Finally {
            Remove-Item -Path $outputFilePath
        }
    }
    end {
        Write-Host "Export-Footer-Contents End"
    }
}
Extract-Footer-Contents "France" "odysseum" "fr-Fr"