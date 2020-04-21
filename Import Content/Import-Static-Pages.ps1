function IsDerived {
    param(
        [Parameter(Mandatory = $true, ValueFromPipeline = $true)] $Item,
        [Parameter(Mandatory = $true)] $TemplateId
    )
  
    return [Sitecore.Data.Managers.TemplateManager]::GetTemplate($item).InheritsFrom($TemplateId)
}
function Import-Static-Pages {

    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0 )]
        [string]$RegionName,
  
        [Parameter(Mandatory = $true, Position = 1 )]
        [string]$Language,
  
        [Parameter(Mandatory = $true, Position = 2 )]
        [string]$MallName
    )

    begin {
        Write-Host "Static Pages Creation for $RegionName - Begining"
        Import-Function Utils-Remove-Diacritics
        Import-Function Utils-Upload-CSV-File
    }

    process {
        # $Datas = Utils-Upload-CSV-File -Title "Import Static Pages"

        $HomePath = "/sitecore/content/Klepierre/$($RegionName)/$($MallName)/Home"
        $HomeItem = Get-Item -Path $HomePath -Language  $Language
        $StaticPagesRepository = $HomeItem.Children | Where-Object { $_ | IsDerived -TemplateId "{3AAE87C9-9C14-43F5-B964-3805233CDC08}" }
        $StaticPagesRepositoryPath = $HomePath + "/Static Pages Repository"
        #STATIC PAGE REPOSITORY
        if (!$StaticPagesRepository) {
            New-Item -Path $StaticPagesRepositoryPath -ItemType "{3AAE87C9-9C14-43F5-B964-3805233CDC08}" -Language $Language | Out-Null
            if (Test-Path -Path $StaticPagesRepositoryPath -ErrorAction SilentlyContinue) {

                New-Item -Path "$StaticPagesRepositoryPath/Error 404" -ItemType "{A09BCAB0-6EFA-45D8-A971-6135C90A9F7C}" -Language $Language | Out-Null
                New-Item -Path "$StaticPagesRepositoryPath/Error 500" -ItemType "{A09BCAB0-6EFA-45D8-A971-6135C90A9F7C}" -Language $Language | Out-Null
                New-Item -Path "$StaticPagesRepositoryPath/Legal Notice" -ItemType "{2662003A-1138-4790-A109-24335392765F}" -Language $Language | Out-Null
                New-Item -Path "$StaticPagesRepositoryPath/Privacy Notice" -ItemType "{2662003A-1138-4790-A109-24335392765F}" -Language $Language | Out-Null
                New-Item -Path "$StaticPagesRepositoryPath/Terms And Conditions" -ItemType "{2662003A-1138-4790-A109-24335392765F}" -Language $Language | Out-Null

            }
            else {
                Write-Error "Static page not created"
            }
        }
        else {
            Write-Host "TOKONY HANAO UPDATE SISA NDRI"
        }
        #STATIC PAGE REPOSITORY

        #FORM REPOSITORY
        $FormsRepository = $HomeItem.Children | Where-Object { $_ | IsDerived -TemplateId "{9C774E72-4205-41CB-AD95-12CC6646B42C}" }
        $FormsRepoPAth = $HomePath + "/Forms Repository"
        if (!$FormsRepository) {
            New-Item -Path $FormsRepoPAth -ItemType "{9C774E72-4205-41CB-AD95-12CC6646B42C}" -Language $Language | Out-Null
            if (Test-Path -Path $FormsRepoPAth -ErrorAction SilentlyContinue) {
                $ContactFormsPage = $FormsRepoPAth + "/Contact Forms Page"
                New-Item -Path "$FormsRepoPAth/Contact Forms Page" -ItemType "{081B68AD-11D9-4A2A-80AF-3D0F8713AD1E}" -Language $Language | Out-Null
                if (Test-Path -Path $ContactFormsPage -ErrorAction SilentlyContinue) {
                    New-Item -Path "$ContactFormsPage/Social Media Repository" -ItemType "{C8426DFD-D825-440C-A71A-4DE42A2DC914}" -Language $Language | Out-Null
                    New-Item -Path "$ContactFormsPage/Social Media Repository/Facebook" -ItemType "{2ED7C87B-C8A2-4531-88CC-4BC0706DD57A}" -Language $Language | Out-Null
                    New-Item -Path "$ContactFormsPage/Social Media Repository/Instagram" -ItemType "{2ED7C87B-C8A2-4531-88CC-4BC0706DD57A}" -Language $Language | Out-Null
                    New-Item -Path "$ContactFormsPage/Rent Permanent Space Page" -ItemType "{66502E8A-386C-45EE-B0C9-28AB51D990B6}" -Language $Language | Out-Null
                    New-Item -Path "$ContactFormsPage/Rent Temporary Space Page" -ItemType "{66502E8A-386C-45EE-B0C9-28AB51D990B6}" -Language $Language | Out-Null
                }
            }
        }
        else {
            Write-Host "efa misy"
        }
        #FORM REPOSITORY

        #GENERATE FORMS PER REGION
    }

    end {
        Write-Host "Static Pages Created successfully for : $RegionName " -BackgroundColor Green -ForegroundColor White
    }
}

Import-Static-Pages "France" "fr-fr" "odysseum"