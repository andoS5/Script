

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
                $item = Get-Item master: -ID $selectedData -Language $Language
                $names += "$($item.Name)|"
            }
            $SelectedNames = $names.Trim("|")
        }
        else {
            $selectedItem = Get-Item master: -ID $selectedRawData -Language $Language
            $SelectedNames = $selectedItem.Name
        }
    }
    return $SelectedNames
}
function ExtractContactForms {
    param (
        [Parameter(Mandatory = $true, Position = 0 )]
        [string]$RegionName,
        [Parameter(Mandatory = $true, Position = 1 )]
        [string]$Mall_Name,
        [Parameter(Mandatory = $true, Position = 2 )]
        [string]$Language
    )
    process {
        $outputFilePath = "$($AppPath)/Contact us - $MallName.csv"
        $array = New-Object System.Collections.ArrayList

        $ContactFormPage = "master:/sitecore/content/Klepierre/$RegionName/$Mall_Name/Home/Forms Repository/Contact Forms Page"
        $ContactItem = Get-Item -Path $ContactFormPage -Language $Language

        $Breadcrumbtitle = $ContactItem['Breadcrumb title']
        $Showonbreadcrumb = $ContactItem['Show on breadcrumb']
        $BannerTitle = $ContactItem['Banner Title']

        $BackgroundImage = if (![string]::IsNullOrEmpty($ContactItem['Background Image'])) { Get-Name-By-ID (Get-Image-Item-Id $ContactItem['Background Image']) }else { "" }   
        $LargeImage = if (![string]::IsNullOrEmpty($ContactItem['Large Image'])) { Get-Name-By-ID (Get-Image-Item-Id $ContactItem['Large Image']) }else { "" }   
        $MobileImage = if (![string]::IsNullOrEmpty($ContactItem['Mobile Image'])) { Get-Name-By-ID (Get-Image-Item-Id $ContactItem['Mobile Image']) }else { "" }   
        $TabletImage = if (![string]::IsNullOrEmpty($ContactItem['Tablet Image'])) { Get-Name-By-ID (Get-Image-Item-Id $ContactItem['Tablet Image']) }else { "" }   
        
        $AddressTitle = $ContactItem['{C08BF2DD-A682-47A5-B5AA-0FB3A6210170}']
        $Mallname = $ContactItem['Mall name']
        $Address1 = $ContactItem['Address 1']
        $Address2 = $ContactItem['Address 2']
        $CityAdress = $ContactItem['City']
        $PostalCode = $ContactItem['Postal Code']
        $ContactTitle = $ContactItem['Contact Title']
        $AddressTitleContact = $ContactItem['{5072C1F5-E9C8-4821-9DED-BC258EFA3D8C}']
        $CallAndSocialTitle = $ContactItem['Call And Social Title']
        $CallAndSocialPhoneNumber = $ContactItem['Call And Social Phone Number']
        $ThankYouTitle = $ContactItem['Thank You Title']
        $ThankYouDescription = $ContactItem['Thank You Description']
        $LegalNoticeTitle = $ContactItem['Legal Notice Title']
        $Readmore = $ContactItem['Read more']
        $LegalNoticeUnderneath = $ContactItem['Legal Notice Underneath']
        $SEOParagraph = $ContactItem['SEO Paragraph']
        $pageTitle = $ContactItem['Page Title']
        $metaDescription = $ContactItem['Meta Description'] 

        $OpenGraphImage = if (![string]::IsNullOrEmpty($ContactItem['Open Graph Image'])) { Get-Name-By-ID (Get-Image-Item-Id $ContactItem['Open Graph Image']) }else { "" }    

        $CanonicalUrl = $ContactItem['Canonical Url']
        $ShowonMobile = $ContactItem['Show on Mobile']

        $fb = Get-Item -Path "master:/sitecore/content/Klepierre/$RegionName/$Mall_Name/Home/Forms Repository/Contact Forms Page/Social Media Repository/Facebook" -Language $Language
        $facebookIcon = if (![string]::IsNullOrEmpty($fb['Social Media Icon'])) { Get-Name-By-ID (Get-Image-Item-Id $fb['Social Media Icon']) }else { "" }  
        $facebookLink = ((Select-String '(http[s]?)(:\/\/)([^\s,]+)(?=")' -Input $fb['Social Media Link']).Matches.Value)

        $insta = Get-Item -Path "master:/sitecore/content/Klepierre/$RegionName/$Mall_Name/Home/Forms Repository/Contact Forms Page/Social Media Repository/Instagram" -Language $Language
        $InstagramIcon = if (![string]::IsNullOrEmpty($insta['Social Media Icon'])) { Get-Name-By-ID (Get-Image-Item-Id $insta['Social Media Icon']) }else { "" }  
        $InstagramLink = ((Select-String '(http[s]?)(:\/\/)([^\s,]+)(?=")' -Input $insta['Social Media Link']).Matches.Value)

        $intro = Get-Item -Path "master:/sitecore/Forms/$RegionName/$Mall_Name/Contact Page/Page/Section Intro/Introduction form" -Language $Language 
        $Introductionform = $intro['Text']

        $page = "master:/sitecore/Forms/$RegionName/$Mall_Name/Contact Page/Page"

        $OtherFormItems = Get-ChildItem -Path $page -Language $Language  | Where { $_.TemplateID -eq "{0908030B-4564-42EA-A6FA-C7A5A2D921A8}" }
      
        $Lastname = ""
        $LastnameValidators = ""
        $Firstname = ""
        $FirstnameValidators = ""
        $CityForm = ""
        $CityFormValidators = ""
        $Phone = ""
        $PhoneValidators = ""
        $PostCode = ""
        $PostCodeValidators = ""

        foreach ($pageForm in $OtherFormItems) {
            $childName = $pageForm.Name
            
            if ($childName -eq "Last name") {
                $Lastname = $pageForm['Placeholder Text']
                $LastnameValidators = getSelectedItemName $pageForm['Validations'] $Language
            }
            elseif ($childName -eq "First name") {
                $Firstname = $pageForm['Placeholder Text']
                $FirstnameValidators = getSelectedItemName $pageForm['Validations'] $Language 
            }
            elseif ($childName -eq "Phone") {
                $Phone = $pageForm['Placeholder Text'] 
                $PhoneValidators = getSelectedItemName $pageForm['Validations'] $Language 
            }
            elseif ($childName -eq "Post Code") {
                $PostCode = $pageForm['Placeholder Text'] 
                $PostCodeValidators = getSelectedItemName $pageForm['Validations'] $Language 
            }
            elseif ($childName -eq "City") {
                $CityForm = $pageForm['Placeholder Text'] 
                $CityFormValidators = if ($pageForm['Validations']) { getSelectedItemName $pageForm['Validations'] $Language } else { "" }
            }
            
        }

        $MessageFormItem = Get-ChildItem -Path $page -Language $Language  | Where { $_.TemplateID -eq "{D8386D04-C1E3-4CD3-9227-9E9F86EF3C88}" }
        $MessageForm = $MessageFormItem['Placeholder Text']
        $MessageFormValidators = getSelectedItemName $MessageFormItem['Validations'] $Language 

        $EmailaddressItem = Get-ChildItem -Path $page -Language $Language  | Where { $_.TemplateID -eq "{886ADEC1-ABF8-40E1-9926-D9189C4E8E1B}" }
        $Emailaddress = $EmailaddressItem['Placeholder Text']
        $EmailaddressValidators = getSelectedItemName $EmailaddressItem['Validations'] $Language 

        $recaptcheItem = Get-ChildItem -Path $page -Language $Language  | Where { $_.TemplateID -eq "{FC18F915-EAC6-460A-8777-6E1376A9EA09}" }
        $ReCaptcha = $recaptcheItem['Text']
        

        $SubmitButtonItem = Get-ChildItem -Path $page -Language $Language  | Where { $_.TemplateID -eq "{94A46D66-B1B8-405D-AAE4-7B5A9CD61C5E}" }
        $SubmitButton = $SubmitButtonItem['Title']


        $obj = New-Object System.Object
        $obj | Add-Member -MemberType NoteProperty -Name "Breadcrumbtitle"-Value $Breadcrumbtitle
        $obj | Add-Member -MemberType NoteProperty -Name "Showonbreadcrumb"-Value $Showonbreadcrumb
        $obj | Add-Member -MemberType NoteProperty -Name "BannerTitle"-Value $BannerTitle
        $obj | Add-Member -MemberType NoteProperty -Name "BackgroundImage"-Value $BackgroundImage
        $obj | Add-Member -MemberType NoteProperty -Name "LargeImage"-Value $LargeImage
        $obj | Add-Member -MemberType NoteProperty -Name "MobileImage"-Value $MobileImage
        $obj | Add-Member -MemberType NoteProperty -Name "TabletImage"-Value $TabletImage
        $obj | Add-Member -MemberType NoteProperty -Name "AddressTitle"-Value $AddressTitle
        $obj | Add-Member -MemberType NoteProperty -Name "Mallname"-Value $Mallname
        $obj | Add-Member -MemberType NoteProperty -Name "Address1"-Value $Address1
        $obj | Add-Member -MemberType NoteProperty -Name "Address2"-Value $Address2
        $obj | Add-Member -MemberType NoteProperty -Name "CityAdress"-Value $CityAdress
        $obj | Add-Member -MemberType NoteProperty -Name "PostalCode"-Value $PostalCode
        $obj | Add-Member -MemberType NoteProperty -Name "ContactTitle"-Value $ContactTitle
        $obj | Add-Member -MemberType NoteProperty -Name "AddressTitleContact"-Value $AddressTitleContact
        $obj | Add-Member -MemberType NoteProperty -Name "CallAndSocialTitle"-Value $CallAndSocialTitle
        $obj | Add-Member -MemberType NoteProperty -Name "CallAndSocialPhoneNumber"-Value $CallAndSocialPhoneNumber
        $obj | Add-Member -MemberType NoteProperty -Name "ThankYouTitle"-Value $ThankYouTitle
        $obj | Add-Member -MemberType NoteProperty -Name "ThankYouDescription"-Value $ThankYouDescription
        $obj | Add-Member -MemberType NoteProperty -Name "LegalNoticeTitle"-Value $LegalNoticeTitle
        $obj | Add-Member -MemberType NoteProperty -Name "Readmore"-Value $Readmore
        $obj | Add-Member -MemberType NoteProperty -Name "pageTitle"-Value $pageTitle
        $obj | Add-Member -MemberType NoteProperty -Name "metaDescription"-Value $metaDescription
        $obj | Add-Member -MemberType NoteProperty -Name "LegalNoticeUnderneath"-Value $LegalNoticeUnderneath
        $obj | Add-Member -MemberType NoteProperty -Name "SEOParagraph"-Value $SEOParagraph
        $obj | Add-Member -MemberType NoteProperty -Name "OpenGraphImage"-Value $OpenGraphImage
        $obj | Add-Member -MemberType NoteProperty -Name "CanonicalUrl"-Value $CanonicalUrl
        $obj | Add-Member -MemberType NoteProperty -Name "ShowonMobile"-Value $ShowonMobile
        $obj | Add-Member -MemberType NoteProperty -Name "facebookIcon"-Value $facebookIcon
        $obj | Add-Member -MemberType NoteProperty -Name "facebookLink"-Value $facebookLink
        $obj | Add-Member -MemberType NoteProperty -Name "InstagramIcon"-Value $InstagramIcon
        $obj | Add-Member -MemberType NoteProperty -Name "InstagramLink"-Value $InstagramLink
        $obj | Add-Member -MemberType NoteProperty -Name "Introductionform"-Value $Introductionform
        $obj | Add-Member -MemberType NoteProperty -Name "FirstName"-Value $FirstName
        $obj | Add-Member -MemberType NoteProperty -Name "FirstNameValidators"-Value $FirstNameValidators
        $obj | Add-Member -MemberType NoteProperty -Name "LastName"-Value $LastName
        $obj | Add-Member -MemberType NoteProperty -Name "LastNameValidators"-Value $LastNameValidators
        $obj | Add-Member -MemberType NoteProperty -Name "Phone"-Value $Phone
        $obj | Add-Member -MemberType NoteProperty -Name "PhoneValidators"-Value $PhoneValidators
        $obj | Add-Member -MemberType NoteProperty -Name "Emailaddress"-Value $Emailaddress
        $obj | Add-Member -MemberType NoteProperty -Name "EmailaddressValidators"-Value $EmailaddressValidators
        $obj | Add-Member -MemberType NoteProperty -Name "PostCode"-Value $PostCode
        $obj | Add-Member -MemberType NoteProperty -Name "PostCodeValidators"-Value $PostCodeValidators
        $obj | Add-Member -MemberType NoteProperty -Name "CityForm"-Value $CityForm
        $obj | Add-Member -MemberType NoteProperty -Name "CityFormValidators"-Value $CityFormValidators
        $obj | Add-Member -MemberType NoteProperty -Name "MessageForm"-Value $MessageForm
        $obj | Add-Member -MemberType NoteProperty -Name "MessageFormValidators"-Value $MessageFormValidators
        $obj | Add-Member -MemberType NoteProperty -Name "ReCaptcha"-Value $ReCaptcha
        $obj | Add-Member -MemberType NoteProperty -Name "SubmitButton"-Value $SubmitButton


        $array.Add($obj) | Out-Null         
        Write-Host "Extract done " -ForegroundColor Green

        $array | Select-Object Breadcrumbtitle, Showonbreadcrumb, BannerTitle, BackgroundImage, LargeImage, MobileImage, TabletImage, AddressTitle, Mallname, Address1, Address2, CityAdress, PostalCode, ContactTitle, AddressTitleContact, CallAndSocialTitle, CallAndSocialPhoneNumber, ThankYouTitle, ThankYouDescription, LegalNoticeTitle, Readmore, pageTitle, MetaDescription, LegalNoticeUnderneath, SEOParagraph, OpenGraphImage, CanonicalUrl, ShowonMobile, facebookIcon, facebookLink, InstagramIcon, InstagramLink, Introductionform, FirstName, FirstNameValidators, LastName, LastNameValidators, Phone, PhoneValidators, Emailaddress, EmailaddressValidators, PostCode, PostCodeValidators, CityForm, CityFormValidators, MessageForm, MessageFormValidators, ReCaptcha, SubmitButton | Export-Csv -Encoding UTF8 -notypeinformation -Path $outputFilePath
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
ExtractContactForms $RegionName $MallName $Language

