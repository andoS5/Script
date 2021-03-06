
#step 1 : open folder location
#step 2 : choose the excel file
cls
# $FileBrowser = New-Object System.Windows.Forms.OpenFileDialog -Property @{ InitialDirectory = [Environment]::GetFolderPath('Desktop') }
# $SelectedFile = $FileBrowser.ShowDialog()
# $filePath = $FileBrowser.FileNames

$Region = "France"
$folder = "C:\Users\aramanam\Documents\tasks\LOCALISATION\KLEPIERRE\$($Region)"
$fullName = get-childitem $folder -recurse | where { $_.extension -eq ".xlsx" }
$Services = @()

for ($a = 0; $a -lt $fullName.Count; $a++) {
    if ($fullName[$a].FullName.Contains("Services")) {
        $Services += $fullName[$a].FullName
    }
}

$count = $Services.Count
$cpt = 1

for ($a = 0; $a -lt $count; $a++) {
    Write-Host "[$($cpt)/$($count)]Running Process for " $Services[$a]
    $sn = $Services[$a].Split("\")
    $additionalName = $sn[$sn.Count -3]
    # Measure-Command { #step 3 : open the excel file
    # Create an Object Excel. Application using Com interface  
    $excelObj = New-Object -ComObject Excel.Application  
    # Disable the 'visible' property so the document won't open in excel  
    $excelObj.Visible = $true  
    #open WorkBook  
    $workBook = $excelObj.Workbooks.Open($Services[$a])  
    #Select worksheet using Index  
    $workSheet = $null

    $wbs = $workBook.Worksheets
    # Write-Host $wbs.Count
    for ($j = 1; $j -le $wbs.Count; $j++) { 
        # Write-Host $wbs[$j].Name
        if ($wbs[$j].Name -eq "Services") {
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
    $line = 1;
    $checkIfBlank = 0;

    for ($i = 1 ; $i -le $RowCount ; $i++) {
        $newRowCount ++
        # Write-Host $line " " $Worksheet.Cells.Item($i, 1).value2
        if ([string]::IsNullOrEmpty($Worksheet.Cells.Item($i, 7).value2)) {
            $checkIfBlank ++
        }
        if ($checkIfBlank -eq 4) {
            break
        }
    }


    for ($b = 1 ; $b -le $newRowCount ; $b++) {  
        if ($b -eq 2) {
            continue
        }
        for ($c = 1; $c -le $ColumnCount; $c++) {
            $text = $workSheet.Columns.Item($c).Rows.Item($b).Text.trim()
            $text2 = $text.Replace("\n", "")
            $Data.Cells.Item($line, $c) = $text2
        }
            
        $line ++
    }

    # step 5 : write another excel file
    # Format, save and quit excel
    $usedRange = $Data.UsedRange                                                                                              
    $usedRange.EntireColumn.AutoFit() | Out-Null
	
	 $testOutputFile = "C:\Users\aramanam\Documents\tasks\LOCALISATION\KLEPIERRE\$($Region)\TO UPLOAD\SERVICES\$($additionalName)"
    if(!(Test-Path $testOutputFile)){
        mkdir $testOutputFile
    }
   $OutputFile = "C:\Users\aramanam\Documents\tasks\LOCALISATION\KLEPIERRE\$($Region)\TO UPLOAD\SERVICES\$($additionalName)\$($additionalName)-$($WsName).csv"
    $newFileWorkbook.SaveAs($OutputFile, [Microsoft.Office.Interop.Excel.XlFileFormat]::xlCSVWindows)
    $excelObj.Workbooks.Close()
    $excelObj.Quit()

    ps excel | kill     #for some reason Excel stays
    ls "$(Split-Path $OutputFile)\*.csv" | % { (Get-Content $_) -replace '\t', ',' | Set-Content $_ -Encoding utf8 }
    # }
    $cpt++
    Write-Host "Process Done"
}

Write-Host "All is Done"