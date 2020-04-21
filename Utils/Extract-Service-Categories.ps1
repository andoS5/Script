import-Function IsDerived

function Extract-Service-Categories{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0 )]
        [string]$RegionName,
    
        [Parameter(Mandatory = $true, Position = 1 )]
        [string]$Language
    )
    begin {
        Write-Host "Extract Service Categories Begin"
        Import-function Utils-IsDerived
    }

    process{

        $outputFilePath = "$($AppPath)/$($RegionName)-Service-Categories.csv"
        $StoresCategoryRepositoryPath = "master:/sitecore/content/Klepierre/$($RegionName)/Service Category Repository"
        $scrItems = Get-Item -Path $StoresCategoryRepositoryPath -Language $Language
        $scrChildItems = $scrItems.Children | Where-Object {$_ |Utils-IsDerived -TemplateId "{C96D2C04-2557-45BC-9B39-000596DA0C1E}"}

        $obj = @()
        foreach($src in $scrChildItems){
            $fields = $src.Fields
            $obj += [pscustomobject] @{
                CategoryName  = $src.ID
                CategoryID  = $src.Name
                # Label = $fields['Service Label']
            }   
            Write-Host $src.Name 
            Write-Host "done ..." -BackgroundColor white -ForegroundColor Black
        }

        
        
        $obj | Export-Csv -Path $outputFilePath -Encoding UTF8 -NoTypeInformation 

        Try {
            Send-File -Path $outputFilePath
        }
        Finally {
            Remove-Item -Path $outputFilePath
        }
    }

    end {
        Write-Host "Extract Service Categories End" -BackgroundColor Green
    }

}

Extract-Service-Categories "Spain" "es-ca"
