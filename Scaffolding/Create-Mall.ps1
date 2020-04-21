function Scaffolding-Create-Mall {

  begin {
    Write-Host "Cmdlet Create Mall - Begin"
    import-function Utils-IsDerived
    import-function Scaffolding-New-Mall
  }

  process {
    $languageContainer = Get-Item -Path master: -ID "{64C4F646-A3FA-4205-B98E-4DE2C609B60F}"
    $languageItem = $languageContainer.Children | Where-Object { $_ | Utils-IsDerived -TemplateId "{F68F13A6-3395-426A-B9A1-FA2DC60D94EB}" }
    $languages = @{ }
    $languageItem | ForEach-Object {
      $languages.add($_.Name.ToLower(), $_.Name) | Out-Null
    }

    $props = @{
		    Parameters = @(
        @{Name = "MallName"; Title = "Enter name of site*"; lines = 1; Tooltip = "Enter name of Mall" }
        @{Name = "RegionName"; Title = "Enter Region*"; lines = 1; Tooltip = "Enter region" }
        @{Name = "Language"; Title = "Select Version*"; Options = $languages; Tooltip = "Choose one." }
		    )
		    Title      = "Create a new Klepierre site"
		    Width      = 500
		    Height     = 300
		    ShowHints  = $true
    }

    $result = Read-Variable @props
    if ($result -ne "ok") {
		    Write-Host "Cancelled"
		    Exit
    }

    if (!($RegionName) -or !($MallName)) {
      Write-Host "Sitename and region are mandatory! Please filled"	-BackgroundColor Yellow
      Exit
    }

    Scaffolding-New-Mall $RegionName $Language $MallName
  }

  end {
    Write-Host "Cmdlet Create Mall - End"
  }
}