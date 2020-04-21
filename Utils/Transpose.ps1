Add-Type -AssemblyName System.Windows.Forms
cls


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
