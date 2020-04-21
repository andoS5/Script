function Content-UploadImages {
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
    Write-Host "UploadImage - Begin"
  }

  process {
    
    $siteName = $MallName -Replace '[\W]', '-'

    $mediaFolderPath = "master:/sitecore/media library/Project/Klepierre/$($RegionName)/$($siteName)"

    $path = "$($mediaFolderPath)/$($ContentType)"

    if (!(Test-Path -Path $path -ErrorAction SilentlyContinue)) {
      New-Item -Path $path -ItemType "/sitecore/templates/System/Media/Media folder" | Out-Null
      <# Get-Item $path | `
        Add-ItemLanguage -TargetLanguage $Language #>
    }

    Receive-File (Get-Item $path) -AdvancedDialog | Out-Null

    Write-Host "Images have been uploaded"

    Write-Host "Update Alt test - Begin"

    #Jpeg
    $queryJPEG = "fast:/sitecore/media library/Project/Klepierre/#$($RegionName)#/#$($siteName)#/#$($ContentType)#//*[@@TemplateID='{DAF085E8-602E-43A6-8299-038FF171349F}']"
    $jpegs = Get-Item -Path "master:" -Query $queryJPEG

    #Image
    $queryImage = "fast:/sitecore/media library/Project/Klepierre/#$($RegionName)#/#$($siteName)#/#$($ContentType)#//*[@@TemplateID='{F1828A2C-7E5D-4BBD-98CA-320474871548}']"
    $images = Get-Item -Path "master:" -Query $queryImage
    
    $total = $jpegs.Count + $images.Count
    $count = 1

    foreach ($jpeg in $jpegs) {
      Write-Host "[$($count)/$($total)] - Processing $($jpeg.Paths.FullPath)"
      $jpeg.Editing.BeginEdit() | Out-Null
      $jpeg["Alt"] = $jpeg.Name
      $jpeg.Editing.EndEdit() | Out-Null

      $count++
    }
    
    foreach ($image in $images) {
      Write-Host "[$($count)/$($total)] - Processing $($image.Paths.FullPath)"
      
      $image.Editing.BeginEdit() | Out-Null
      $image["Alt"] = $image.Name
      $image.Editing.EndEdit() | Out-Null

      $count++
    }

    Write-Host "Update Alt test - End"
  }

  end {
    Write-Host "UploadImage - End"
  }
}
