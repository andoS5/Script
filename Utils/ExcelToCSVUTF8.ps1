cls
$Path = ""
$ExcelFileInPath = get-childitem $Path -recurse | where { $_.extension -eq ".xlsx" }

