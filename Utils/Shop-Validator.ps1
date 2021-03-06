#Friendly url [remove Diacritics function]
#shop name [20 characters max 2 lines uppercase]
#meta title [60]
#meta description [160]
#meta keyword
#open graph title [60]
#open graph description [160]
#title image [image validator]
#banner image [image validator]
#category 1 [30]
#sub category 1 [30]
#category 2 [30]
#sub category 2 [30]
#category 3 [30]
#sub category 3[30]
#description [800 10 lines lowercase]
#brand logo [image validator]
#brand title [60]
#opening format hh:mm  [20]
#closing format hh:mm [20]
#phone number [ remove space - only number ]
#site url [url validator]
#social media validator url [url validator facebook.com]

Add-Type -AssemblyName System.Windows.Forms

cls


#	$path =""
	$shopNameLength = 20
	$metaTitleLength = 60 
	$metaDescriptionLength = 160
	$metaKeywordLength = 160 
	$OpenGraphTitleLength = 60
	$OpenGraphDescriptionLength = 160
	$categoryLength = 30
	$subCategoryLength = 30
	$OpenAndCloseFormat = 20
	$descriptionLength = 800
	
	$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ InitialDirectory = [Environment]::GetFolderPath('Desktop') }
	$SelectedFile = $FileBrowser.ShowDialog()
#	Write-Host $FileBrowser.FileNames
	#read excel by path
#	$filePath ="C:\Users\aramanam\Downloads\DOCUMENTS\Restaurants- Fullkit - Version 2 centre.xlsx"  
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
		
#			$shopNameLength 3 serviceTitle 4
			if($a -eq 3){
				if($value -gt $shopNameLength -or $value -eq 0){
					Add-Content $OutFileName "Col $a, Line $i ,Meta Keyword length $value,Cannot exceed $shopNameLength Chars"
				}
			}
			#================================
			#	$metaTitleLength = 60 4 / 12
#			if($a -eq 4){
#				if($value -gt $metaTitleLength -or $value -eq 0){
#					Add-Content $OutFileName "Col $a, Line $i ,Meta Keyword length $value,Cannot exceed $metaTitleLength Chars"
#				}
#			}
			#	$metaDescriptionLength = 160 5 / 13
#			if($a -eq 5){
#				if($value -gt $metaDescriptionLength -or $value -eq 0){
#					Add-Content $OutFileName "Col $a, Line $i ,Meta Keyword length $value,Cannot exceed $metaDescriptionLength Chars"
#				}
#			}
			#	$metaKeywordLength = 160 6 /14
#			if($a -eq 6){
#				if($value -gt $metaKeywordLength -or $value -eq 0){
#					Add-Content $OutFileName "Col $a, Line $i ,Meta Keyword length $value,Cannot exceed $metaKeywordLength Chars"
#				}
#			}
			#	$OpenGraphTitleLength = 60 7 / 15
#			if($a -eq 7){
#				if($value -gt $OpenGraphTitleLength -or $value -eq 0){
#					Add-Content $OutFileName "Col $a, Line $i ,OG Title length $value,Cannot exceed $OpenGraphTitleLength Chars"
#				}
#			}
			#	$OpenGraphDescriptionLength = 160 8 / 16
#			if($a -eq 8){
#				if($value -gt $OpenGraphDescriptionLength -or $value -eq 0){
#					Add-Content $OutFileName "Col $a, Line $i ,OG Description length $value,Cannot exceed $OpenGraphDescriptionLength Chars"
#				}
#			}
			#================================
			#	$categoryLength = 30 11 -> 15
			if($a -eq 11 -or $a -eq 13 -or $a -eq 15){
				$length += $value
				if($value -gt $categoryLength -or $length -eq 0){
					Add-Content $OutFileName "Col $a, Line $i ,Category length $value,Cannot exceed $categoryLength Chars"
				}
			}
			#	$subCategoryLength = 30 11 -> 15
			if($a -eq 12 -or $a -eq 14 -or $a -eq 16){
				$length += $value
				if($value -gt $subCategoryLength -or $length -eq 0){
					Add-Content $OutFileName "Col $a, Line $i ,Sub Category length $value,Cannot exceed $subCategoryLength Chars"
				}
			}
			#	$descriptionLength = 800 17 -- shortDescription 7 11 long description
			if($a -eq 17){
				if($value -gt $descriptionLength -or $value -eq 0){
					Add-Content $OutFileName "Col $a, Line $i ,Description length $value,Cannot exceed $descriptionLength Chars"
				}
			}
		} 
	}
	
	$excelObj.Workbooks.Close()
	




