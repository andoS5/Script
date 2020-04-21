function Scaffolding-Import-Mall-From-Csv-Media-Library {
  [CmdletBinding()]
  param()

  begin {
    Write-Host "Cmdlet Import-Mall-From-Excel - Begin"
    Import-Function Utils-Get-From-Csv-Media-Library
    Import-Function Scaffolding-New-Mall
  }

  process {
    $media = Get-Item "/sitecore/media library"

    # Note: shorten for the blog post. you would want tooltips

    $dialog = Read-Variable -Parameters `
    @{ Name = "media"; Title = "Source"; Root = "/sitecore/media library/"; Editor = "item" } `
      -Description "This script will convert CSV data into malls." `
      -Width 800 -Height 600 `
      -Title "Import malls from CSV" `
      -OkButtonName "Import" `
      -CancelButtonName "Cancel"

    if ($dialog -ne "ok") {
      Exit
    }

    Write-Host "Cmdlet Import-Mall-From-Excel - Process"
		
    $collection = Utils-Get-From-Csv-Media-Library $media

    foreach($mall in $collection) {
      Scaffolding-New-Mall $mall["Region Name"] $mall["Language"] $mall["Mall Name"]
    }
  }
	
  end {
    Write-Host "Cmdlet Import-Mall-From-Excel - End"
  }
}