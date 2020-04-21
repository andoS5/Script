function Prepare-Resource-Keys {
    param (  
        [Parameter(Mandatory = $true, Position = 0 )]
        [string]$filePath,
        [Parameter(Mandatory = $true, Position = 1 )]
        [string]$destination
    )
    begin { 
        
        Import-Module .\Map-Resource-Keys.ps1 -Force
    }
    process {
        Write-Host "Preparation for ResourceKeys in $($filePath) - Begin"
        $outputFilePath = $filePath.replace("xlsx","csv")
        $outputFilePath = $outputFilePath.replace("xls","csv")
        $fileName = $outputFilePath.SubString($outputFilePath.LastIndexOf("\"))

        $outputFilePath = $destination+$fileName;

        $array = New-Object System.Collections.ArrayList
        $map = Map-Resource-Keys
        #Read Full Kit
        $excel = New-Object -Com Excel.Application
        $excel.Visible = $false 
        $workBook = $excel.Workbooks.Open( $filePath)
        $counter = 0
        for ($i = 1; $i -le $workBook.Sheets.Count; $i++)
        {
            $sheet = $workBook.Sheets.Item($i)
            $range= $sheet.UsedRange
            $RowCount = $range.Rows.Count
            for($j = 1; $j -le $RowCount; $j++)
            {
                $key = $sheet.Cells.Item($j, 1).Value2
                if([string]::IsNullOrEmpty($key)){
                    continue
                }
                $key = $key.trim()
                $key = $key+";"+$sheet.name.trim()
               
                $translation = $sheet.Cells.Item($j, 2).Value2
                if($map.ContainsKey($key))
                {
                    $resourceKey = $map[$key]
                    [regex]$pattern = "\d+(\w+)*"
                    if(!($resourceKey -match ("SEO Paragraph"))){
                       $translation = $pattern.replace($translation, "{%index}")
                    }
                    

                    [regex]$pattern = "<<\s*(\w+)\s*>>"
                    $translation = $pattern.replace($translation, "<< {%index} >>", 1)

                    $translation = $translation.replace("Zara", "{%index}")

                    $patternIndex = 0
                    [regex]$pattern = "{%index}"
                    while($pattern.Match($translation).Success){
                        $translation = $pattern.replace($translation, "{$($patternIndex)}", 1)
                        $patternIndex++
                    }
                    $split = $resourceKey.Split(";")
                    $resourceKey = $split[0]
                    $field = $split[1]
                    $obj = New-Object System.Object
                    $obj | Add-Member -MemberType NoteProperty -Name "Field" -Value  $field
                    $obj | Add-Member -MemberType NoteProperty -Name "Resource Key" -Value  $resourceKey
                    $obj | Add-Member -MemberType NoteProperty -Name "Local translation" -Value  $translation
                    $array.Add($obj) | Out-Null
                    $counter++
                    Write-Progress -Activity "Resource key preparation $($fileName)" -Status "Resource key $($counter)"
                }else {
                    Write-Host "Not found "$key
                }
            }
        }

        $defaultValues = @{
            "/Resource Keys/Practical Info/Display Time" = "{0} - {1}";
            "/Resource Keys/Practical Info/Display Exceptional Date" = "{0} {1} {2}"
        }

        foreach($key in $defaultValues.Keys){
            $obj = New-Object System.Object
            $obj | Add-Member -MemberType NoteProperty -Name "Field" -Value  "Phrase"
            $obj | Add-Member -MemberType NoteProperty -Name "Resource Key" -Value  $key
            $obj | Add-Member -MemberType NoteProperty -Name "Local translation" -Value $defaultValues[$key]
            $array.Add($obj) | Out-Null
        }

        $array | Select-Object "Field", "Resource Key", "Local translation" | Export-Csv -Encoding UTF8 -notypeinformation -Path $outputFilePath
    }
    end {
        Write-Progress -Activity "Resource key preparation $($fileName)" -Completed
    }
    
}