
function Update-Region-Categories {
  param (
    [Parameter(Mandatory = $true, Position = 0 )]
    [string]$RegionName,
    
    [Parameter(Mandatory = $true, Position = 1 )]
    [string]$Language
  )

  Begin {
    Write-Host "Updage Category for $RegionName - Begin"
    Import-Function Utils-Remove-Diacritics
    Import-Function Utils-Upload-CSV-File
  }

  process {
    $CategoryRepository = "master:/sitecore/content/Klepierre/$RegionName/Category Repository"
    $ServiceCategoryRepository = "master:/sitecore/content/Klepierre/$RegionName/Service Category Repository"

    $category = Get-ChildItem -Path $CategoryRepository -Language $Language | Where { $_.TemplateID -eq "{8368C239-3B61-4272-BB19-C4F7DF5DBB70}" }
    $service = Get-ChildItem -Path $ServiceCategoryRepository -Language $Language | Where { $_.TemplateID -eq "{C96D2C04-2557-45BC-9B39-000596DA0C1E}" }

    $Datas = Utils-Upload-CSV-File -Title "Category Localisation"
    foreach ($Data in $Datas) {
      $catNameFK = Utils-Remove-Diacritics $Data["categoryName"].Trim()
      foreach ($cat in $category) {
        

        if ($cat.Name -eq $catNameFK) {
          Write-Host "category " $catNameFK "====" $cat.Name
          $cat.Editing.BeginEdit()
          $cat["Category"] = $Data["categoryLabel"]
          $cat.Editing.EndEdit()
        }

        if ($cat.Children) {
          $subcat = $cat.Children
          
          foreach ($subcats in $subcat) {
            
            if ($catNameFK -eq $subcats.Name) {
              Write-Host "zanaka category" $subcats.Name "===" $catNameFK
              $subcats.Editing.BeginEdit()
              $subcats["Sub Category Name"] = $Data["categoryLabel"].Trim()
              $subcats.Editing.EndEdit()
            }
          }
        }
    
      }

      foreach ($serv in $service) {
        Write-Host $catNameFK "=====" $serv.Name
        if ($catNameFK -eq $serv.Name) {
          $serv.Editing.BeginEdit()
          $serv["Service Label"] = $Data["categoryLabel"]
          $serv.Editing.EndEdit()
        }
      }

    }
    
  }

  end {
    Write-Host "All Categories and Sub-Categories for $RegionName updated"
  }
  
}

Update-Region-Categories "France" "en"