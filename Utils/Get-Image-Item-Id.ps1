function Get-Image-Item-Id{
    param (
        [Parameter(Mandatory = $true, Position = 0 )]
        [string]$RawValue
    )


    process{
        $ResultRegex = "(?<={)(.*)(?=})"

        $Regex = [Regex]::new("$ResultRegex")       
        $Result = $Regex.Match($RawValue)   
        if ($Result.Success) {           
            return "{$($Result.Value)}"         
        }
    }
}

