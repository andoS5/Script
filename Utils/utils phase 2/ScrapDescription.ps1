function ScrapDescription {
    param(
        [Parameter(Mandatory = $true, Position = 0 )]
        [string]$HTMLContent
    )

    process {
        $pattern = '<p>(?<quote>.*</p>)'
        $ResultRegex = '^<p>((?!<|>).)*<\/p>'
        $match = [regex]::Matches($HTMLContent, $pattern) | Select-Object -ExpandProperty Value
        $description = ""
        foreach ($m in $match) {
            $result = [regex]::Matches($m, $ResultRegex)
            if ($result.Success) {
                $description += $result.Value
            }
        }
        return $description
    }

}