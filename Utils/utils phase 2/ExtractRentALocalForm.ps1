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
function ExtractRentALocalForm {
    param (
        [Parameter(Mandatory = $true, Position = 0 )]
        [string]$RegionName,
        [Parameter(Mandatory = $true, Position = 1 )]
        [string]$MallName,
        [Parameter(Mandatory = $true, Position = 2 )]
        [string]$Language
    )

    process {

        $FormsRepository = "master:/sitecore/content/Klepierre/$RegionName/$MallName/Home/Forms Repository"
        $Locals = Get-ChildItem -Path $FormsRepository -Language $Language | Where { $_.TemplateID -eq "{66502E8A-386C-45EE-B0C9-28AB51D990B6}" }

        $outputFilePath = "$($AppPath)/Rent a local - $MallName.csv"
        $array = New-Object System.Collections.ArrayList
        $count = $Locals.Count
        $cpt = 1
        foreach ($Local in $Locals) {
            $RentForm = $Local.Name

            $Breadcrumbtitle = $Local['Breadcrumb title']
            $Showonbreadcrumb = $Local['Show on breadcrumb']
            $RentLocalTitle = $Local['Rent Local Title']
            $RentLocalDescription = $Local['Rent Local Description']
            $BannerTitle = $Local['Banner Title']

            $BackgroundImage = if (![string]::IsNullOrEmpty($Local['Background Image'])) { Get-Name-By-ID (Get-Image-Item-Id $Local['Background Image']) }else { "" }
            $LargeImage = if (![string]::IsNullOrEmpty($Local['Large Image'])) { Get-Name-By-ID (Get-Image-Item-Id $Local['Large Image']) }else { "" } 
            $MobileImage = if (![string]::IsNullOrEmpty($Local['Mobile Image'])) { Get-Name-By-ID (Get-Image-Item-Id $Local['Mobile Image']) }else { "" }  
            $TabletImage = if (![string]::IsNullOrEmpty($Local['Tablet Image'])) { Get-Name-By-ID (Get-Image-Item-Id $Local['Tablet Image']) }else { "" }  

            $ThankYouTitle = $Local['Thank You Title']
            $ThankYouDescription = $Local['Thank You Description']
            $LegalNoticeTitle = $Local['Legal Notice Title']
            $LegalNoticeUnderneath = $Local['Legal Notice Underneath']
            $SEOParagraph = $Local['SEO Paragraph']
            $OpenGraphImage = $Local['Open Graph Image']
            $CanonicalUrl = $Local['Canonical Url']
            $ShowonMobile = $Local['Show on Mobile']

            #placeholder
            $page = "master:/sitecore/Forms/$RegionName/$MallName/Rent A Local/Page"
               
            $RecaptchaItem = Get-ChildItem -Path $page -Language $Language  | Where { $_.TemplateID -eq "{FC18F915-EAC6-460A-8777-6E1376A9EA09}" }
            $ReCaptcha = $RecaptchaItem['Text']
                    
            $SubmitButtonItem = Get-ChildItem -Path $page -Language $Language  | Where { $_.TemplateID -eq "{94A46D66-B1B8-405D-AAE4-7B5A9CD61C5E}" }
            $SubmitButton = $SubmitButtonItem['Title']

            $OtherFormItems = Get-ChildItem -Path $page -Language $Language  | Where { $_.TemplateID -eq "{0908030B-4564-42EA-A6FA-C7A5A2D921A8}" }
            
            $Brandname = ""
            $BrandnameValidators = ""
            $Companyname = ""
            $CompanynameValidators = ""
            $Lastname = ""
            $LastnameValidators = ""
            $Firstname = ""
            $FirstnameValidators = ""
            $Emailaddress = ""
            $EmailaddressValidators = ""
            $Phone = ""
            $PhoneValidators = ""
            $SurfaceArea = ""
            $SurfaceAreaValidators = ""
          

            foreach ($pageForm in $OtherFormItems) {
                $childName = $pageForm.Name
                if ($childName -eq "Brand name") {
                    $Brandname = $pageForm['Placeholder Text'] 
                    $BrandnameValidators = getSelectedItemName $pageForm['Validations'] $Language
                }
                elseif ($childName -eq "Company name") {
                    $Companyname = $pageForm['Placeholder Text']
                    $CompanynameValidators = getSelectedItemName $pageForm['Validations'] $Language
                }
                elseif ($childName -eq "Last name") {
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
                elseif ($childName -eq "Surface Area") {
                    $SurfaceArea = $pageForm['Placeholder Text'] 
                    $SurfaceAreaValidators =  getSelectedItemName $pageForm['Validations'] $Language 
                }
                
            }

            $EmailaddressItem = Get-ChildItem -Path $page -Language $Language  | Where { $_.TemplateID -eq "{886ADEC1-ABF8-40E1-9926-D9189C4E8E1B}" }
            $Emailaddress = $EmailaddressItem['Placeholder Text']
            $EmailaddressValidators = getSelectedItemName $EmailaddressItem['Validations'] $Language 

            $MessageFormItem = Get-ChildItem -Path $page -Language $Language  | Where { $_.TemplateID -eq "{D8386D04-C1E3-4CD3-9227-9E9F86EF3C88}" }
            $MessageForm = $MessageFormItem['Placeholder Text']

            

            $obj = New-Object System.Object

            $obj | Add-Member -MemberType NoteProperty -Name "RentForm"-Value $RentForm
            $obj | Add-Member -MemberType NoteProperty -Name "Breadcrumbtitle"-Value $Breadcrumbtitle
            $obj | Add-Member -MemberType NoteProperty -Name "Showonbreadcrumb"-Value $Showonbreadcrumb
            $obj | Add-Member -MemberType NoteProperty -Name "RentLocalTitle"-Value $RentLocalTitle
            $obj | Add-Member -MemberType NoteProperty -Name "RentLocalDescription"-Value $RentLocalDescription
            $obj | Add-Member -MemberType NoteProperty -Name "BannerTitle"-Value $BannerTitle
            $obj | Add-Member -MemberType NoteProperty -Name "BackgroundImage"-Value $BackgroundImage
            $obj | Add-Member -MemberType NoteProperty -Name "LargeImage"-Value $LargeImage
            $obj | Add-Member -MemberType NoteProperty -Name "MobileImage"-Value $MobileImage
            $obj | Add-Member -MemberType NoteProperty -Name "TabletImage"-Value $TabletImage
            $obj | Add-Member -MemberType NoteProperty -Name "ThankYouTitle"-Value $ThankYouTitle
            $obj | Add-Member -MemberType NoteProperty -Name "ThankYouDescription"-Value $ThankYouDescription
            $obj | Add-Member -MemberType NoteProperty -Name "LegalNoticeTitle"-Value $LegalNoticeTitle
            $obj | Add-Member -MemberType NoteProperty -Name "LegalNoticeUnderneath"-Value $LegalNoticeUnderneath
            $obj | Add-Member -MemberType NoteProperty -Name "SEOParagraph"-Value $SEOParagraph
            $obj | Add-Member -MemberType NoteProperty -Name "OpenGraphImage"-Value $OpenGraphImage

            $obj | Add-Member -MemberType NoteProperty -Name "CanonicalUrl"-Value $CanonicalUrl
            $obj | Add-Member -MemberType NoteProperty -Name "ShowonMobile"-Value $ShowonMobile

            $obj | Add-Member -MemberType NoteProperty -Name "Brandname"-Value $Brandname
            $obj | Add-Member -MemberType NoteProperty -Name "BrandnameValidators"-Value $BrandnameValidators

            $obj | Add-Member -MemberType NoteProperty -Name "Companyname"-Value $Companyname
            $obj | Add-Member -MemberType NoteProperty -Name "CompanynameValidators"-Value $CompanynameValidators

            $obj | Add-Member -MemberType NoteProperty -Name "Lastname"-Value $Lastname
            $obj | Add-Member -MemberType NoteProperty -Name "LastnameValidators"-Value $LastnameValidators

            $obj | Add-Member -MemberType NoteProperty -Name "Firstname"-Value $Firstname
            $obj | Add-Member -MemberType NoteProperty -Name "FirstnameValidators"-Value $FirstnameValidators

            $obj | Add-Member -MemberType NoteProperty -Name "Emailaddress"-Value $Emailaddress
            $obj | Add-Member -MemberType NoteProperty -Name "EmailaddressValidators"-Value $EmailaddressValidators

            $obj | Add-Member -MemberType NoteProperty -Name "Phone"-Value $Phone
            $obj | Add-Member -MemberType NoteProperty -Name "PhoneValidators"-Value $PhoneValidators

            $obj | Add-Member -MemberType NoteProperty -Name "SurfaceArea"-Value $SurfaceArea
            $obj | Add-Member -MemberType NoteProperty -Name "SurfaceAreaValidators"-Value $SurfaceAreaValidators

            $obj | Add-Member -MemberType NoteProperty -Name "MessageForm"-Value $MessageForm
            $obj | Add-Member -MemberType NoteProperty -Name "ReCaptcha"-Value $ReCaptcha
            $obj | Add-Member -MemberType NoteProperty -Name "SubmitButton"-Value $SubmitButton

            $array.Add($obj) | Out-Null         
            Write-Host "[$($cpt)/$($count)]  ---- done" -ForegroundColor Green
            $cpt ++;

            
        }
        #end loop
        $array | Select-Object RentForm, Breadcrumbtitle, Showonbreadcrumb, RentLocalTitle, RentLocalDescription, BannerTitle, BackgroundImage, LargeImage, MobileImage, TabletImage, ThankYouTitle, ThankYouDescription, LegalNoticeTitle, LegalNoticeUnderneath, SEOParagraph, OpenGraphImage, CanonicalUrl,ShowonMobile, Brandname, BrandnameValidators, Companyname, CompanynameValidators, Lastname, LastnameValidators, Firstname, FirstnameValidators, Emailaddress, EmailaddressValidators, Phone, Phonevalidators, SurfaceArea, SurfaceAreaValidators, MessageForm, ReCaptcha, SubmitButton | Export-Csv -Encoding UTF8 -notypeinformation -Path $outputFilePath
        Try {
            Send-File -Path $outputFilePath
        }
        Finally {
            Remove-Item -Path $outputFilePath
        }
    }


}

$RegionName = "Denmark"
$MallName = "fields"
$Language = "da"
ExtractRentALocalForm $RegionName $MallName $Language