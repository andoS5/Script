function Scaffolding-New-Mall {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true, Position = 0 )]
    [string]$RegionName,

    [Parameter(Mandatory = $true, Position = 1 )]
    [string]$Language,

    [Parameter(Mandatory = $true, Position = 2 )]
    [string]$MallName
  )

  begin {
    Write-Host "Cmdlet Scaffolding-New-Mall - Begin"
    Import-Function Invoke-SiteAction
    Import-Function Get-SiteMediaItem
    Import-Function New-MappingString
    Import-Function Get-SortedSetupItemsCollection
    Import-Function Get-TenantItem
    Import-Function Get-DataItem
    Import-Function Get-TenantTemplate
    Import-Function Set-TenantTemplate
    Import-Function Invoke-PostSetupStep
    Import-Function Get-SettingsItem
    Import-Function Get-Action
    Import-Function Test-ItemIsSiteDefinition
    Import-Function Add-SiteMediaLibrary
    Import-Function Get-ItemByIdSafe
    Import-Function Get-ProjectTemplateBasedOnBaseTemplate
    Import-Function Scaffolding-New-Region
  }

  process {
    Write-Host "Cmdlet Scaffolding-New-Mall - Process"

    New-UsingBlock (New-Object Sitecore.Data.BulkUpdateContext) {
    
      $regionPath = "master:/content/Klepierre/$($RegionName)"
    
      if (!(Test-Path -Path $regionPath -ErrorAction SilentlyContinue)) {
        Scaffolding-New-Region $RegionName $Language
      }
    
      $region = Get-Item -Path $regionPath -Language $Language
    
      $modulesID = @("{AE5D1384-BB75-4C6B-A8B5-4B008C2AC5DA}", "{CA502DCF-20D2-4618-A735-E4FCB6D5E114}", "{E2AF1A41-799E-481B-8FDC-B2D33FB729A1}", "{C4658673-5D70-44ED-9004-D66EAC1DC718}")
    
      $modules = @()
      foreach ($module in $modulesID) {
        $modules += Get-Item -Path master: -ID $module
      }
    
      $Model = New-Object Sitecore.XA.JSS.Foundation.Scaffolding.Models.CreateNewJSSSiteModel
      $Model.SiteName = $MallName -replace '[\W]', '-'
      $Model.DefinitionItems = $modules
      $Model.Language = $Language
      $Model.HostName = $MallName -replace '[\W]', '-'
      $Model.VirtualFolder = "/"
      $Model.SiteLocation = Get-Item -Path "master:/content/Klepierre"

      if (!(Test-Path -Path "$($regionPath)/$($Model.SiteName)" -ErrorAction SilentlyContinue)) {
        
        if ($Model.SiteName -and $Model.DefinitionItems) {
          [string]$SiteName = $Model.SiteName
          [Item[]]$DefinitionItems = Get-SortedSetupItemsCollection $Model.DefinitionItems
          [string]$language = $Model.Language
          [string]$hostName = $Model.HostName
          [string]$virtualFolder = $Model.VirtualFolder
          [Item]$SiteLocation = $Model.SiteLocation
  
          Write-Host "Cmdlet Add-Site - Process"
          Write-Host "Creating site ($SiteName) under: $($SiteLocation.Paths.Path)"
          Write-Host "Definitions items count: $($DefinitionItems.Length)"
          $siteBranch = "Branches/Foundation/Kortex/Klepierre Site"
  
          Write-Host -Activity ([Sitecore.Globalization.Translate]::Text([Sitecore.XA.Foundation.Scaffolding.Texts]::CreatingNewSite)) -CurrentOperation ([Sitecore.Globalization.Translate]::Text([Sitecore.XA.Foundation.Scaffolding.Texts]::GettingTenantItem)) -PercentComplete 0
          $tenant = Get-TenantItem $SiteLocation
          $tenantTemplatesRootID = $tenant.Fields['Templates'].Value
          $tenantTemplatesRoot = Get-Item -Path master: -ID $tenantTemplatesRootID
                
          Write-Host -Activity ([Sitecore.Globalization.Translate]::Text([Sitecore.XA.Foundation.Scaffolding.Texts]::CreatingNewSite)) -CurrentOperation ([Sitecore.Globalization.Translate]::Text([Sitecore.XA.Foundation.Scaffolding.Texts]::GettingTenantTemplates)) -PercentComplete 10
          $tenantTemplates = Get-TenantTemplate $tenantTemplatesRoot
          $site = New-Item -Parent $region -Name $SiteName -ItemType $siteBranch -Language $language
                
          Write-Host -Activity ([Sitecore.Globalization.Translate]::Text([Sitecore.XA.Foundation.Scaffolding.Texts]::CreatingNewSite)) -CurrentOperation ([Sitecore.Globalization.Translate]::Text([Sitecore.XA.Foundation.Scaffolding.Texts]::SettingTenantTemplatesLocation)) -PercentComplete 15
          Set-TenantTemplate $site $tenantTemplates
                
          Write-Host -Activity ([Sitecore.Globalization.Translate]::Text([Sitecore.XA.Foundation.Scaffolding.Texts]::CreatingNewSite)) -CurrentOperation ([Sitecore.Globalization.Translate]::Text([Sitecore.XA.Foundation.Scaffolding.Texts]::CreatingSiteMediaLibrary)) -PercentComplete 20
          $siteMediaLibrary = Add-SiteMediaLibrary $Site
          $site.SiteMediaLibrary = $siteMediaLibrary.ID
          (Get-SiteMediaItem $Site).AdditionalChildren = $siteMediaLibrary.ID
                
          $settingsItem = Get-SettingsItem $Site
          $settingsItem.LayoutPath = Get-ItemByIdSafe "{96E5F4BA-A2CF-4A4C-A4E7-64DA88226362}"
          $settingsItem.RenderingsPath = Get-ItemByIdSafe $tenant.RenderingsFolder
          $settingsItem.PlaceholdersPath = Get-ItemByIdSafe $tenant.PlaceholderSettingsFolder
          $settingsItem.AppDatasourcesPath = Get-DataItem $site
          $settingsItem.DictionaryPath = $site.Children["Dictionary"]
          [Sitecore.Data.ID]$jssPageTemplateID = [Sitecore.XA.JSS.Foundation.Multisite.Templates+JSSPage]::ID
          [Sitecore.Data.ID]$jssSiteTemplateID = [Sitecore.XA.JSS.Foundation.Multisite.Templates+JSSSite]::ID
          $settingsItem.AppTemplate = Get-ProjectTemplateBasedOnBaseTemplate $TenantTemplates $jssSiteTemplateID | Select-Object -First 1
          $settingsItem.FilesystemPath = "/dist/$SiteName"
          $settingsItem.Templates = $tenant.Templates
          $settingsItem.Editing.BeginEdit()
          $Model.SiteSettings.AllKeys | % {
            $settingsItem.Fields[$_].Value = $Model.SiteSettings[$_]
          }
          $settingsItem.Editing.EndEdit() | Out-Null
          $settingsItem.GraphQLEndpoint = "/api/$SiteName"
  
          <# $percentage_start = 35
          $percentage_end = 85
          $percentage_diff = $percentage_end - $percentage_start
          $Items = Get-ChildItem -Path $site.Paths.Path -Recurse
          foreach ($definitionItem in $DefinitionItems) {
            $currentIndex = $DefinitionItems.IndexOf($definitionItem)
            $percentComplete = ($percentage_start + 1.0 * $percentage_diff * ($currentIndex) / ($DefinitionItems.Count))
            $currentOperation = $([Sitecore.Globalization.Translate]::Text([Sitecore.XA.Foundation.Scaffolding.Texts]::InstallingFeature)) -f $definitionItem._Name
            Write-Host -Activity ([Sitecore.Globalization.Translate]::Text([Sitecore.XA.Foundation.Scaffolding.Texts]::CreatingNewSite)) -CurrentOperation ($currentOperation) -PercentComplete $percentComplete
            $actions = $definitionItem | Get-Action
            foreach ($actionItem in $actions) {
              Invoke-SiteAction $site $actionItem -EditingTheme $editingTheme -language $language
            }
          } #>
  
          Write-Host -Activity ([Sitecore.Globalization.Translate]::Text([Sitecore.XA.Foundation.Scaffolding.Texts]::CreatingNewSite)) -CurrentOperation ([Sitecore.Globalization.Translate]::Text([Sitecore.XA.Foundation.Scaffolding.Texts]::SettingDefaultValues)) -PercentComplete 90
                
          $defaultDeviceID = "{FE5D7FDF-89C0-4D99-9AA3-B5FBD009C9F3}"
  
          Write-Host -Activity ([Sitecore.Globalization.Translate]::Text([Sitecore.XA.Foundation.Scaffolding.Texts]::CreatingNewSite)) -CurrentOperation ([Sitecore.Globalization.Translate]::Text([Sitecore.XA.Foundation.Scaffolding.Texts]::ConfiguringSiteDefinitionItem)) -PercentComplete 93
          $siteDefinitionItem = Get-ChildItem -Recurse -Path ($settingsItem.Paths.Path) | ? { (Test-ItemIsSiteDefinition $_) -eq $true } | Select-Object -First 1
            
          #$siteDefinitionItem.HostName = $hostName
          $siteDefinitionItem.VirtualFolder = $virtualFolder
  
          if ([string]::IsNullOrWhiteSpace($siteDefinitionItem.SiteName) -or ("`$name" -eq $siteDefinitionItem.SiteName)) {
            $siteDefinitionItem.SiteName = $siteDefinitionItem.Name
          }
            
          if ([string]::IsNullOrWhiteSpace($siteDefinitionItem.Environment)) {
            $siteDefinitionItem.Environment = "*"
          }
                
          Get-ProjectTemplateBasedOnBaseTemplate $TenantTemplates ($jssPageTemplateID.ToString()) | ? {
            $appRouteTemplate = $_
            $homeItem = Get-ChildItem -Path ($Site.Paths.Path) | ? { $_.TemplateID -eq "{D108FA2E-BC43-4A25-ACD7-998E64585588}" } | Select-Object -First 1
            $homeItem -ne $null
          } | Out-Null
                
          if ($homeItem) {
            $siteDefinitionItem.StartItem = $homeItem.ID    
          }
                
          Write-Host -Activity ([Sitecore.Globalization.Translate]::Text([Sitecore.XA.Foundation.Scaffolding.Texts]::CreatingNewSite)) -CurrentOperation ([Sitecore.Globalization.Translate]::Text([Sitecore.XA.Foundation.Scaffolding.Texts]::SettingTenantTemplatesLocation)) -PercentComplete 99
          Set-TenantTemplate $site $tenantTemplates
            
          $site = $site.Database.GetItem($site.ID) | Wrap-Item
          $site.Modules = $DefinitionItems.ID -join "|"            
  
          #Invoke-PostSetupStep $Model.DefinitionItems $Model
        }
        else {
          Write-Host "Error - Could not create site. Site name or module definitions is undefined"
        }
      } else {
        Write-Host "Error - This mall already exists"
      }
    }
  }
  end {
    Write-Host -Activity ([Sitecore.Globalization.Translate]::Text([Sitecore.XA.Foundation.Scaffolding.Texts]::YourSiteHasBeenCreated)) -CurrentOperation "" -PercentComplete 100
    Write-Host "Cmdlet Scaffolding-New-Mall - End"
  }
}