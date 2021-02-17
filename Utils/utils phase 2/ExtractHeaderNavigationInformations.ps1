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
function ExtractHeaderNavigationInformations {
    param (
        [Parameter(Mandatory = $true, Position = 0 )]
        [string]$RegionName,
        [Parameter(Mandatory = $true, Position = 1 )]
        [string]$MallName,
        [Parameter(Mandatory = $true, Position = 2 )]
        [string]$Language
    )

    process {
        $outputFilePath = "$($AppPath)/Header Navigation pages - $MallName.csv"
        $array = New-Object System.Collections.ArrayList
        $cpt = 1

        $HeaderRepository = "master:/sitecore/content/Klepierre/$RegionName/$MallName/Home/Navigation Container/Header Repository"

        $HeaderNavigations = Get-ChildItem -Path $HeaderRepository -Language $Language | Where { $_.TemplateID -eq "{15E37AE9-EF00-4679-A39C-877B64C99CC8}" }
        $count = $HeaderNavigations.Count

        foreach ($navigation in $HeaderNavigations) {
            $NavigationPageName = $navigation.Name
            $Name = $navigation['Name']
            $TealiumPageName = $navigation['Tealium Page Name']
            $ShowInSitemap = $navigation['Show In Sitemap']
            $IsExternalLink = if($navigation['Is External Link'] -eq ""){0}else {1}
            $Link = ""
            if ($IsExternalLink -eq 1) {
                $Link = $navigation['Link']
            }
            elseif ($IsExternalLink -eq 0) {
                $Link = if (![string]::IsNullOrEmpty($navigation['Link'])) { Get-Name-By-ID (Get-Image-Item-Id $navigation['Link']) }else { "" }
            }
            $ShowChildren = $navigation['Show Children']
            $IsActive = $navigation['Is Active']

            $obj = New-Object System.Object
            $obj | Add-Member -MemberType NoteProperty -Name "NavigationPageName"-Value $NavigationPageName
            $obj | Add-Member -MemberType NoteProperty -Name "Name"-Value $Name
            $obj | Add-Member -MemberType NoteProperty -Name "TealiumPageName"-Value $TealiumPageName
            $obj | Add-Member -MemberType NoteProperty -Name "ShowInSitemap"-Value $ShowInSitemap
            $obj | Add-Member -MemberType NoteProperty -Name "Link"-Value $Link
            $obj | Add-Member -MemberType NoteProperty -Name "IsExternalLink"-Value $IsExternalLink
            $obj | Add-Member -MemberType NoteProperty -Name "ShowChildren"-Value $ShowChildren
            $obj | Add-Member -MemberType NoteProperty -Name "IsActive"-Value $IsActive

            $array.Add($obj) | Out-Null       

            Write-Host "[$($cpt)/$($count)]  ---- done" -ForegroundColor Green
            $cpt ++;
        }
        $array | Select-Object NavigationPageName, Name,TealiumPageName,ShowInSitemap,Link,IsExternalLink,ShowChildren,IsActive | Export-Csv -Encoding UTF8 -notypeinformation -Path $outputFilePath
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
ExtractHeaderNavigationInformations $RegionName $MallName $Language