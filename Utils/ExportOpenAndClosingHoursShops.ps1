function Reformat-Hour($Hours) {
    $split = $Hours.Split('T')
    $hs = $split[1]
    $Hh = $hs.substring(0, 2)
    $Mm = $hs.substring(2, 2)
    # $Ss = $hs.substring(4,2)
    return "$($Hh):$($Mm)"
}

function exportOCH {
    begin {
        Write-Host "Export Begin"
    }

    process {
        $regions = Get-ChildItem -Path "/sitecore/content/Klepierre/" | Where { $_.TemplateID -eq "{CE91FBD6-4D89-42C9-B5BC-2A670439E1FF}" -and !($_.Name -match "^Master") }
        foreach ($region in $regions) {
            $RegionName = $region.Name
            # Write-Host "$RegionName Finding - Begin"
            $malls = Get-ChildItem -Item $region | Where { $_.TemplateID -eq "{46591E02-8902-4C2C-AF61-3EB92BE2489A}" -and !($_.Name -match "^Alpha") }
            foreach ($mall in $malls) {

                $mallName = $mall.Name
                $settingPath = "$($mall.FullPath)/Settings/Site Grouping/$mallName"
                $settingItem = Get-Item -Path $settingPath
                $version = $settingItem["Language"]

                # $Malls = $mall.Children | Where { $_.TemplateID -eq "{46591E02-8902-4C2C-AF61-3EB92BE2489A}" -and !($_.Name -match "^Odysseum") }
                $shopRepo = "master:/sitecore/content/Klepierre/$RegionName/$mallName/Home/Shop Repository"
                $Stores = Get-ChildItem -Path $shopRepo -Language $version | Where { $_.TemplateID -eq "{A496118C-D0EF-440D-8DF5-5DEFE47E662E}" -or $_.TemplateID -eq "{80D19FA2-B1EF-4E32-93BD-4B2C650A126F}" }
                Write-Host "$RegionName#$mallName"
                Write-Host "Store#Day#Opening Hour#Closing Hour#Is Closed"
                foreach ($Store in $Stores) {
                    
                    $storeName = $Store["Shop Title"]

                    $openingHours = "master:/sitecore/content/Klepierre/$RegionName/$mallName/Home/Shop Repository/$($Store.Name)/Opening Hours"
                    if ((Test-Path -Path $openingHours -ErrorAction SilentlyContinue)) {
                    
                        $Days = Get-ChildItem -Path $openingHours -Language $version | Where { $_.TemplateID -eq "{6C32F517-77B1-4E0C-B8CE-D1FE77E25563}" }
                    
                        foreach ($Day in $Days) {
                            $dayName = $Day.Name

                            $item = Get-Item -Path "$openingHours/$dayName" -Language $version
                            $Day = $dayName
                            $opening = if (![string]::IsNullOrEmpty($item["Opening Time"])) { Reformat-Hour($item["Opening Time"]) }else { "Empty" }
                            $closing = if (![string]::IsNullOrEmpty($item["Closing Time"])) { Reformat-Hour($item["Closing Time"]) }else { "Empty" }
                            $isClosed = $item["Close"]

                            Write-Host "$storeName#$Day#$opening#$closing#$isClosed"
                        }
                    }
                    else {
                        Write-Host "$RegionName#$mallName"
                        Write-Host "Store#Day#Opening Hour#Closing Hour#Is Closed"
                    }
                }

            }
        }
    }

    end {
        Write-Host "Export Done"
    }
}

exportOCH