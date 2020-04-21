function Update-Forms {
    $categoryPath = "master:/sitecore/content/Klepierre/Spain/Category Repository"
$language = "ca-ES"
Write-Host "Add Version $($language) : $($categoryPath)"
Add-ItemVersion -Path $categoryPath -TargetLanguage $language -Language "en"
$categories = Get-ChildItem -Path $categoryPath
foreach($category in $categories){
    Write-Host "Add Version $($language) : $($category.FullPath)"
    Add-ItemVersion -Item $category -TargetLanguage $language -Language "en"
}
}