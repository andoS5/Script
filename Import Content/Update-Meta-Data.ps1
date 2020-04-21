function Content-Update-Meta-Data {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0 )]
        [Item]$Item,
        [Parameter(Mandatory = $true, Position = 1 )]
        [HashTable]$Row,
        [Parameter(Mandatory = $true, Position = 2 )]
        [string]$RegionName,
        [Parameter(Mandatory = $true, Position = 3 )]
        [string]$MallName,
        [Parameter(Mandatory = $true, Position = 4 )]
        [string]$Type
    )
    begin { 
        Import-Function Utils-GetImageFromMediaLibrary
    }
    process {
        $Item['Page Title'] = $Row['Meta Title']
        $Item['Meta Description'] = $Row['Meta Description']
        $Item['Meta Keywords'] = $Row['Meta Keywords']
        $Item['Canonical Url'] = $Row['Canonical Url']
        $Item['Open Graph Title'] = $Row['Open Graph Title']
        $Item['Open Graph Description'] = $Row['Open Graph Description']

        if(![string]::IsNullOrEmpty($Row['Open Graph Image'])){
            $image = Utils-GetImageFromMediaLibrary $RegionName "" $MallName "$($Type)/desktop" $Row['Open Graph Image']
            if($image -ne $null){
                $Item['Open Graph Image'] = "<image mediaid=`"$($image.ID)`" alt=`"$($image.Name)`" height=`"`" width=`"`" hspace=`"`" vspace=`"`" />"
            }
        }
    }
    end {
    }
}