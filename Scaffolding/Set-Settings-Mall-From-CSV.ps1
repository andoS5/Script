function Scaffolding-Set-Settings-Mall-From-CSV{
	begin{
		Write-Host "Cmdlet Update-MallSettings - Begin"
		Import-Function Scaffolding-New-Mall
		Import-FUnction Utils-Upload-CSV-File
	}
	
 	process{
	
		#setting for /sitecore/content/Klepierre/region/mall/Settings
		Write-Progress -Activity "Update Settings Item"
		$SettingValues1 = Utils-Upload-CSV-File -Title "1- Update setting mall" -Description "/sitecore/content/Klepierre/region/mall/Settings"

		foreach ($set in $SettingValues1) {
			$region  = $set["Region Name"]
			$mall    = $set["Mall Name"]
			$mall = $mall -Replace '[\W]', '-' 
			$version = $set["Version"]
					
			#creat mall if Not exist
			if(!(Test-Path -Path "master:/sitecore/content/Klepierre/$region/$mall")){
				Write-Host "Creation of the mall"
				Scaffolding-New-Mall $region $version $mall 
			}
					
			$mallSetting1 = Get-Item -Path "master:/sitecore/content/Klepierre/$region/$mall/Settings" -Language $version
			
			$mallSetting1.Editing.BeginEdit()
				 foreach($key in $set.Keys|?{($_ -ne "Region Name") -and ($_ -ne "Version") -and ($_ -ne "Mall Name")}){
				     if(-Not([string]::IsNullOrWhiteSpace($set.$key))){
						$set.$key = $set.$key.Replace("{region}",$region).Replace("{mall}",$mall).Replace("{lang}",$version)
						$mallSetting1[$key] = $set.$key.Trim()
					  }
				 }
			$mallSetting1.Editing.EndEdit()| Out-Null
		}
		
		#setting for /sitecore/content/Klepierre/region/mall/Settings/Mall Settings
		Write-Progress -Activity "Update Mall Settings Item"
		$SettingValues2 = Utils-Upload-CSV-File -Title "2- Update setting mall" -Description "/sitecore/content/Klepierre/region/mall/Settings/Mall Settings"

		foreach ($set in $SettingValues2) {
		    $region  = $set["Region Name"]
		    $mall    = $set["Mall Name"]
			$mall = $mall -Replace '[\W]', '-'
			$version = $set["Version"]
			
			#creat mall if Not exist
			if(!(Test-Path -Path "master:/sitecore/content/Klepierre/$region/$mall")){
				Write-Host "Creation of the mall"
				Scaffolding-New-Mall $region $version $mall 
			}
			
			$mallSetting2 = Get-Item -Path "master:/sitecore/content/Klepierre/$region/$mall/Settings/Mall Settings" -Language $version
			
			$mallSetting2.Editing.BeginEdit()
		        foreach($key in $set.Keys|?{($_ -ne "Region Name") -and ($_ -ne "Version") -and ($_ -ne "Mall Name")}){
		            if(-Not([string]::IsNullOrWhiteSpace($set.$key))){
						$set.$key = $set.$key.Replace("{region}",$region).Replace("{mall}",$mall).Replace("{lang}",$version)
						$value = $set.$key.Trim()
						if($key -eq "TimeFormat" -or $key -eq "Time Zone"){
							$pathTimeFormat = $value
							if((Test-Path -Path $pathTimeFormat -ErrorAction SilentlyContinue)){
								$timeFormatItem = Get-Item -Path $pathTimeFormat -Language $version -ErrorAction SilentlyContinue
								if($timeFormatItem -eq $null){
									Add-ItemVersion -Path $pathTimeFormat -Language "en" -TargetLanguage $version
								}
								$timeFormatItem = Get-Item -Path $pathTimeFormat -Language $version -ErrorAction SilentlyContinue
								$value = $timeFormatItem.ID
							}
						}
						$mallSetting2[$key] = $value
					}
		        }
		    $mallSetting2.Editing.EndEdit()| Out-Null
		}
		
		#setting for /sitecore/content/Klepierre/region/mall/Settings/Mall Settings
		Write-Progress -Activity "Update /Site Grouping/mall Item"
		$SettingValues3 = Utils-Upload-CSV-File -Title "3- Update setting mall" -Description "/sitecore/content/Klepierre/region/mall/Settings/Site Grouping/mall"
		if($version -ne "en") {
			Remove-ItemVersion -Path "master:/sitecore/content/Klepierre/$region/$mall/Settings/Site Grouping/$mall" -Language "en" 
		}
		foreach ($set in $SettingValues3) {
		    $region  = $set["Region Name"]
		    $mall    = $set["Mall Name"]
			$mall = $mall -Replace '[\W]', '-' 
			$version = $set["Version"]
			
			#creat mall if Not exist 
			if(!(Test-Path -Path "master:/sitecore/content/Klepierre/$region/$mall")){
				Write-Host "Creation of the mall"
				Scaffolding-New-Mall $region $version $mall 
			}
			
			$mallSetting3 = Get-Item -Path "master:/sitecore/content/Klepierre/$region/$mall/Settings/Site Grouping/$mall" -Language $version
			
			$mallSetting3.Editing.BeginEdit()
		        foreach($key in $set.Keys|?{($_ -ne "Region Name") -and ($_ -ne "Version") -and ($_ -ne "Mall Name")}){
		            if(-Not([string]::IsNullOrWhiteSpace($set.$key))){
						$set.$key = $set.$key.Replace("{region}",$region).Replace("{mall}",$mall).Replace("{lang}",$version)
						$mallSetting3[$key] = $set.$key.Trim()
					}
		        }
		    $mallSetting3.Editing.EndEdit()| Out-Null
		}
		
		Write-Host "Done"
	}
	end{
		Write-Host "...End"
	}
}
