
$Mall = "master:/sitecore/content/Klepierre/Norway"
$sites = Get-ChildItem -Path $Mall | Where { $_.TemplateID -eq "{46591E02-8902-4C2C-AF61-3EB92BE2489A}" }
foreach($site in $sites){
    $siteName = $site.Name
    Write-Host $siteName
    $temporarySpaceDesc = "master:/sitecore/content/Klepierre/Norway/$siteName/Home/Forms Repository/Rent Permanent Space Page"

    $tempItem = Get-Item -Path $temporarySpaceDesc -Language "nb-NO"

    $tempItem.Editing.BeginEdit() | Out-Null
    $tempItem["Rent Local Description"] = "Ønsker du å leie en butikk for din merkevare i vårt kjøpesenter? Fyll ut skjemaet under, og vi vil ta kontakt med deg snarest mulig."
    $tempItem.Editing.EndEdit() | Out-Null

    #Forms
    
    # $BrandName = "master:/sitecore/Forms/Norway/$siteName/Rent A Local/Page/Brand name"
    # $ItemBN =  Get-Item -Path $BrandName -Language "nb-NO"
    # $ItemBN.Editing.BeginEdit() | Out-Null
    # $ItemBN["Placeholder Text"] = "Varemerke"
    # $ItemBN.Editing.EndEdit() | Out-Null

    # $Companyname = "master:/sitecore/Forms/Norway/$siteName/Rent A Local/Page/Company name"
    # $ItemCN =  Get-Item -Path $Companyname -Language "nb-NO"
    # $ItemCN.Editing.BeginEdit() | Out-Null
    # $ItemCN["Placeholder Text"] = "Selskap"
    # $ItemCN.Editing.EndEdit() | Out-Null

    # $lastName = "master:/sitecore/Forms/Norway/$siteName/Rent A Local/Page/Last name"
    # $ItemLN =  Get-Item -Path $lastName -Language "nb-NO"
    # $ItemLN.Editing.BeginEdit() | Out-Null
    # $ItemLN["Placeholder Text"] = "Etternavn"
    # $ItemLN.Editing.EndEdit() | Out-Null

    # $Firstname = "master:/sitecore/Forms/Norway/$siteName/Rent A Local/Page/First name"
    # $ItemFN =  Get-Item -Path $Firstname -Language "nb-NO"
    # $ItemFN.Editing.BeginEdit() | Out-Null
    # $ItemFN["Placeholder Text"] = "Fornavn"
    # $ItemFN.Editing.EndEdit() | Out-Null

    # $Emailaddress = "master:/sitecore/Forms/Norway/$siteName/Rent A Local/Page/Email address"
    # $ItemEA =  Get-Item -Path $Emailaddress -Language "nb-NO"
    # $ItemEA.Editing.BeginEdit() | Out-Null
    # $ItemEA["Placeholder Text"] = "E-post"
    # $ItemEA.Editing.EndEdit() | Out-Null

    # $Phone = "master:/sitecore/Forms/Norway/$siteName/Rent A Local/Page/Phone"
    # $ItemP =  Get-Item -Path $Phone -Language "nb-NO"
    # $ItemP.Editing.BeginEdit() | Out-Null
    # $ItemP["Placeholder Text"] = "Telefonnummer"
    # $ItemP.Editing.EndEdit() | Out-Null

    # $SurfaceArea = "master:/sitecore/Forms/Norway/$siteName/Rent A Local/Page/Surface Area"
    # $ItemSce =  Get-Item -Path $SurfaceArea -Language "nb-NO"
    # $ItemSce.Editing.BeginEdit() | Out-Null
    # $ItemSce["Placeholder Text"] = "Ønsket butikkareal"
    # $ItemSce.Editing.EndEdit() | Out-Null

    # $MessageForm = "master:/sitecore/Forms/Norway/$siteName/Rent A Local/Page/Message Form"
    # $ItemMF =  Get-Item -Path $MessageForm -Language "nb-NO"
    # $ItemMF.Editing.BeginEdit() | Out-Null
    # $ItemMF["Placeholder Text"] = "Beskrivelse av virksomhet / Melding (valgfritt)"
    # $ItemMF.Editing.EndEdit() | Out-Null

    # $SubmitButton = "master:/sitecore/Forms/Norway/$siteName/Rent A Local/Page/Submit Button"
    # $ItemSb =  Get-Item -Path $SubmitButton -Language "nb-NO"
    # $ItemSb.Editing.BeginEdit() | Out-Null
    # $ItemSb["Title"] = "Send inn"
    # $ItemSb.Editing.EndEdit() | Out-Null
}
