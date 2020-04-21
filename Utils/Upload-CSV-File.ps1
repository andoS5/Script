Import-Function Utils-Convert-PSObject-To-Hashtable

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