

function Reformat-Hour($Hours) {
    $split = $Hours.Split('T')
    $hs = $split[1]
    $Hh = $hs.substring(0, 2)
    $Mm = $hs.substring(2, 2)
    # $Ss = $hs.substring(4,2)
    return "$($Hh):$($Mm)"
}

function openingAndClosingMall {
    Begin {
        Write-Host "Starting export"
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

                $OHRepo = "master:/sitecore/content/Klepierre/$RegionName/$mallName/Home/Practical Information/Opening Hours Repository"

                $days = Get-ChildItem -Path $OHRepo -Language $version | Where { $_.TemplateID -eq "{6C32F517-77B1-4E0C-B8CE-D1FE77E25563}" }
                Write-Host "$RegionName#$mallName"
                Write-Host "Day#Opening Hour#Closing Hour#Is Closed"
                foreach ($day in $days) {
                    $dayName = $day.Name

            

                    $item = Get-Item -Path "$OHRepo/$dayName" -Language $version
                    $Day = $dayName
                    $opening = Reformat-Hour($item["Opening Time"])
                    $closing = Reformat-Hour($item["Closing Time"])
                    $isClosed = $item["Close"]

                    Write-Host "$Day#$opening#$closing#$isClosed"
            
                }


            }
        }
    }

    end{
        Write-Host "Export Done"
    }
}

openingAndClosingMall