function Utils-IsDerived {
  param(
    [Parameter(Mandatory=$true, ValueFromPipeline=$true)] $Item,
    [Parameter(Mandatory=$true)] $TemplateId
  )

    return [Sitecore.Data.Managers.TemplateManager]::GetTemplate($item).InheritsFrom($TemplateId)
}