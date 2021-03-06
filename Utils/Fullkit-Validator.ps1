Add-Type -AssemblyName System.Windows.Forms
cls
#fullkit validation
#step 1 : Open the excel file
#step 2 : check the length of the localised text
#step 3 : write log if any

#STEP 1
$FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ InitialDirectory = [Environment]::GetFolderPath('Desktop') }
$SelectedFile = $FileBrowser.ShowDialog()
$filePath = $FileBrowser.FileNames
$excelObj = New-Object -ComObject Excel.Application 
$excelObj.Visible = $false
$workBook = $excelObj.Workbooks.Open($filePath)
$workSheet = $workBook.sheets.Item(1) 
$range= $workSheet.UsedRange
$WsName = $workBook.name -replace ".xlsx",""
$RowCount = $range.Rows.Count
$ColumnCount = $range.Columns.Count
$OutFileName = "C:\Users\aramanam\Downloads\FINAL TEST\ERROR-$WsName.csv"
if($filePath){

	Write-Host "== Starting full-kit validation =="
	for($i=2 ; $i -le $RowCount ; $i++){
		
		$text = $workSheet.Columns.Item(1).Rows.Item($i).Text.trim()
		$textLength = [int]$text.length
		$maxLength = [int]$workSheet.Columns.Item(2).Rows.Item($i).Text.trim()
		if($textLength -gt $maxLength){
			Add-Content $OutFileName "$text , Cannot exceed $maxLength Chars length"
		}
	}
	Write-Host "== Done =="
}
