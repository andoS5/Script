function Get-Name-By-ID($ID) {
   
    if (![string]::IsNullOrEmpty($ID)) {

        return (Get-Item master: -ID $ID).Name
    }    
    
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

function ExtractfooterNavigationInformation {
    param (
        [Parameter(Mandatory = $true, Position = 0 )]
        [string]$RegionName,
        [Parameter(Mandatory = $true, Position = 1 )]
        [string]$MallName,
        [Parameter(Mandatory = $true, Position = 2 )]
        [string]$Language
    )

    process {
        $outputFilePath = "$($AppPath)/Footer Navigation pages - $MallName.csv"
        $array = New-Object System.Collections.ArrayList

        $FooterRepository = "master:/sitecore/content/Klepierre/$RegionName/$MallName/Home/Navigation Container/Footer Repository"
        $FooterNavigations = Get-ChildItem -Path $FooterRepository -Language $Language -Recurse
        foreach ($fn in $FooterNavigations) {

            
            $TemplatePath = ""
            $SocialMediIcon = ""
            $SocialMediLink = ""
            $contactText = ""
            $Name = ""
            $Tealium = ""
            $ShowInSitemap = ""
            $link = ""
            $IsExternalLink = ""
            $ShowChildren = ""
            $IsActive = ""

            if ($fn.TemplateID -eq "{2ED7C87B-C8A2-4531-88CC-4BC0706DD57A}") {
                
                $TemplatePath = $fn.FullPath
                $SocialMediIcon = if (![string]::IsNullOrEmpty($fn["Social Media Icon"])) { Get-Name-By-ID (Get-Image-Item-Id $fn["Social Media Icon"]) }else { "" }
                $SocialMediLink = if (![string]::IsNullOrEmpty($fn["Social Media Link"])) { Get-Name-By-ID (Get-Image-Item-Id $fn["Social Media Link"]) }else { "" }
            }
            elseif ($fn.TemplateID -eq "{7DB385F8-8202-4D41-8790-7ED49125AFCA}" -or $fn.TemplateID -eq "{7EAD16C1-C51B-45EE-BDD4-82BF9ABB4BB9}") {

                $TemplatePath = $fn.FullPath
                $Name = $fn["Name"]
                $Tealium = $fn["Tealium Page Name"]
                $ShowInSitemap = $fn["Show In Sitemap"]
                $IsExternalLink = if ($fn['Is External Link'] -eq "") { 0 }else { 1 }
              
                if ($IsExternalLink -eq 0) {
                    $link = if ($fn['Link'].Contains('{')) { Get-Name-By-ID (Get-Image-Item-Id $fn['Link']) } else { "" }
                   
                }
                elseif ($IsExternalLink -eq 1) {
                    $Link = if ($fn['Link'].Contains("http")) { ((Select-String '(http[s]?)(:\/\/)([^\s,]+)(?=")' -Input $fn['Link']).Matches.Value) }else { "" }
                }

                $ShowChildren = $fn["Show Children"]
                $IsActive = $fn["Is Active"]
            }
            else {
                $TemplatePath = $fn.FullPath
                $SocialMediIcon = ""
                $SocialMediLink = ""
                $contactText = ""
                $Name = ""
                $Tealium = ""
                $ShowInSitemap = ""
                $link = ""
                $IsExternalLink = ""
                $ShowChildren = ""
                $IsActive = ""
            }

            $obj = New-Object System.Object

            $obj | Add-Member -MemberType NoteProperty -Name "TemplatePath"-Value $TemplatePath
            $obj | Add-Member -MemberType NoteProperty -Name "SocialMediIcon"-Value $SocialMediIcon
            $obj | Add-Member -MemberType NoteProperty -Name "SocialMediLink"-Value $SocialMediLink
            $obj | Add-Member -MemberType NoteProperty -Name "contactText"-Value $contactText
            $obj | Add-Member -MemberType NoteProperty -Name "Name"-Value $Name
            $obj | Add-Member -MemberType NoteProperty -Name "Tealium"-Value $Tealium
            $obj | Add-Member -MemberType NoteProperty -Name "ShowInSitemap"-Value $ShowInSitemap
            $obj | Add-Member -MemberType NoteProperty -Name "link"-Value $link
            $obj | Add-Member -MemberType NoteProperty -Name "IsExternalLink"-Value $IsExternalLink
            $obj | Add-Member -MemberType NoteProperty -Name "ShowChildren"-Value $ShowChildren
            $obj | Add-Member -MemberType NoteProperty -Name "IsActive"-Value $IsActive

            $array.Add($obj) | Out-Null 
          
            Write-Host "$TemplatePath  ---- done" -ForegroundColor Green
         

        }
        $array | Select-Object TemplatePath, SocialMediIcon, SocialMediLink, contactText, Name, Tealium, ShowInSitemap, link, IsExternalLink, ShowChildren, IsActive | Export-Csv -Encoding UTF8 -notypeinformation -Path $outputFilePath
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
ExtractfooterNavigationInformation $RegionName $MallName $Language