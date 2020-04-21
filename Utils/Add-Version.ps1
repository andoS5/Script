function Add-Version {
    $categoryPath = "master:/sitecore/content/Klepierre/France/Brand Repository"
    $language = "en"
    Write-Host "Add Version $($language) : $($categoryPath)"
    Add-ItemVersion -Path $categoryPath -TargetLanguage $language -Language "fr-Fr"
    $categories = Get-ChildItem -Path $categoryPath
    foreach ($category in $categories) {
        Write-Host "Add Version $($language) : $($category.FullPath)"
        Add-ItemVersion -Item $category -TargetLanguage $language -Language "fr-Fr"
    }
}