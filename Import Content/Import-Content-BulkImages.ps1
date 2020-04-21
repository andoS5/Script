
<#-------------------------------------------------------------           READ ME          ---------------------------------------------------------------------------------#>
<# HOW TO USE THIS SCRIPT :

   -Change the $region,$mall and the $pathServer and execute

#>

$typeContent = $("Stores","Services","Home-Page")

$region = "France"
$mall = "Odysseum"
$pathMedieLibSC = "$([Sitecore.Constants]::MediaLibraryPath)"
$pathServer = "C:\inetpub\wwwroot\Sitecore\Sandbox\dev.klepierre.sc\dev.klepierre.sc\upload\$($region)\$($mall)\"

foreach($type in $typeContent){
    $path = $pathServer + "$($type)"
    $dir = Get-ChildItem -Path $path -Recurse -Directory | Where-Object{ !($_.Name -eq $type)}

    foreach($a in $dir){
        #get Image
        $nameFolderParent = $region +"/$($mall)/" + "$($type)/" + $a
        #Write-Host $nameFolderParent
        $images = Get-ChildItem -Path $a.FullName -Recurse -File
        foreach($b in $images){
            $pathImageServer = $a.FullName +"\"+ $b.Name
            $folderImageSitecore = $pathMedieLibSC + "/$($nameFolderParent)"
            $nameImage = $b.Name.Split(".")[0]
            $pathImageSitecore = $folderImageSitecore + "/$nameImage"
            
            if($null -ne $pathImageServer) {
                if(!(Test-Path -Path $pathImageSitecore)){
                    Write-Host "Create....."
                    New-MediaItem $pathImageServer $folderImageSitecore
                }else{
                    Write-Host "Update Alt only because image is already exist " $b.Name
                    $imageItem = Get-Item -Path $pathImageSitecore -ErrorAction SilentlyContinue
                    $imageItem.Editing.BeginEdit() | Out-Null
                        $imageItem["Alt"] = $nameImage
                    $imageItem.Editing.EndEdit() | Out-Null
                }
                Write-Host "Done for " $b.Name
            }else{
                Write-Host "Failed for " $b.Name " because " $b.Name " doesn't exist"
            }
        }
    }
}

function New-MediaItem{
    [CmdletBinding()]
    param(
        [Parameter(Position=0, Mandatory=$true, ValueFromPipeline=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$filePath,

        [Parameter(Position=1, Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string]$mediaPath)

$mco = New-Object Sitecore.Resources.Media.MediaCreatorOptions
$mco.Database = [Sitecore.Configuration.Factory]::GetDatabase("master");
$mco.Language = [Sitecore.Globalization.Language]::Parse("en");
$mco.Versioned = [Sitecore.Configuration.Settings+Media]::UploadAsVersionableByDefault;
$mco.Destination = "$($mediaPath)/$([System.IO.Path]::GetFileNameWithoutExtension($filePath))";

$mc = New-Object Sitecore.Resources.Media.MediaCreator
$mc.CreateFromFile($filepath, $mco);
}