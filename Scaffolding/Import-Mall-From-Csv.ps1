function Scaffolding-Import-Mall-From-Csv {
  [CmdletBinding()]
  param()
	
  begin {
    Write-Host "Cmdlet Scaffolding-Import-Mall-From-Csv - Begin"
    Import-Function Utils-Upload-CSV-File
    Import-Function Scaffolding-New-Mall
  } 

  process {
    $collection = Utils-Upload-CSV-File -title "Scaffolding" -description "Please Upload a CSV file"

    foreach($mall in $collection) {
      Scaffolding-New-Mall $mall["Region Name"] $mall["Language"] $mall["Mall Name"]
    }
  }

  end {
    Write-Host "Cmdlet Scaffolding-Import-Mall-From-Csv - End"
  }
}