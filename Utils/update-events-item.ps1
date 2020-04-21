function update-events-item{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0 )]
        [string]$RegionName,

        [Parameter(Mandatory = $true, Position = 1 )]
        [string]$MallName,

        [Parameter(Mandatory = $true, Position = 2 )]
        [string]$Language
      
    )

    begin{
        Write-Host "Update events item start"
    }

    process{
        $EventsFolder = "master:/sitecore/content/Klepierre/$RegionName/$MallName/Home/Events and News/Events"

        $Events = Get-ChildItem -Path $EventsFolder | Where { $_.TemplateID -eq "{4058CE82-4516-4650-A69E-162D72F766D6}"}

        foreach($event in $events){
            Write-Host $event.Name
        }

    }

    end{
        Write-Host "Update events item Done"
    }
}
update-events-item "Denmark" "fields" "da" 