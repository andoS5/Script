function Scaffolding-Update-SiteSetting {
	[CmdletBinding()]
    param(
    )
	
	begin{
		Write-Host "Cmdlet Update-MallSettings - Begin"
		Import-Function Utils-Get-All-Language
		Import-Function Utils-Convert-PSObject-To-Hashtable
		Import-Function Scaffolding-New-Mall
	}
	
	process{
	
		$languages = Utils-Get-All-Language
		$props = @{
		    Parameters = @(
		        @{Name="sitename"; Title="Enter name of site*"; lines=1; Tooltip="Enter name of site"}
		        @{Name="region"; Title="Enter Region*"; lines=1; Tooltip="Enter region"}
		        @{Name="version"; Title="Select Version*"; Options=$languages; Tooltip="Choose one."}
		    )
		    Title = "Update Site Settings"
			OkButtonName = "Proceed"
		    CancelButtonName = "Cancel"
		    Width = 500
		    Height = 300
		    ShowHints = $true
		}

		$result = Read-Variable @props
		if ($result -ne "ok") {
		    Write-Host "Cancelled"
		    Exit
		}

		#Get file setting for /sitecore/content/Klepierre/$region/$site/Settings
 		$dataFolder = [Sitecore.Configuration.Settings]::DataFolder
		$tempFolder = $dataFolder + "\temp\upload"
		$filePath1 = Receive-File -Path $tempFolder -overwrite -Title "Choose a csv file"
		$fileCSV = Import-Csv $filePath1

		$SettingValues1 = Utils-Convert-PSObject-To-Hashtable $fileCSV
		
		if(!(Test-Path -Path "master:/sitecore/content/Klepierre/$region/$sitename")){
			Write-Host "Creation of the mall"
			Scaffolding-New-Mall $region $version $sitename 
		}
		
		Write-Host "Cmdlet Update setting for $sitename ($region Region)..." 
		
		$mallSetting1 = Get-Item -Path "master:/sitecore/content/Klepierre/$region/$sitename/Settings" -Language $version
		
		$mallSetting1.Editing.BeginEdit() 
			foreach($key in $SettingValues1.Keys){
				if(-Not([string]::IsNullOrWhiteSpace($SettingValues1.$Key))){
					$mallSetting1[$Key] = $SettingValues1.$Key
				}
			}
		$mallSetting1.Editing.EndEdit()| Out-Null
		
		#Get file setting for /sitecore/content/Klepierre/$region/$site/Settings/Mall Settings
		$filePath2 = Receive-File -Path $tempFolder -overwrite -Title "Choose a the 2nd csv file"
		$fileCSV2 = Import-Csv $filePath2
		
		$SettingValues2 = Utils-Convert-PSObject-To-Hashtable $fileCSV2
		
		Write-Host "Update /Site Grouping/$sitename item"
		
		$mallSetting2 = Get-Item -Path "master:/sitecore/content/Klepierre/$region/$sitename/Settings/Mall Settings" -Language $version
		
		$mallSetting2.Editing.BeginEdit() 
			foreach($key in $SettingValues2.Keys){
				if(-Not([string]::IsNullOrWhiteSpace($SettingValues2.$Key))){
					$mallSetting2[$Key] = $SettingValues2.$Key
				}
			}
		$mallSetting2.Editing.EndEdit()| Out-Null
		
		#Get file setting for /sitecore/content/Klepierre/$region/$site/Settings/Site Grouping/$site
		$filePath3 = Receive-File -Path $tempFolder -overwrite -Title "Choose a the 3rd csv file"
		$fileCSV3 = Import-Csv $filePath3
		
		$SettingValues3 = Utils-Convert-PSObject-To-Hashtable $fileCSV3
		
		Write-Host "Update /Site Grouping/$sitename item"
		
		$mallSetting3 = Get-Item -Path "master:/sitecore/content/Klepierre/$region/$sitename/Settings/Site Grouping/$sitename" -Language $version
		
		$mallSetting3.Editing.BeginEdit() 
			foreach($key in $SettingValues3.Keys){
				if(-Not([string]::IsNullOrWhiteSpace($SettingValues3.$Key))){
					$mallSetting3[$Key] = $SettingValues3.$Key
				}
			}
		$mallSetting3.Editing.EndEdit()| Out-Null
		
	}
	end{
		Write-Host "Cmdlet Update-MallSettings - End"
	}
}