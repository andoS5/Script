function Update-Alt-Text {


    begin{
        Write-Host "Update-Alt-Text - Start"
        Import-Function Utils-IsDerived 
    }

    process{


        $regions = Get-ChildItem -Path "/sitecore/content/Klepierre/" | Where {$_.TemplateID -eq "{CE91FBD6-4D89-42C9-B5BC-2A670439E1FF}" -and !($_.Name -match "^Master") }
        foreach($region in $regions){
            $RegionName = $region.Name
            Write-Host "$RegionName Update - Begin"
            $malls = Get-ChildItem -Item $region | Where {$_.TemplateID -eq "{46591E02-8902-4C2C-AF61-3EB92BE2489A}" -and !($_.Name -match "^Alpha")}
            foreach ($mall in $malls) {
                $mallName = $mall.Name

                $settingPath = "$($mall.FullPath)/Settings/Site Grouping/$mallName"
                $settingItem = Get-Item -Path $settingPath
                $Language = $settingItem["Language"]

                Write-Host "Starting update Alt Text for $mallName Icons"
                #AppleStore
                $AppleStore =  "master:/sitecore/content/Klepierre/$RegionName/$mallName/Home/Navigation Container/Footer Repository/Mobile App Repository/AppleStore"  
                $AppleStoreItem = Get-Item -Path $AppleStore -Language $Language
    
                $AppleStoreFields = $AppleStoreItem.Fields
                $AppleStoreImageTag = $AppleStoreFields["Mobile App Icon"].Value
                if(![string]::IsNullOrEmpty($AppleStoreImageTag)){
                    $AppleStoreUpdatedValue = $AppleStoreImageTag -replace ("alt=`"(.*?)`"", "alt=`"Apple Store Icon`"")
                    $AppleStoreItem.Editing.BeginEdit() | Out-Null
                    $AppleStoreItem["Mobile App Icon"] = $AppleStoreUpdatedValue
                    $AppleStoreItem.Editing.EndEdit() | Out-Null
                }
                
    
                #Playstore
                $Playstore =  "master:/sitecore/content/Klepierre/$RegionName/$mallName/Home/Navigation Container/Footer Repository/Mobile App Repository/Playstore"  
                $PlaystoreItem = Get-Item -Path $Playstore -Language $Language
                $PlaystoreFields = $PlaystoreItem.Fields
    
                $PlaystoreImageTag = $PlaystoreFields["Mobile App Icon"].Value
                if(![string]::IsNullOrEmpty($PlaystoreImageTag)){
                    $PlaystoreUpdatedValue = $PlaystoreImageTag -replace ("alt=`"(.*?)`"", "alt=`"Play Store Icon`"")
                    $PlaystoreItem.Editing.BeginEdit() | Out-Null
                    $PlaystoreItem["Mobile App Icon"] = $PlaystoreUpdatedValue
                    $PlaystoreItem.Editing.EndEdit() | Out-Null
                }
    
                #Facebook
                $Facebook =  "master:/sitecore/content/Klepierre/$RegionName/$mallName/Home/Navigation Container/Footer Repository/Social Media Repository/Facebook"  
                $FacebookItem = Get-Item -Path $Facebook -Language $Language
                $FacebookFields = $FacebookItem.Fields
    
                $FacebookImageTag = $FacebookFields["Social Media Icon"].Value
                if(![string]::IsNullOrEmpty($FacebookImageTag)){
                    $FacebookUpdatedValue = $FacebookImageTag -replace ("alt=`"(.*?)`"", "alt=`"Facebook Icon`"")
                    $FacebookItem.Editing.BeginEdit() | Out-Null
                    $FacebookItem["Social Media Icon"] = $FacebookUpdatedValue
                    $FacebookItem.Editing.EndEdit() | Out-Null
                }
    
                #Instagram
                $Instagram =  "master:/sitecore/content/Klepierre/$RegionName/$mallName/Home/Navigation Container/Footer Repository/Social Media Repository/Instagram"  
                $InstagramItem = Get-Item -Path $Instagram -Language $Language
                $InstagramFields = $InstagramItem.Fields
    
                $InstagramImageTag = $InstagramFields["Social Media Icon"].Value
                if(![string]::IsNullOrEmpty($InstagramImageTag)){
                    $InstagramUpdatedValue = $InstagramImageTag -replace ("alt=`"(.*?)`"", "alt=`"Instagram Icon`"")
                    $InstagramItem.Editing.BeginEdit() | Out-Null
                    $InstagramItem["Social Media Icon"] = $InstagramUpdatedValue
                    $InstagramItem.Editing.EndEdit() | Out-Null
                }
    
                Write-Host "Alt Text for $mallName Icons Updated" -ForegroundColor Green
            }
            Write-Host "$RegionName Update - End"
        }
        
        
    }

    end{
        Write-Host "Alt text Updated "
    }
}

Update-Alt-Text