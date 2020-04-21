function Prepare-Resource-Key-Folder {
    param (
        [Parameter(Mandatory = $true, Position = 0 )]
        [string]$folder,
        [Parameter(Mandatory = $true, Position = 1 )]
        [string]$destination
    )
    begin { 
        Import-Module .\Prepare-Resource-Keys.ps1 -Force
    }
    process {
        $files = Get-ChildItem $folder
        foreach($file in $files){
            if($file -is [System.IO.DirectoryInfo]){
                Prepare-Resource-Key-Folder $file.FullName $destination
            }elseif($file.Name -match "Resource keys"){
                Prepare-Resource-Keys $file.FullName $destination
            }
        }
    }
}

function Get-Folder {
    param (
        [Parameter(Mandatory = $true, Position = 0 )]
        [string]$description
    )
    $FolderBrowser = New-Object System.Windows.Forms.FolderBrowserDialog
    $FolderBrowser.Description = $description
    $folder = ""
    if($FolderBrowser.ShowDialog() -eq "OK")
    {
        $folder += $FolderBrowser.SelectedPath
    }
    return $folder
}

$folder = Get-Folder "Select the region folder"
$destination = Get-Folder "Select the folder that will contain the result"
Prepare-Resource-Key-Folder $folder $destination