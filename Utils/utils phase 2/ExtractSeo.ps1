function ExtractSeo{

    param (
        [Parameter(Mandatory = $true, Position = 0 )]
        [string]$RegionName,
        [Parameter(Mandatory = $true, Position = 1 )]
        [string]$MallName,
        [Parameter(Mandatory = $true, Position = 2 )]
        [string]$Language
    )
    process {
        $outputFilePath = "$($AppPath)/SEO - $MallName.csv"
        $array = New-Object System.Collections.ArrayList

        $MetaRepository = "master:/sitecore/content/Klepierre/Meta Repository"
        $MetaRepositories = Get-ChildItem -Path $MetaRepository -Language $Language

        foreach ($item in $MetaRepositories) {
            $TemplateName = $item['Template Name']
            $MetaTitle = $item['Meta Title']
            $MetaDescription = $item['Meta Description']

            $obj = New-Object System.Object

            $obj | Add-Member -MemberType NoteProperty -Name "ItemName"-Value $item.Name
            $obj | Add-Member -MemberType NoteProperty -Name "TemplateName"-Value $TemplateName
            $obj | Add-Member -MemberType NoteProperty -Name "MetaTitle"-Value $MetaTitle
            $obj | Add-Member -MemberType NoteProperty -Name "MetaDescription"-Value $MetaDescription
            

            $array.Add($obj) | Out-Null 
          
            # Write-Host "$itemPath  ---- done" -ForegroundColor Green
        }
        $array | Select-Object ItemName, TemplateName, MetaTitle, MetaDescription | Export-Csv -Encoding UTF8 -notypeinformation -Path $outputFilePath
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
ExtractSeo $RegionName $MallName $Language