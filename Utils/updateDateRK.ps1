function updateDateRK{
    begin{
        Write-Host "Starting update Date on Tile"
    }
    process{
        $mallRepository = "master:/sitecore/content/Klepierre/France"

        $Children = Get-ChildItem -Path $mallRepository -Language "Fr-Fr"| Where { $_.TemplateID -eq "{46591E02-8902-4C2C-AF61-3EB92BE2489A}" }
        foreach ($Child in $Children) {
            $mallName = $Child.Name
            $RangeDateRessourceKey = "master:/sitecore/content/Klepierre/France/$mallName/Resource Keys/Events/Range Dates"
            $item = Get-Item -Path $RangeDateRessourceKey -Language "Fr-fr"

            Write-Host "$mallName Before " $item["Phrase"] -ForegroundColor Yellow
            $item.Editing.BeginEdit() | Out-Null
            $item["Phrase"] = "Du {0} au {1}"
            $item.Editing.EndEdit() | Out-Null
            Write-Host "$mallName After " $item["Phrase"] -ForegroundColor Green
        }
    }
    end{
        Write-Host "Update Done"
    }
}
updateDateRK