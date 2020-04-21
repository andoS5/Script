function Run-Scaffolding-Settings {
    begin {
        Write-Host "RUN Scaffolding  - Begin"
        Import-Function Scaffolding-Import-Mall-From-Csv
        Import-Function Scaffolding-Set-Settings-Mall-From-CSV
    }
    process {
        Write-Host "Scaffold..."
        Scaffolding-Import-Mall-From-Csv
        Write-Host "Scafold finished..."
        Write-Host "Update Settings..."
        Scaffolding-Set-Settings-Mall-From-CSV
    }
    end {
        Write-Host "Scaffolding COMPLETED" -BackgroundColor Green
    }
}