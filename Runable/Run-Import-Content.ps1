function Run-Import-Content {
    begin {
        Write-Host "Import Content... Begin"
        import-function Utils-Get-All-Language
        import-function Content-Update-Page-Design
        import-function Content-UploadImages
        import-function Import-Content-Resource-Key
        import-function Import-Content-Practical-Information
        import-function Import-Content-Header
        import-function Import-Content-Footer
        import-function Import-Content-Services
        import-function Import-Content-Stores
        import-function Import-Content-Home-Page
        import-function Import-Content-Deals
    }
    process {
        $langages = Utils-Get-All-Language
        $props = @{
            Parameters  = @(
                @{Name = "root"; Title = "Path"; Root = "/sitecore/"; Editor = "item" }
                @{Name = "version"; Title = "Select langage"; Options = $langages; Tooltip = "Choose one." }
            )
            Title       = "Import Content"
            Description = "eg: /sitecore/content/Klepierre/Master Region/Alpha"
            Width       = 500
            Height      = 300
            ShowHints   = $true
        }

        $result = Read-Variable @props
        if ($result -ne "ok") {
            Write-Host "Cancelled"
            Exit
        }

        if(!($root.TemplateId -eq "{46591E02-8902-4C2C-AF61-3EB92BE2489A}" )) {
            Write-Host "Wrong path! Please try like that /sitecore/content/Klepierre/Master Region/Alpha"
            Exit
        }

        $mallFullPath = $root.Paths.FullPath.Split("/", [System.StringSplitOptions]::RemoveEmptyEntries)
        $region = $mallFullPath[3]
        $mall   = $mallFullPath[4]

        ###Update Page design
        Content-Update-Page-Design $region $version $mall

        ###Upload all Images (Banners and logos for Stores,Services,Home-Page)
        $typeContent = @("Stores", "Services", "Home-Page")
        for ($i = 0; $i -lt $typeContent.Count; $i++) {
            Content-UploadImages  $region $version $mall $typeContent[$i]
        }

        ###Import Resource Key
        Import-Content-Resource-Key $region $version $mall

        ###Import Practical Info
        Import-Content-Practical-Information

        ###Import Header
        Import-Content-Header

        ###Import Footer
        Import-Content-Footer

        ###Import Home-Page 
        Import-Content-Home-Page $region $version $mall

        ###Import Deals
        Import-Content-Deals

        ###Import Services
        Import-Content-Services $region $version $mall

        ###Import Shops & Resto
        Import-Content-Stores $region $version $mall

    }
    end {
        Write-Host "Import Content COMPLETED" -BackgroundColor Green
    }
}