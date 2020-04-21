function Utils-GetImageFromMediaLibrary {
  [CmdletBinding()]
  param (
    [Parameter(Mandatory = $true, Position = 0 )]
    [string]$RegionName,

    [Parameter(Mandatory = $false, Position = 1 )]
    [string]$Language="en",

    [Parameter(Mandatory = $true, Position = 2 )]
    [string]$MallName,

    [Parameter(Mandatory = $true, Position = 3 )]
    [string]$ContentType,

    [Parameter(Mandatory = $true, Position = 4 )]
    [string]$ImageName,

    [Parameter(Mandatory = $false,Position = 5)]
    [string]$DefaultImage
  )

  process {
    
    $siteName = $MallName -Replace '[\W]', '-'

    $imageFolderPath = "master:/sitecore/media library/Project/Klepierre/$($RegionName)/$($siteName)/$($ContentType)"

    if (Test-Path -Path $imageFolderPath -ErrorAction SilentlyContinue) {

      $imageName = $ImageName.Split(".")[0]
      
      $imagePath = "$($imageFolderPath)/$($imageName)"

      if (Test-Path -Path $imagePath -ErrorAction SilentlyContinue) {
        $imageItem = Get-Item -Path $imagePath -Language $Language
        $imageItem
      } elseif (!([string]::IsNullOrEmpty($DefaultImage)) -and (Test-Path -Path $DefaultImage -ErrorAction SilentlyContinue)) {
        Write-Host "Use default image"
        $imageItem = Get-Item -Path $DefaultImage -Language $Language
        $imageItem
      } else {
        Write-Host "$($imageName) doesn't exist"
      }
    } else {
      Write-Host "Media folder for $($ContentType) doesn't exist"
    }
  }
}