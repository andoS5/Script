function Content-Upload-Home-Page-Images {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true, Position = 0 )]
    [string]$RegionName,
  
    [Parameter(Mandatory = $true, Position = 1 )]
    [string]$Language,
  
    [Parameter(Mandatory = $true, Position = 2 )]
    [string]$MallName,
  
    [Parameter(Mandatory = $true, Position = 3 )]
    [string]$ContentType
  )
  
  begin {
    Write-Host "Upload-Home-Page-Image - Begin"
  }
  
  process {
      
    $siteName = $MallName -Replace '[\W]', '-'
  
    $mediaFolderPath = "master:/sitecore/media library/Project/Klepierre/$($RegionName)/$($siteName)/Home-Page"
      
    if (!(Test-Path -Path $mediaFolderPath -ErrorAction SilentlyContinue)) {
      New-Item -Path $mediaFolderPath -ItemType "/sitecore/templates/System/Media/Media folder" | Out-Null
      <# Get-Item $path | `
          Add-ItemLanguage -TargetLanguage $Language #>
    }
  
    $path = "$($mediaFolderPath)/$($ContentType)"
  
    if (!(Test-Path -Path $path -ErrorAction SilentlyContinue)) {
      New-Item -Path $path -ItemType "/sitecore/templates/System/Media/Media folder" | Out-Null
      <# Get-Item $path | `
          Add-ItemLanguage -TargetLanguage $Language #>
    }
  
    Receive-File (Get-Item $path) -AdvancedDialog | Out-Null
  
    Write-Host "Images have been uploaded"
  
    Write-Host "Update Alt text - Begin"
    $logoImagePath = "$($mediaFolderPath)/Logo"
    $logoImageChildItem = Get-ChildItem -Path $logoImagePath


    $logoImageChildItem.Editing.BeginEdit() | Out-Null
    $logoImageChildItem["Alt"] = $logoImageChildItem.Name
    $logoImageChildItem.Editing.EndEdit() | Out-Null

      
    foreach ($image in $images) {
      Write-Host "[$($count)/$($total)] - Processing $($image.Paths.FullPath)"
        
      $image.Editing.BeginEdit() | Out-Null
      $image["Alt"] = $image.Name
      $image.Editing.EndEdit() | Out-Null
  
      $count++
    }
  
    Write-Host "Update Alt text - End"
  }
  
  end {
    Write-Host "Upload-Home-Page-Image - End"
  }
}
  