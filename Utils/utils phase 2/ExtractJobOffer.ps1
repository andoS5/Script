function formatDateHour($RawValueDate) {
    if ($null -ne $RawValueDate -and $RawValueDate.Contains('T')) {
        return "$($RawValueDate.Substring(4,2))-$($RawValueDate.Substring(6,2))-$($RawValueDate.Substring(0,4))"
    }
}

function Get-Name-By-ID($ID) {
    $listId = $null
    $listName = $null
    if ($ID.Contains('|')) {
        $listId = $ID.split('|')
        foreach ($list in $listId) {
            if ($list.Trim() -ne $null -and $list.Contains("{")) {
                $var = Get-Item master: -ID $list
                $listName = "$($listName)|$($var.Name)".substring(1)
            }
        }
    }
    else {
        # $listId = $ID
        $var = if (![string]::IsNullOrEmpty($ID)) {
            $var = Get-Item master: -ID $ID
            $listName = "$($var.Name)"
        }
        else {
            $listName = ""
        }
        
    }
    return $listName
}

function Get-Image-Item-Id {
    param (
        [Parameter(Mandatory = $true, Position = 0 )]
        [string]$RawValue
    )
    process {
        $ResultRegex = "(?<={)(.*)(?=})"

        $Regex = [Regex]::new("$ResultRegex")       
        $Result = $Regex.Match($RawValue)   
        if ($Result.Success) {           
            return "{$($Result.Value)}"         
        }
    }
}
function ExtractJobOffer {
    param (
        [Parameter(Mandatory = $true, Position = 0 )]
        [string]$RegionName,
        [Parameter(Mandatory = $true, Position = 1 )]
        [string]$MallName,
        [Parameter(Mandatory = $true, Position = 2 )]
        [string]$Language
    )

    process {
        $outputFilePath = "$($AppPath)/Job offers details pages - $MallName.csv"
        $array = New-Object System.Collections.ArrayList
        $cpt = 1

        $jobOffersRepository = "master:/sitecore/content/Klepierre/$RegionName/$MallName/Home/Job offers"

        $jobOffers = Get-ChildItem -Path $jobOffersRepository -Language $Language
        $count = $jobOffers.Count

        foreach ($jo in $jobOffers) {

            $Brand = Get-Name-By-ID($jo['Brand'])
            $PostedDate = formatDateHour $jo['Posted Date']
            $EndDate = formatDateHour $jo['End Date']
            $Title = $jo['Title']
            $Contracttype = $jo['Contract type']
            $Description = $jo['Description']
            $Whatsrequired = $jo['Whats required']
            $Howtoapply = $jo['How to apply']
            $Letsmeetup = $jo['Lets meet up']
            $Urgent = $jo['Urgent']

            $obj = New-Object System.Object
            $obj | Add-Member -MemberType NoteProperty -Name "Brand"-Value $Brand
            $obj | Add-Member -MemberType NoteProperty -Name "PostedDate"-Value $PostedDate
            $obj | Add-Member -MemberType NoteProperty -Name "EndDate"-Value $EndDate
            $obj | Add-Member -MemberType NoteProperty -Name "Title"-Value $Title
            $obj | Add-Member -MemberType NoteProperty -Name "Contracttype"-Value $Contracttype
            $obj | Add-Member -MemberType NoteProperty -Name "Description"-Value $Description
            $obj | Add-Member -MemberType NoteProperty -Name "Whatsrequired"-Value $Whatsrequired
            $obj | Add-Member -MemberType NoteProperty -Name "Howtoapply"-Value $Howtoapply
            $obj | Add-Member -MemberType NoteProperty -Name "Letsmeetup"-Value $Letsmeetup
            $obj | Add-Member -MemberType NoteProperty -Name "Urgent"-Value $Urgent
            $array.Add($obj) | Out-Null         
            Write-Host "[$($cpt)/$($count)]  ---- done" -ForegroundColor Green
            $cpt ++;

        }
        $array | Select-Object Brand,PostedDate,EndDate,Title,Contracttype,Description,Whatsrequired,Howtoapply,Letsmeetup,Urgent | Export-Csv -Encoding UTF8 -notypeinformation -Path $outputFilePath
        Try {
            Send-File -Path $outputFilePath
        }
        Finally {
            Remove-Item -Path $outputFilePath
        }
    }
}
$RegionName = "Denmark"
$MallName = "Fields"
$Language = "da"
ExtractJobOffer $RegionName $MallName $Language