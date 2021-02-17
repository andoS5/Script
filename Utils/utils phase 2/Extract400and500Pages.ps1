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

function Extract400and500Pages {
    param (
        [Parameter(Mandatory = $true, Position = 0 )]
        [string]$RegionName,
        [Parameter(Mandatory = $true, Position = 1 )]
        [string]$MallName,
        [Parameter(Mandatory = $true, Position = 2 )]
        [string]$Language
    )

    process {
        $outputFilePath = "$($AppPath)/404 and 500 - $MallName.csv"
        $array = New-Object System.Collections.ArrayList
        $cpt = 1

        $StaticPagesRepository = "master:/sitecore/content/Klepierre/$RegionName/$MallName/Home/Static Pages Repository"
        $errorPages = Get-ChildItem -Path $StaticPagesRepository -Language $Language | Where { $_.TemplateID -eq "{073CC5A9-BED2-42EF-90B6-DD1A4CF0A593}" -or  $_.TemplateID -eq "{A09BCAB0-6EFA-45D8-A971-6135C90A9F7C}"}
        $count = $errorPages.Count
        foreach ($ep in $errorPages) {

            $PageName = $ep.Name
            $Breadcrumbtitle = $ep['Breadcrumb title']
            $Showonbreadcrumb = $ep['Show on breadcrumb']
            $BannerTitle = $ep['Banner Title']

            $BackgroundImage = if (![string]::IsNullOrEmpty($ep['Background Image'])) { Get-Name-By-ID (Get-Image-Item-Id $ep['Background Image']) }else { "" } 
            $LargeImage = if (![string]::IsNullOrEmpty($ep['Large Image'])) { Get-Name-By-ID (Get-Image-Item-Id $ep['Large Image']) }else { "" } 
            $MobileImage = if (![string]::IsNullOrEmpty($ep['Mobile Image'])) { Get-Name-By-ID (Get-Image-Item-Id $ep['Mobile Image']) }else { "" } 
            $TabletImage = if (![string]::IsNullOrEmpty($ep['Tablet Image'])) { Get-Name-By-ID (Get-Image-Item-Id $ep['Tablet Image']) }else { "" } 

            $Title = $ep['Title']
            $Description = $ep['Description']
            $Body = $ep['Body']

            $OpenGraphImage = if (![string]::IsNullOrEmpty($ep['Open Graph Image'])) { Get-Name-By-ID (Get-Image-Item-Id $ep['Open Graph Image']) }else { "" } 

        
            $CanonicalUrl = $ep['Canonical Url']
            $ShowonMobile = $ep['Show on Mobile']

            $obj = New-Object System.Object

            $obj | Add-Member -MemberType NoteProperty -Name "PageName"-Value $PageName
            $obj | Add-Member -MemberType NoteProperty -Name "Breadcrumbtitle"-Value $Breadcrumbtitle
            $obj | Add-Member -MemberType NoteProperty -Name "Showonbreadcrumb"-Value $Showonbreadcrumb
            $obj | Add-Member -MemberType NoteProperty -Name "BannerTitle"-Value $BannerTitle
            $obj | Add-Member -MemberType NoteProperty -Name "BackgroundImage"-Value $BackgroundImage
            $obj | Add-Member -MemberType NoteProperty -Name "LargeImage"-Value $LargeImage
            $obj | Add-Member -MemberType NoteProperty -Name "MobileImage"-Value $MobileImage
            $obj | Add-Member -MemberType NoteProperty -Name "TabletImage"-Value $TabletImage
            $obj | Add-Member -MemberType NoteProperty -Name "Title"-Value $Title
            $obj | Add-Member -MemberType NoteProperty -Name "Description"-Value $Description
            $obj | Add-Member -MemberType NoteProperty -Name "Body"-Value $Body
            $obj | Add-Member -MemberType NoteProperty -Name "OpenGraphImage"-Value $OpenGraphImage
            $obj | Add-Member -MemberType NoteProperty -Name "CanonicalUrl"-Value $CanonicalUrl
            $obj | Add-Member -MemberType NoteProperty -Name "ShowonMobile"-Value $ShowonMobile


            $array.Add($obj) | Out-Null         
            Write-Host "[$($cpt)/$($count)]  ---- done" -ForegroundColor Green
            $cpt ++;

        }
        $array | Select-Object PageName, Breadcrumbtitle,Showonbreadcrumb,BannerTitle,BackgroundImage,LargeImage,MobileImage,TabletImage,Title,Description,Body,OpenGraphImage,CanonicalUrl,ShowonMobile | Export-Csv -Encoding UTF8 -notypeinformation -Path $outputFilePath
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
Extract400and500Pages $RegionName $MallName $Language