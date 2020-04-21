function RewriteRules{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0 )]
        [string]$RegionName,
  
        [Parameter(Mandatory = $true, Position = 1 )]
        [string]$Language,
  
        [Parameter(Mandatory = $true, Position = 2 )]
        [string]$MallName
    )

    begin{
        Write-Host "Starting URL Routing"
    }

    process{
        $AlphaURLRouting = "/sitecore/content/Klepierre/Master Region/Alpha/Settings/URL Routing"

        #Get Malls per Region
        $RegionPath = "/sitecore/content/Klepierre/$RegionName"

    }

    end{
        Write-Host "Ending URL Routing"
    }
}