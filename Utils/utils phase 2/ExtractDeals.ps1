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
        $ResultRegex = "(?<=`"{)(.*)(?=}`")"

        $Regex = [Regex]::new("$ResultRegex")       
        $Result = $Regex.Match($RawValue)   
        if ($Result.Success) {           
            return "{$($Result.Value)}"         
        }
    }
}
function formatDate($RawValueDate) {
    if ($null -ne $RawValueDate -and $RawValueDate.Contains('T')) {
        return "$($RawValueDate.Substring(4,2))-$($RawValueDate.Substring(6,2))-$($RawValueDate.Substring(0,4))"
    }
}
function ExtractDeals {
    param (
        [Parameter(Mandatory = $true, Position = 0 )]
        [string]$RegionName,
        [Parameter(Mandatory = $true, Position = 1 )]
        [string]$MallName,
        [Parameter(Mandatory = $true, Position = 2 )]
        [string]$Language
    )
    
    process {
        $outputFilePath = "$($AppPath)/Static pages - $MallName.csv"
        $array = New-Object System.Collections.ArrayList
        $cpt = 1

        $DealsRepository = "master:/sitecore/content/Klepierre/$RegionName/$MallName/Home/Deals"

        $Deals = Get-ChildItem -Path $DealsRepository -Language $Language 
        $count = $Deals.Count

        foreach ($deal in $Deals) {
            $DealType = ""

            if($deal.TemplateID -eq "{1E5EE0F2-5E21-47E8-A6C3-E815D69C3A2C}"){
                $DealType = "No Image Deal"
            }elseif ($deal.TemplateID -eq "{C1243F21-AEA1-4C28-A7A0-FEE22A74B440}") {
                $DealType = "Full Image Deal"
            }elseif ($deal.TemplateID -eq "{989FCBF1-82F3-491F-BA5B-536759FEA27F}") {
                $DealType = "Simple Deal"
            }else{
                $DealType = ""
            }

            $Title = $deal['Title']
            $Brand = Get-Name-By-ID ($deal['Brand'])
            $StartDate = formatDate($deal['Start Date'])
            $EndDate = formatDate($deal['End Date'])
            $Conditions = $deal['Conditions']
            $DealDescription = $deal['Deal Description']
            $CampaignType = $deal['Campaign Type']
            $Mall = Get-Name-By-ID ($deal['Mall'])
            $ShowonMobile = $deal['Show on Mobile']
            $ResponsiveImage =  if (![string]::IsNullOrEmpty($deal['Responsive Image'])) { Get-Name-By-ID (Get-Image-Item-Id $deal['Responsive Image']) }else { "" }
            $DealImage = if (![string]::IsNullOrEmpty($deal['Deal Image'])) { Get-Name-By-ID (Get-Image-Item-Id $deal['Deal Image']) }else { "" }

            $obj = New-Object System.Object
            $obj | Add-Member -MemberType NoteProperty -Name "DealType"-Value $DealType
            $obj | Add-Member -MemberType NoteProperty -Name "Title"-Value $Title
            $obj | Add-Member -MemberType NoteProperty -Name "Brand"-Value $Brand
            $obj | Add-Member -MemberType NoteProperty -Name "StartDate"-Value $StartDate
            $obj | Add-Member -MemberType NoteProperty -Name "EndDate"-Value $EndDate
            $obj | Add-Member -MemberType NoteProperty -Name "Conditions"-Value $Conditions
            $obj | Add-Member -MemberType NoteProperty -Name "DealDescription"-Value $DealDescription
            $obj | Add-Member -MemberType NoteProperty -Name "CampaignType"-Value $CampaignType
            $obj | Add-Member -MemberType NoteProperty -Name "Mall"-Value $Mall
            $obj | Add-Member -MemberType NoteProperty -Name "ShowonMobile"-Value $ShowonMobile
            $obj | Add-Member -MemberType NoteProperty -Name "ResponsiveImage"-Value $ResponsiveImage
            $obj | Add-Member -MemberType NoteProperty -Name "DealImage"-Value $DealImage

            $array.Add($obj) | Out-Null         
            Write-Host "[$($cpt)/$($count)]  ---- done" -ForegroundColor Green
            $cpt ++;

        }
        $array | Select-Object DealType,Title, Brand, StartDate, EndDate, Conditions, DealDescription, CampaignType, Mall, ShowonMobile, ResponsiveImage, DealImage | Export-Csv -Encoding UTF8 -notypeinformation -Path $outputFilePath
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
ExtractDeals $RegionName $MallName $Language
