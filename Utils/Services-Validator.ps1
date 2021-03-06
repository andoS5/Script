Add-Type -AssemblyName System.Windows.Forms

cls


#	$path =""
	$serviceTitleLength = 20
	$shortDescriptionLength = 150 
	$longdescriptionLength = 800
	
	$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ InitialDirectory = [Environment]::GetFolderPath('Desktop') }
	$SelectedFile = $FileBrowser.ShowDialog()
	#read excel by path 
	$filePath = $FileBrowser.FileNames
	# Create an Object Excel. Application using Com interface  
	$excelObj = New-Object -ComObject Excel.Application  
	# Disable the 'visible' property so the document won't open in excel  
	$excelObj.Visible = $false  
	#open WorkBook  
	$workBook = $excelObj.Workbooks.Open($filePath)  
	#Select worksheet using Index  
	$workSheet = $workBook.sheets.Item(1)  
	#Select the range of rows should read  
	$range= $workSheet.UsedRange
	$WsName = $workBook.name -replace ".xlsx",""
	$RowCount = $range.Rows.Count
	$ColumnCount = $range.Columns.Count
	$OutFileName = "C:\Users\aramanam\Downloads\FINAL TEST\ERROR-$WsName.csv"
#	Write-Host $ColumnCount
	for($i=4 ; $i -le $RowCount ; $i++){  
		for($a = 1; $a -le $ColumnCount; $a++){
		$newText = $workSheet.Columns.Item($a).Rows.Item($i).Text.trim() -replace("<.*?>","")
		$value = $newText.length
		
			#serviceTitleLength
			if($a -eq 4){
				if($value -gt $serviceTitleLength -or $value -eq 0){
					Add-Content $OutFileName "Col $a, Line $i ,Service Title length $value,Cannot exceed $serviceTitleLength Chars"
				}
			}
			
			#shortDescriptionLength
			if($a -eq 7){
				if($value -gt $shortDescriptionLength -or $value -eq 0){
					Add-Content $OutFileName "Col $a, Line $i ,Short Description length $value,Cannot exceed $shortDescriptionLength Chars"
				}
			}
			#longDescriptionLength
			if($a -eq 11){
				if($value -gt $longdescriptionLength -or $value -eq 0){
					Add-Content $OutFileName "Col $a, Line $i ,Long Description length $value,Cannot exceed $longdescriptionLength Chars"
				}
			}
		} 
	}
	$excelObj.Workbooks.Close()



