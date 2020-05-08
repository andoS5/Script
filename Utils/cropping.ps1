<# HOW TO USE THIS SCRIPT :
	For this script, you need to change 3 things:
	 - $EditorialImagePath : sitecore path of the container of the images you want to crop
	 - $imagesToCrop : list of images name if you want to crop only defined images (filtering), if this list does not contains any item all the images under the folder  
	   you defined on $EditorialImagePath.
	 - $picturePresets : list of picture presets for the cropping, these default values below are the picture presets we use for jolt editorials.
   
#>
$EditorialImagePath = "/sitecore/media library/Project/Klepierre/France/Shared/covid19/Home-page/arc"

$imagesToCrop = @(

)
$picturePresets = @(
    
   "{1B8AF744-0CE3-4459-A75E-9B15CBD9ECBB}" #Home-page
#    "{BAF8017C-5F3C-4EE0-97F4-2F8E021256E6}" #NewsWithoutLogo
)


$editorialImageContainer = Get-Item "master:$EditorialImagePath" -ErrorAction SilentlyContinue

if($editorialImageContainer -eq $null){
	Write-Host "editorial Image Container item '$EditorialImagePath' does not exit."  -BackgroundColor Red 
	Exit
}
	
$allEditorialImages = $editorialImageContainer.Axes.GetDescendants() | Where-Object {(($_.TemplateID.ToString() -eq "{F1828A2C-7E5D-4BBD-98CA-320474871548}") -or  ($_.TemplateID.ToString() -eq "{DAF085E8-602E-43A6-8299-038FF171349F}") -or  ($_.TemplateID.ToString() -eq "{EB3FB96C-D56B-4AC9-97F8-F07B24BB9BF7}"))}
# Write-Host $allEditorialImages.Count
# Exit
if($imagesToCrop.Count -gt 0){
	$allEditorialImages = $allEditorialImages | Where-Object { $imagesToCrop -contains $_.Name }
}

$idsList = @()
$allEditorialImages | Foreach-Object{
		$idsList += $_.ID.ToString()
}


$handler = New-Object "Kortex.Foundation.Pipelines.Events.ItemEventHandler"	#MISSING DLL
Write-Host "Start"
foreach($picturePreset in $picturePresets){
	$picturePresetItem = Get-Item master: -ID $picturePreset -Language en
	if($picturePresetItem -ne $null){
		Write-Host -NoNewLine "Cropping images with $($picturePresetItem.Name) ... "
		$handler.Run($idsList, $picturePreset)
		Write-Host "Done" -BackgroundColor Green
	}else{
		Write-Host "Cropping images skipped : picture preset with ID '$picturePreset' does not exit." -BackgroundColor Yellow -Foreground Red
	}
}

Write-Host "Done"