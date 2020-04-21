function Import-Content-Resource-Key {
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
        Write-Host "Import resource Key...Begin" 
        Import-Function Utils-Upload-CSV-File
    }
    process{
        $ressourceKeyFile = Utils-Upload-CSV-File -Title "Import Ressource Key"

        $path = "master:/sitecore/content/Klepierre/$($RegionName)/$($MallName)"

        foreach ($res in $ressourceKeyFile){
            $ressKey = $res."Resource Key".Trim()
            $field = $res."Field".Trim()
            $value = $res."Local translation".Trim()
            $pathRessKey = $path + $ressKey
            try{
                if((Test-Path -Path $pathRessKey) -and !([string]::IsNullOrEmpty($ressKey)))
                {
                    $itemToUpdated = Get-Item -Path $pathRessKey -Language $Language
                    $itemToUpdated.Editing.BeginEdit()
                        $itemToUpdated[$field] = $value
                    $itemToUpdated.Editing.EndEdit()| Out-Null
                    Write-Host "Done for $pathRessKey"
                }else{
                    Write-Host "Path $pathRessKey doesn't exist"
                }
            }catch{
                Write-Host "Failed For $ressKey" -BackgroundColor Red
            }
        }
    }end{
        Write-Host "Import resource key COMPLETED"
    }
}
