$path = "master:/sitecore/content/Klepierre/Denmark/FieldsEN/Home/Shop Repository/3-butikken"

$item = Get-Item -Path $path -Language "en"

$Fields = $item.Fields

$ResultRegex = "(?<={)(.*)(?=})"

foreach ($f in $Fields) {
    $value = $f.Value
    
    $Regex = [Regex]::new("$ResultRegex")       
    $Result = $Regex.Match($value)           
    if ($Result.Success) {           
        $id = "{$($Result.Value)}" 
        # Write-Host "$value ====> $id"   
        $sourceId = Get-Item master: -ID $id
        $sourcePath = $sourceId.FullPath
        if ($sourcePath.Contains("/Fields/")) {
            $sourcePath = $sourcePath -replace "/Fields/", "/FieldsEN/"
            if ((Test-Path $sourcePath -ErrorAction SilentlyContinue)) {

                $newItem = Get-Item -Path  $sourcePath -Language "en"
                $newID = $newItem.ID
                
                $fieldsName = $f.Name
                if ($fieldsName.Contains("Image")) {
                    Write-Host "updating $($item.FullName) / $sourcePath" -ForegroundColor Yellow
                    $item.Editing.BeginEdit() | Out-Null
                    $item["$fieldsName"] = "<image mediaid=`"$newID`" alt=`"$($newItem.Name)`" height=`"`" width=`"`" hspace=`"`" vspace=`"`" />"
                    $item.Editing.EndEdit() | Out-Null
                    Write-Host "Updating Done " -ForegroundColor Green
                    Write-Host "::::::::::::::::::::::::::::::::"
                    
                    
                }
                else {
                    Write-Host "updating $($item.FullName) / $sourcePath" -ForegroundColor Yellow
                    $item.Editing.BeginEdit() | Out-Null
                    $item["$fieldsName"] = $newID
                    $item.Editing.EndEdit() | Out-Null
                    Write-Host "Updating Done " -ForegroundColor Green
                    Write-Host "::::::::::::::::::::::::::::::::"
                  
                }
            }
        }
    }
}

