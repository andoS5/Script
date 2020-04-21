function Scaffolding-New-Region {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true, Position = 0 )]
    [string]$region,

    [Parameter(Mandatory = $true, Position = 1 )]
    [string]$language
  )

  begin {
    Write-Host "Cmdlet Scaffolding-New-Region - Begin"
  }

  process {
    if ($region) {
      $branchTemplateRegionPath = "/sitecore/templates/Branches/Foundation/Kortex/Klepierre Region"
	    	$destinationPathRegion = "/sitecore/content/Klepierre"
      New-Item -Path $destinationPathRegion -Name $region -ItemType $branchTemplateRegionPath -Language $language | Out-Null
    }
  }

  end {
    Write-Host "Cmdlet Scaffolding-New-Region - End"
  }
}