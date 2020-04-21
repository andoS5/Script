function Content-Update-Page-Design
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0 )]
        [string]$RegionNameName,

        [Parameter(Mandatory = $true, Position = 1 )]
        [string]$Language,

        [Parameter(Mandatory = $true, Position = 2 )]
        [string]$MallNameName
    )

    begin { 
        Write-Host "Update Page designBegin"
        Import-Function Utils-Upload-CSV-File
    }
    process {
        $pageDesing = Utils-Upload-CSV-File -Title "Update Page Design" -Description "Please!Choose pageDesign.csv"
        foreach($p in $pageDesing){
            $page = $p."Page".Replace("{region}",$RegionNameName).Replace("{mall}",$MallNameName)
            $pageDesign = $p."Page Design"
                
            if((Test-Path -Path "master:$($page)" -ErrorAction SilentlyContinue) -and ((Test-Path -Path "master:$($pageDesign)" -ErrorAction SilentlyContinue))){
                
                $pageDesingItem = Get-Item -Path "master:$($pageDesign)" -Language "en"
                Write-Host "Update "$pageDesingItem.Name
                $pgeDesignID = $pageDesingItem.ID
                $pageItem = Get-Item -Path "master:$($page)" -Language $Language
                $pageItem.Editing.BeginEdit() | Out-Null
                $pageItem["Page Design"] = $pgeDesignID
                $pageItem.Editing.EndEdit() | Out-Null
            }else{
                Write-Host "Path: $page or $pageDesign doesn't exist"
            }
        }
    }end {
        Write-Host "Update Page Design End..."
    }
}