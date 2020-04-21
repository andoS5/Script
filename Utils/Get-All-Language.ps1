Import-Function Utils-IsDerived 
function Utils-Get-All-Language {
  $languageContainer = Get-Item -Path master: -ID "{64C4F646-A3FA-4205-B98E-4DE2C609B60F}"
  $languageItem = $languageContainer.Children | Where-Object { $_ | Utils-IsDerived -TemplateId "{F68F13A6-3395-426A-B9A1-FA2DC60D94EB}" }
  $languages = @{ }
  $languageItem | ForEach-Object {
    $languages.add($_.Name.ToLower(), $_.Name) | Out-Null
  }
  return $languages 
}