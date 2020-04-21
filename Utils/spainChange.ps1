$RegionRepository = "master:/sitecore/content/Klepierre/Spain"
$Malls = Get-ChildItem -Path $RegionRepository -Language "es-ES" | Where { $_.TemplateID -eq "{46591E02-8902-4C2C-AF61-3EB92BE2489A}" }

foreach ($Mall in $Malls) {
    $MallName = $Mall.Name
    # $MallName = "GranTuria"
    
    Write-Host "Update text on $MallName Starded" -ForegroundColor Yellow
    $title = "master:/sitecore/content/Klepierre/Spain/$MallName/Resource Keys/Critizr/CritizrContentTitle"
    $CritizrContentTitle = Get-Item -Path $title -Language "es-ES"
    $CritizrContentTitle.Editing.BeginEdit() | Out-Null
    $CritizrContentTitle["Phrase"] = "TU OPINIÓN NOS IMPORTA"
    $CritizrContentTitle.Editing.EndEdit() | Out-Null
    
    $body = "master:/sitecore/content/Klepierre/Spain/$MallName/Resource Keys/Critizr/CritizrHeaderText"
    $CritizrHeaderText = Get-Item -Path $body -Language "es-ES"
    $CritizrHeaderText.Editing.BeginEdit() | Out-Null
    $CritizrHeaderText["Phrase"] = "¿Nos quieres contar algo? Todos tus comentarios son importantes para nosotros. ¡Compártelos! Estaremos encantados de escucharte."
    $CritizrHeaderText.Editing.EndEdit() | Out-Null

    $light = "master:/sitecore/content/Klepierre/Spain/$MallName/Home/Media Repository/CritizrGiveSuggestionImageWithText"
    $CritizrGiveSuggestionImageWithText = Get-Item -Path $light -Language "es-ES"
    $CritizrGiveSuggestionImageWithText.Editing.BeginEdit() | Out-Null
    $CritizrGiveSuggestionImageWithText["text"] = "Deja una sugerencia"
    $CritizrGiveSuggestionImageWithText.Editing.EndEdit() | Out-Null

    $clap = "master:/sitecore/content/Klepierre/Spain/$MallName/Home/Media Repository/CritizrPayComplimentImageWithText"
    $CritizrPayComplimentImageWithText = Get-Item -Path $clap -Language "es-ES"
    $CritizrPayComplimentImageWithText.Editing.BeginEdit() | Out-Null
    $CritizrPayComplimentImageWithText["text"] = "Comparte un comentario positivo"
    $CritizrPayComplimentImageWithText.Editing.EndEdit() | Out-Null

    $vignette = "master:/sitecore/content/Klepierre/Spain/$MallName/Home/Media Repository/CritizrReportProblemImageWithText"
    $CritizrReportProblemImageWithText = Get-Item -Path $vignette -Language "es-ES"
    $CritizrReportProblemImageWithText.Editing.BeginEdit() | Out-Null
    $CritizrReportProblemImageWithText["text"] = "Comunica un problema"
    $CritizrReportProblemImageWithText.Editing.EndEdit() | Out-Null

    $buttonText = "master:/sitecore/content/Klepierre/Spain/$MallName/Resource Keys/Critizr/CritizrButtonText"
    $CritizrButtonText = Get-Item -Path $buttonText -Language "es-ES"
    $CritizrButtonText.Editing.BeginEdit() | Out-Null
    $CritizrButtonText["Phrase"] = "¡Cuéntanoslo aquí!"
    $CritizrButtonText.Editing.EndEdit() | Out-Null
    Write-Host "Update text on $MallName Done" -ForegroundColor Green
}