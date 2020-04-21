
function IsDerived {
    param(
      [Parameter(Mandatory=$true, ValueFromPipeline=$true)] $Item,
      [Parameter(Mandatory=$true)] $TemplateId
    )
  
      return [Sitecore.Data.Managers.TemplateManager]::GetTemplate($item).InheritsFrom($TemplateId)
  }

function Extract-Stores-Categories{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory = $true, Position = 0 )]
        [string]$RegionName,
    
        [Parameter(Mandatory = $true, Position = 1 )]
        [string]$Language
    )
    begin {
        Write-Host "Extract Stores Categroies Begin"
    }

    process{

        $outputFilePath = "$($AppPath)/$($RegionName)-Store-Categories.csv"
        $CategoryRepositoryPath = "master:/sitecore/content/Klepierre/$($RegionName)/Category Repository"
        $cateItems = Get-Item -Path $CategoryRepositoryPath -Language $Language
        $cateChildItems = $cateItems.Children | Where {$_.TemplateID -eq "{8368C239-3B61-4272-BB19-C4F7DF5DBB70}"}

        $obj = @()
        foreach($cate in $cateChildItems){
            $childOfCat = $cate.Children

            if($childOfCat.Count -gt 0){
                foreach($child in $childOfCat){
                    # $fields = $child.Fields
                    $obj += [pscustomobject] @{
                        CategoryID = $cate.ID
                        CategoryName  = $cate.Name
                        SubCategoryName = $child.Name
                        SubCategoryID = $child.ID
                        Label = $fields['Sub Category Name']
                    } 
                    Write-Host $cate.Name 
                    Write-Host "done ..." -BackgroundColor white -ForegroundColor Black
                }
                
            }else{
                $fields = $cate.Fields
                $obj += [pscustomobject] @{
                    CategoryID = $cate.ID
                    CategoryName  = $cate.Name
                    SubCategoryName = ""
                    Label = $fields['Category']
                }   
                Write-Host $cate.Name 
                Write-Host "done ..." -BackgroundColor white -ForegroundColor Black
            }
              
         
        
            Write-Host "done ..." -BackgroundColor white -ForegroundColor Black
        }

        
        
        $obj | Export-Csv -Path $outputFilePath -Encoding UTF8 -NoTypeInformation 

        Try {
            Send-File -Path $outputFilePath
        }
        Finally {
            Remove-Item -Path $outputFilePath
        }
    }
    end {
        Write-Host "Extract Stores Categroies end"
    }
}
Extract-Stores-Categories "Netherlands" "nl-nl"