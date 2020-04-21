function Extract-Url($rawString){
    $ID = ((Select-String 'id="(.*)}"' -Input $rawString).Matches.Value).replace("id=","").replace("`"","")
    $item =  Get-Item $ID
    return $item.FullPath
}
function Extract-Header-Contents{
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
        Write-Host "Export-Header-Contents Begin"
    }

    process {

        $outputFilePath = "$($AppPath)/Header_$($MallName).csv"
        $array = New-Object System.Collections.ArrayList

        $HeaderRepository = Get-Item -Path "master:/sitecore/content/Klepierre/$($RegionName)/$($MallName)/Home/Navigation Container/Header Repository" -Language $Language
        $HeaderRepositoryChildItem = Get-ChildItem -Path $HeaderRepository.FullPath -Language $Language
        
        $infoPratiqueITem = Get-Item -Path $HeaderRepositoryChildItem[0].FullPath -Language $Language
        $infoPratique = $infoPratiqueITem.Fields
        $infoPratiqueLink = ""
        if($infoPratique['Link'].Value -ne $null){
            $infoPratiqueLinkRaw = ((Select-String '(http[s]?)(:\/\/)([^\s,]+)(?=")' -Input $infoPratique['Link'].Value).Matches.Value)
            $infoPratiqueLink = if (![string]::IsNullOrEmpty($infoPratiqueLinkRaw)) { $infoPratiqueLinkRaw } else { Extract-Url($infoPratique['Link'].Value)}
        }
        

        $BoutiquesITem = Get-Item -Path $HeaderRepositoryChildItem[1].FullPath -Language $Language
        $Boutique = $BoutiquesITem.Fields
        $BoutiqueLink = ""
        if($Boutique['Link'].Value -ne $null){
            $BoutiqueLinkRaw = ((Select-String '(http[s]?)(:\/\/)([^\s,]+)(?=")' -Input $Boutique['Link'].Value).Matches.Value)
            $BoutiqueLink = if (![string]::IsNullOrEmpty($BoutiqueLinkRaw)) { $BoutiqueLinkRaw } else { Extract-Url($Boutique['Link'].Value) }
        }
        

        $BonPlamItem = Get-Item -Path $HeaderRepositoryChildItem[2].FullPath -Language $Language
        $BonPlan = $BonPlamItem.Fields
        $BonPlanLink = ""
        if($BonPlan['Link'].Value -ne $null){
            $BonPlanLinkRaw = ((Select-String '(http[s]?)(:\/\/)([^\s,]+)(?=")' -Input $BonPlan['Link'].Value).Matches.Value)
            $BonPlanLink = if (![string]::IsNullOrEmpty($BonPlanLinkRaw)) { $BonPlanLinkRaw } else {Extract-Url($BonPlan['Link'].Value)}
        }
        

        $ActusItem = Get-Item -Path $HeaderRepositoryChildItem[3].FullPath -Language $Language
        $Actus = $ActusItem.Fields
        $ActusLink = ""
        if($Actus['Link'].Value -ne $null){
            $ActusLinkRaw = ((Select-String '(http[s]?)(:\/\/)([^\s,]+)(?=")' -Input $Actus['Link'].Value).Matches.Value)
            $ActusLink = if (![string]::IsNullOrEmpty($ActusLinkRaw)) { $ActusLinkRaw } else {Extract-Url($Actus['Link'].Value)}
        }
        

        $CinemaItem = Get-Item -Path $HeaderRepositoryChildItem[3].FullPath -Language $Language
        $Cinema = $CinemaItem.Fields
        $CinemaLink = ""
        if($Cinema['Link'].Value -ne $null){
            $CinemaLinkRaw = ((Select-String '(http[s]?)(:\/\/)([^\s,]+)(?=")' -Input $Cinema['Link'].Value).Matches.Value)
            $CinemaLink = if (![string]::IsNullOrEmpty($CinemaLinkRaw)) { $CinemaLinkRaw } else {Extract-Url($Cinema['Link'].Value) }
        }
        

        $ServicesItem = Get-Item -Path $HeaderRepositoryChildItem[4].FullPath -Language $Language 
        $Services = $ServicesITem.Fields
        $ServicesLink = ""
        
        if($Services['Link'].Value -ne $null){
            $ServicesLinkRaw = ((Select-String '(http[s]?)(:\/\/)([^\s,]+)(?=")' -Input $Services['Link'].Value).Matches.Value)
            $ServicesLink = if (![string]::IsNullOrEmpty($ServicesLinkRaw)) { $ServicesLinkRaw } else { Extract-Url($Services['Link'].Value) }
        }


        $obj = New-Object System.Object

        $obj | Add-Member -MemberType NoteProperty -Name "infoPratiqueName" -Value  $infoPratique['Name'].value
        $obj | Add-Member -MemberType NoteProperty -Name "infoPratiqueLink" -Value  $infoPratiqueLink
        $obj | Add-Member -MemberType NoteProperty -Name "BoutiqueName" -Value  $Boutique["Name"].value
        $obj | Add-Member -MemberType NoteProperty -Name "BoutiqueLink" -Value  $BoutiqueLink
        $obj | Add-Member -MemberType NoteProperty -Name "BonPlanName" -Value  $BonPlan['Name'].value
        $obj | Add-Member -MemberType NoteProperty -Name "BonPlanLink" -Value  $BonPlanLink
        $obj | Add-Member -MemberType NoteProperty -Name "ActusName" -Value  $Actus['Name'].value
        $obj | Add-Member -MemberType NoteProperty -Name "ActusLink" -Value  $ActusLink
        $obj | Add-Member -MemberType NoteProperty -Name "CinemaName" -Value  $Cinema['Name'].value
        $obj | Add-Member -MemberType NoteProperty -Name "CinemaLink" -Value  $CinemaLink
        $obj | Add-Member -MemberType NoteProperty -Name "ServicesName" -Value  $Services['Name'].value
        $obj | Add-Member -MemberType NoteProperty -Name "ServicesLink" -Value  $ServicesLink
        
        $array.Add($obj) | Out-Null

        $array | Select-Object infoPratiqueName, infoPratiqueLink, BoutiqueName, BoutiqueLink, BonPlanName, BonPlanLink, ActusName, ActusLink, CinemaName, CinemaLink, ServicesName, ServicesLink | Export-Csv -Encoding UTF8 -notypeinformation -Path $outputFilePath
        Try {
            Send-File -Path $outputFilePath
        }
        Finally {
            Remove-Item -Path $outputFilePath
        }
    }
    end{
        Write-Host "Export-Header-Contents End"
    }
}

Extract-Header-Contents "Master Region" "fr-fr" "Alpha-Fr"