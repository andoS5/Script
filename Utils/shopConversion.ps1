
#step 1 : open folder location
#step 2 : choose the excel file
cls
# $FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ InitialDirectory = [Environment]::GetFolderPath('Desktop') }
# $SelectedFile = $FileBrowser.ShowDialog()
# $filePath = $FileBrowser.FileNames



    $Region = "France"
$folder = "C:\Users\aramanam\Documents\tasks\LOCALISATION\KLEPIERRE\$($Region)"
$fullName = get-childitem $folder -recurse | where { $_.extension -eq ".xlsx" }
$Stores = @()

for ($a = 0; $a -lt $fullName.Count; $a++) {
    if ($fullName[$a].FullName.Contains("Stores")) {
        $Stores += $fullName[$a].FullName
    }
}

$count = $Stores.Count
$cpt = 1
for ($b = 0; $b -lt $count; $b++) {

    # Measure-Command { #step 3 : open the excel file
    # Create an Object Excel. Application using Com interface  
    $excelObj = New-Object -ComObject Excel.Application  
    # Disable the 'visible' property so the document won't open in excel  
    $excelObj.Visible = $true  
    #open WorkBook  
    Write-Host "[$($cpt)/$($count)]Running Process for " $Stores[$b]
    # $test = "C:\Users\aramanam\Documents\tasks\LOCALISATION\BATCH 3\FRANCE\DATAS\Beau Sevran\Stores\stores beau-sevran.klepierre.fr.xlsx"
    # $workBook = $excelObj.Workbooks.Open($test)  
    $sn = $Stores[$b].Split("\")
    $additionalName = $sn[$sn.Count -3]

    $workBook = $excelObj.Workbooks.Open($Stores[$b])  
    #Select worksheet using Index  
    $workSheet = $null
    $wbs = $workBook.Worksheets
    # Write-Host $wbs.Count
    for ($j = 1; $j -le $wbs.Count; $j++) { 
        # Write-Host $wbs[$j].Name
        if ($wbs[$j].Name -eq "Stores") {
            # Write-Host $wbs[$j].Name
            $workSheet = $workBook.sheets.Item($j)
        }
        elseif ($wbs[$j].Name -eq "Sheet1") {
            $workSheet = $workBook.sheets.Item($j)
        }

    } 
    #Select the range of rows should read  
    $range = $workSheet.UsedRange
    $WsName = $workBook.name -replace ".xlsx", ""
    $RowCount = $range.Rows.Count
    $ColumnCount = $range.Columns.Count
    $newRowCount = 0;

    $newFileWorkbook = $excelObj.Workbooks.Add()
    $newFileWorkbook.Worksheets.Add()
    $Data = $newFileWorkbook.Worksheets.Item(1)
    $Data.Name = 'new sheet'
    $line = 2;
    $checkIfBlank = 0;

    for ($c = 1 ; $c -le $RowCount ; $c++) {
        $newRowCount ++
        # Write-Host $line " " $Worksheet.Cells.Item($i, 1).value2
        if ([string]::IsNullOrEmpty($Worksheet.Cells.Item($c, 1).value2)) {
            $checkIfBlank ++
        }
        if ($checkIfBlank -eq 4) {
            break
        }
    }
    
    # $Days = @("Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday")
    $headers = @("Legacy URL", "Friendly URL", "Shop Name", "MAPWIZE"
	, "Meta Description", "Meta Keywords", "Open Graph Title", "Open Graph Description", "Tile image", "Banner image", "Category 1", "Sub-Category 1", "Category 2", "Sub-Category 2", "Category 3", "Sub-Category 3", "Description", "Brand Logo", "Brand Title", "Monday Opening", "Monday Closing", "Tuesday Opening", "Tuesday Closing", "Wednesday Opening", "Wednesday Closing", "Thursday Opening", "Thursday Closing", "Friday Opening", "Friday Closing", "Saturday Opening", "Saturday Closing", "Sunday Opening", "Sunday Closing", "Phone Number", "Opening Date
    Existing shop = `"Leave field blank`""," Associated Services","SITE URL", "Facebook URL","Twitter URL", "Instagram URL"
    )
    # $headers = @("Legacy URL", "Friendly URL", "Shop Name", "Meta Title", "Meta Description", "Meta Keywords", "Open Graph Title", "Open Graph Description", "Tile image", "Banner image", "Category 1", "Category 1", "Category 2", "Sub-Category 2", "Category 3", "Sub-Category 3", "Description", "Brand Logo", "Brand Title", "Monday Opening", "Monday Closing", "Tuesday Opening", "Tuesday Closing", "Wednesday Opening", "Wednesday Closing", "Thursday Opening", "Thursday Closing", "Friday Opening", "Friday Closing", "Saturday Opening", "Saturday Closing", "Sunday Opening", "Sunday Closing", "Phone Number", "MapWize", "Opening Date
    # Existing shop = `"Leave field blank`"", "Playfull Partner [if yes then 1 else 0]", "Pop-up Store [if yes then 1 else 0]", " Associated Services", "SITE URL", "Facebook URL", "Instagram URL"
    # )
    $var = 0
    for ($d = 0; $d -lt $headers.Count; $d++) {
        $var ++
        $Data.Cells.Item(1, $var) = $headers[$d]
    }
    for ($e = 1 ; $e -le $newRowCount ; $e++) {  
        if ($e -le 3) {
            continue
        }
		
        for ($f = 1; $f -le $ColumnCount; $f++) {
			if($f -ne 4){
				$text = $workSheet.Columns.Item($f).Rows.Item($e).Text.trim()
	            $text2 = $text.Replace("\n", "")
	            $Data.Cells.Item($line, $f) = $text2
			}
			  
        }
        $line ++
    }

    # step 5 : write another excel file
    # Format, save and quit excel
    $usedRange = $Data.UsedRange                                                                                              
    $usedRange.EntireColumn.AutoFit() | Out-Null

    $testOutputFile = "C:\Users\aramanam\Documents\tasks\LOCALISATION\KLEPIERRE\$($Region)\TO UPLOAD\STORES\$($additionalName)"
    if(!(Test-Path $testOutputFile)){
        mkdir $testOutputFile
    }
    $OutputFile = "C:\Users\aramanam\Documents\tasks\LOCALISATION\KLEPIERRE\$($Region)\TO UPLOAD\STORES\$($additionalName)\$($additionalName)-$($WsName).csv"
    $newFileWorkbook.SaveAs($OutputFile, [Microsoft.Office.Interop.Excel.XlFileFormat]::xlCSVWindows)
    $excelObj.Workbooks.Close()
    $excelObj.Quit()

    ps excel | kill     #for some reason Excel stays
    ls "$(Split-Path $OutputFile)\*.csv" | % { (Get-Content $_) -replace '\t', ',' | Set-Content $_ -Encoding utf8 }

    # }
    Write-Host "Process Done"
    $cpt++
}
Write-Host "All is Done"
