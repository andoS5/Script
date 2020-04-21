

function Utils-Convert-PSObject-To-Hashtable {
    [CmdletBinding()]
    param (
      [Parameter(ValueFromPipeline)]
      $InputObject
    )
      
    begin {
      #Write-Host "Cmdlet Utils-Convert-PSObject-To-Hashtable - Begin"
    }
  
    process {
      if ($null -eq $InputObject) { return $null }
  
      if ($InputObject -is [System.Collections.IEnumerable] -and $InputObject -isnot [string]) {
        $collection = @(
          foreach ($object in $InputObject) { Utils-Convert-PSObject-To-Hashtable $object }
        )
  
        #Write-Output -NoEnumerate $collection
        $collection
      }
      elseif ($InputObject -is [psobject]) {
        $hash = @{ }
  
        foreach ($property in $InputObject.PSObject.Properties) {
          $hash[$property.Name] = Utils-Convert-PSObject-To-Hashtable $property.Value
        }
  
        $hash
      }
      else {
        $InputObject
      }
    }
      
    end {
      #Write-Host "Cmdlet Utils-Convert-PSObject-To-Hashtable - End"
    }
  }

  function Utils-Upload-CSV-File {
	param(
		[Parameter(Mandatory = $false)]
    	[string]$title,
              [Parameter(Mandatory = $false)]
    	[string]$delimiter = ",",
	    [Parameter(Mandatory = $false)]
	    [string]$description
  	)
	$dataFolder = [Sitecore.Configuration.Settings]::DataFolder
	$tempFolder = $dataFolder + "\temp\upload"
	$filePath1 = Receive-File -Path $tempFolder -overwrite -Title $title -Description $description
	if (!(Test-Path -Path $filePath1 -ErrorAction SilentlyContinue)) {
		Write-Host "Canceled"
		Exit
	}
	$fileCSV = Import-Csv -Delimiter $delimiter  $filePath1
	$CSVToHash = Utils-Convert-PSObject-To-Hashtable $fileCSV
	
	return $CSVToHash
}

function update-Phone-Number{
    param (
        [Parameter(Mandatory = $true, Position = 0 )]
        [string]$RegionName,

        [Parameter(Mandatory = $true, Position = 1 )]
        [string]$MallName,
        
        [Parameter(Mandatory = $true, Position = 2 )]
        [string]$Language
    )

    begin{
        Write-Host "Update Shop Contact - Begin" -ForegroundColor Yellow
    }

    process{
        $path = "master:/sitecore/content/Klepierre/$RegionName/$MallName/Home/Shop Repository"
        $shops = Get-ChildItem -Path $path -Language $Language | Where { $_.TemplateID -eq "{80D19FA2-B1EF-4E32-93BD-4B2C650A126F}" -or $_.TemplateID -eq "" }
    }

    end{
        Write-Host "Done" -ForegroundColor Green -BackgroundColor White
    }
}