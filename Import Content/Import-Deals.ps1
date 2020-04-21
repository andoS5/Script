function Import-Content-Deals {
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
      Write-Host "Process Deals page"
  }

  process {
    $path = "/sitecore/content/Klepierre/$($RegionName)/$($MallName)/Home/Deals"
    $dealsRepositoryItem = Get-Item -Path $path -Language  $Language

    $dealsRepositoryItem.Editing.BeginEdit() | Out-Null
    $dealsRepositoryItem["Background Image"] = '<image mediaid="{200EAF5E-49E1-4E9D-901A-0D5D02621130}" alt="Background Image" height="" width="" hspace="" vspace="" />'
    $dealsRepositoryItem["Mobile Image"] = '<image mediaid="{B0A0A417-41FA-4CEC-ABD9-C05495281364}" alt="Mobile Image" height="" width="" hspace="" vspace="" />'
    $dealsRepositoryItem["Tablet Image"] = '<image mediaid="{A8D4A475-1880-40C7-B827-07FAD42EDA8C}" alt="Tablet Image" height="" width="" hspace="" vspace="" />'
    $dealsRepositoryItem["Large Image"] = '<image mediaid="{18026B69-2071-4304-AAAC-BF6EF8E74FDB}" alt="Large Image" height="" width="" hspace="" vspace="" />'

    $dealsRepositoryItem.Editing.EndEdit() | Out-Null
  }
  end {
      Write-Host "Deals page done"
  }
}