function Utils-Get-From-Csv-Media-Library {
  [CmdletBinding()]
  param([Parameter(Mandatory = $true, Position = 0 )]
    [item]$media
  )
	
  begin {
    #Write-Host "Cmdlet Import-From-Csv - Begin"
    Import-Function Utils-Convert-PSObject-To-Hashtable
  } 

  process {
    # Read media stream into a byte array
    [system.io.stream]$body = $media.Fields["blob"].GetBlobStream()
    try {
      $contents = New-Object byte[] $body.Length
      $body.Read($contents, 0, $body.Length) | Out-Null
    } 
    finally {
      $body.Close()    
    }

    # Convert the stream into a collection of objects
    $csv = [System.Text.Encoding]::Default.GetString($contents) | ConvertFrom-Csv

    $bulk = New-Object "Sitecore.Data.BulkUpdateContext"
    try {
      $elements = @();
      foreach ($record in $csv) {
        $hash = Utils-Convert-PSObject-To-Hashtable $record

        $elements += NormalizeObject $hash
      }
      $elements
    }
    finally {
      $bulk.Dispose()
    }
  }

  end {
    #Write-Host "Cmdlet Import-From-Csv - End"
  }
}

function NormalizeObject {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true, Position = 0)]
    $InputObject
  )
	
  begin {
    #Write-Host "Cmdlet Utils-Convert-PSObject-To-Hashtable - Begin"
  } 

  process {
    
    $normalized = $InputObject.Clone()
    foreach ($key in $InputObject.keys) {
      #Normalize Values
      $value = [System.Web.HttpUtility]::HtmlDecode($normalized.$key)
      $normalized.$key = $value 
      
      #Normalize Keys
      $newKey = $key -replace "ï»¿", ""
      if ($newKey -ne $key) {
        $normalized.Add($newKey, $normalized.$key);
        $normalized.Remove($key);
      }
    }
    
    $normalized
  }

  end {
    #Write-Host "Cmdlet Utils-Convert-PSObject-To-Hashtable - End"
  }
}