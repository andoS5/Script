Add-Type -AssemblyName System.Windows.Forms
#step 1 : open folder location
#step 2 : choose the excel file
cls
$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ InitialDirectory = [Environment]::GetFolderPath('Desktop') }
$SelectedFile = $FileBrowser.ShowDialog()
$filePath = $FileBrowser.FileNames
#step 3 : open the excel file
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


$newFileWorkbook = $excelObj.Workbooks.Add()
$newFileWorkbook.Worksheets.Add()
$Data= $newFileWorkbook.Worksheets.Item(1)
$Data.Name = 'new sheet'

for($i=1 ; $i -le $RowCount ; $i++){  
	for($a = 1; $a -le $ColumnCount; $a++){
	#step 4 : check all column and remove \n
		$text = $workSheet.Columns.Item($a).Rows.Item($i).Text.trim()
		$text2 = $text.Replace("\n","")
		$Data.Cells.Item($i,$a) = $text2
#		Write-Host $text2
	}
}
#step 5 : write another excel file
# Format, save and quit excel
$usedRange = $Data.UsedRange                                                                                              
$usedRange.EntireColumn.AutoFit() | Out-Null
$newFileWorkbook.SaveAs("C:\Users\aramanam\Downloads\FINAL TEST\Cleaned-$WsName.xlsx")
$excelObj.Workbooks.Close()
$excelObj.Quit()


