function ExtractAllRessourceKey {
    param (
        [Parameter(Mandatory = $true, Position = 0 )]
        [string]$RegionName,
        [Parameter(Mandatory = $true, Position = 1 )]
        [string]$MallName,
        [Parameter(Mandatory = $true, Position = 2 )]
        [string]$Language
    )
    process {
        $outputFilePath = "$($AppPath)/All Ressource Keys - $MallName.csv"
        $array = New-Object System.Collections.ArrayList

        $RessourceKeyRepository = "master:/sitecore/content/Klepierre/$RegionName/$MallName/Resource Keys"
        $RessourceKeys = Get-ChildItem -Path $RessourceKeyRepository -Language $Language -Recurse

        foreach ($rk in $RessourceKeys) {
            $itemPath = ""
            $ItemName = ""
            $phrase = ""

            if ($rk.TemplateID -eq "{87B5C7E6-1EFF-4AE2-8E28-AB3668399F91}") {
                $itemPath = $rk.FullPath
                $ItemName = $rk.Name
                $phrase = $rk.Phrase
            }else{
                $itemPath = $rk.FullPath
                $ItemName = ""
                $phrase = ""
            }

            $obj = New-Object System.Object

            $obj | Add-Member -MemberType NoteProperty -Name "itemPath"-Value $itemPath
            $obj | Add-Member -MemberType NoteProperty -Name "ItemName"-Value $ItemName
            $obj | Add-Member -MemberType NoteProperty -Name "phrase"-Value $phrase
            

            $array.Add($obj) | Out-Null 
          
            Write-Host "$itemPath  ---- done" -ForegroundColor Green
        }
        $array | Select-Object itemPath, ItemName, phrase | Export-Csv -Encoding UTF8 -notypeinformation -Path $outputFilePath
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
ExtractAllRessourceKey $RegionName $MallName $Language