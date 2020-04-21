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