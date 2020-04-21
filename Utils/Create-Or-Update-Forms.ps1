function Forms-Creation {
    begin {
        Write-Host "Creation or Update Forms Item for $RegionName - Starting"
        import-Function Utils-IsDerived
    }

    process {
        $project = Get-Item -Path "master:/sitecore/content/Klepierre"
        $Regions = $project.Children | Where { $_.TemplateID -eq "{CE91FBD6-4D89-42C9-B5BC-2A670439E1FF}" -and !($_.Name -match "^Master") }
       
        
        foreach ($Region in $Regions) {
            $regionName = $Region.Name 
            # $regionName = "France"
            #create folder region
            #1 test if the Region exist
            $Container = "master:/sitecore/Forms/$regionName"
            if (!(Test-Path -Path $Container -ErrorAction SilentlyContinue) -and !($regionName.Contains("Master"))) {
                New-Item -Path $Container -ItemType "{A87A00B1-E6DB-45AB-8B54-636FEC3B5523}" | Out-Null

            }
            
            if ((Test-Path -Path $Container -ErrorAction SilentlyContinue)) {
                
                
                $Malls = $Region.Children | Where { $_.TemplateID -eq "{46591E02-8902-4C2C-AF61-3EB92BE2489A}" -and !($_.Name -match "^Odysseum") }
                foreach ($Mall in $Malls) {
                    $MallName = $Mall.Name
                    # $MallName = "Beaulieu"

                    $settingPath = "/sitecore/content/Klepierre/$regionName/$MallName/Settings/Site Grouping/$MallName"
                    $settingItem = Get-Item -Path $settingPath
                    $version = $settingItem["Language"]

                    if (!$MallName.Contains("Alpha")) {

                        $FormRepositoryPath = "master:/sitecore/content/Klepierre/$regionName/$MallName/Home/Forms Repository"
                        if (!(Test-Path -Path $FormRepositoryPath -ErrorAction SilentlyContinue)) {
                            # Creation des forms repository - page contact et location
                            Copy-Item -Path "master:/sitecore/content/Klepierre/Master Region/Alpha/Home/Forms Repository" -Destination $FormRepositoryPath -Recurse
                            # ajout de version pour la forme
                            Write-Host "Adding Language Version"
                            Write-Host $version "Version"
                            Add-ItemVersion -Path $FormRepositoryPath -TargetLanguage $version -Language "en" -Recurse -IfExist Skip

                            #set Layout to main
                            $RentPermanentSpacePage = "master:/sitecore/content/Klepierre/$regionName/$MallName/Home/Forms Repository/Rent Permanent Space Page"
                            # ajout version
                            Add-ItemVersion -Path $RentPermanentSpacePage -TargetLanguage $version -Language "en" -Recurse -IfExist Skip

                            $RentPermanentSpacePage_item = Get-Item -Path $RentPermanentSpacePage -Language $version
                            $RentPermanentSpacePage_device = Get-LayoutDevice -Default
                            $RentPermanentSpacePage_layout = Get-Item -Path 'master:/sitecore/layout/Layouts/Project/Kortex/Main'
                            Set-Layout -Item $RentPermanentSpacePage_item -Device $RentPermanentSpacePage_device -Layout $RentPermanentSpacePage_layout | Out-Null

                            $RentTemporarySpacePage = "master:/sitecore/content/Klepierre/$regionName/$MallName/Home/Forms Repository/Rent Temporary Space Page"
                            Add-ItemVersion -Path $RentTemporarySpacePage -TargetLanguage $version -Language "en" -Recurse -IfExist Skip
                            $RentTemporarySpacePage_item = Get-Item -Path $RentTemporarySpacePage -Language $version
                            $RentTemporarySpacePage_device = Get-LayoutDevice -Default
                            $RentTemporarySpacePage_layout = Get-Item -Path 'master:/sitecore/layout/Layouts/Project/Kortex/Main'
                            Set-Layout -Item $RentTemporarySpacePage_item -Device $RentTemporarySpacePage_device -Layout $RentTemporarySpacePage_layout | Out-Null

                            $ContactFormsPage = "master:/sitecore/content/Klepierre/$regionName/$MallName/Home/Forms Repository/Contact Forms Page"
                            Add-ItemVersion -Path $ContactFormsPage -TargetLanguage $version -Language "en" -Recurse -IfExist Skip
                            $ContactFormsPage_item = Get-Item -Path $ContactFormsPage -Language $version
                            $ContactFormsPage_device = Get-LayoutDevice -Default
                            $ContactFormsPage_layout = Get-Item -Path 'master:/sitecore/layout/Layouts/Project/Kortex/Main'
                            Set-Layout -Item $ContactFormsPage_item -Device $ContactFormsPage_device -Layout $ContactFormsPage_layout | Out-Null
                            Write-Host "Adding Language Version - Done" -ForegroundColor Green
                        }
                        
                        #FORMS
                        $MallContainer = "$Container/$MallName"
                        #contact page
                        if (!(Test-Path -Path $MallContainer -ErrorAction SilentlyContinue)) {
                            Write-Host "Creating Contact Page Page for $MallName - Start"
                           
                            New-Item -Path $MallContainer -ItemType "{A87A00B1-E6DB-45AB-8B54-636FEC3B5523}" | Out-Null
                            Copy-Item -Path "master:/sitecore/Forms/Contact Page" -Destination "$MallContainer/Contact Page" -Recurse
                            # Rename-Item -Path "$MallContainer/Contact Page" -NewName "$MallName Contact Page"
                            Write-Host "Creating Contact Page Page for $MallName - Done" -ForegroundColor Green
                            #rent a local
                            Write-Host "Creating Rent a Local Page for $MallName - Start"
                            Copy-Item -Path "master:/sitecore/Forms/Rent A Local" -Destination "$MallContainer/Rent A Local" -Recurse
                            # Rename-Item -Path "$MallContainer/Rent A Local" -NewName "$MallName Rent A Local"
                            Write-Host "Creating Rent a Local Page for $MallName - Done" -ForegroundColor Green
                            Write-Host "Adding Language Version"
                            # Write-Host $version "Version"
                            Add-ItemVersion -Path $MallContainer -TargetLanguage $version -Language "en" -Recurse -IfExist Skip
                            Write-Host "Adding Lnaguage Version - Done" -ForegroundColor Green
                        }
                        # debut creation et setting presentation
                        $PresentationPath = "master:/sitecore/content/Klepierre/$regionName/$MallName/Presentation"
                        $AlphaPresentation = "master:/sitecore/content/Klepierre/Master Region/Alpha/Presentation"
                        if ((Test-Path -Path $PresentationPath -ErrorAction SilentlyContinue)) {
                            # New-Item -Path $PresentationPath -ItemType "{0A70FA73-8923-4A6E-ABF3-4134F25F3221}"  | Out-Null
                         
                            Write-Host "Page Design and Sub Items Creation for $MallName - Starting"
                            if (!(Test-Path -Path "$PresentationPath/Page Designs" -ErrorAction SilentlyContinue)) {
                                Copy-Item -Path "$AlphaPresentation/Page Designs" -Destination $PresentationPath
                            }
                            
                            Copy-Item -Path "$AlphaPresentation/Page Designs/Contact Pages" -Destination "$PresentationPath/Page Designs/Contact Pages"
                            Rename-Item -Path "$PresentationPath/Page Designs/Contact Pages" -NewName "$MallName Contact Pages"
                            Copy-Item -Path "$AlphaPresentation/Page Designs/Rent a Local" -Destination "$PresentationPath/Page Designs/Rent a Local"
                            Rename-Item -Path "$PresentationPath/Page Designs/Rent a Local" -NewName "$MallName Rent a Local"
                            Write-Host "Page Design and Sub Items Creation - Done" -ForegroundColor Green

                            Write-Host $version "Version"
                            Add-ItemVersion -Path "$PresentationPath/Page Designs" -TargetLanguage $version -Language "en" -IfExist Skip
                            Add-ItemVersion -Path "$PresentationPath/Page Designs/$MallName Contact Pages" -TargetLanguage $version -Language "en" -IfExist Skip
                            Add-ItemVersion -Path "$PresentationPath/Page Designs/$MallName Rent a Local" -TargetLanguage $version -Language "en" -IfExist Skip
                            Write-Host "Adding Lnaguage Version - Done" -ForegroundColor Green

                   

                            Write-Host "Partial Design and Sub Items Creation - Starting"
                            if (!(Test-Path -Path "$PresentationPath/Partial Designs" -ErrorAction SilentlyContinue)) {
                                Copy-Item -Path "$AlphaPresentation/Partial Designs" -Destination $PresentationPath
                            }
                            
                            New-Item -Path "$PresentationPath/Partial Designs/Forms" -ItemType "{25AF5AB2-CF8A-4DE3-9B3C-DC0A4434032C}" | Out-Null
                            Copy-Item -Path "$AlphaPresentation/Partial Designs/Contact Pages/Contact Page" -Destination "$PresentationPath/Partial Designs/Forms"
                            Copy-Item -Path "$AlphaPresentation/Partial Designs/Rent a Local/Rent a Local" -Destination "$PresentationPath/Partial Designs/Forms"
                            Write-Host "Partial Design and Sub Items Creation for $MallName - Done" -ForegroundColor Green

                            Write-Host "Adding Language Version"
                            Add-ItemVersion -Path "$PresentationPath/Partial Designs" -TargetLanguage $version -Language "en" -Recurse -IfExist Skip
                            Add-ItemVersion -Path "$PresentationPath/Partial Designs/Forms" -TargetLanguage $version -Language "en" -Recurse -IfExist Skip
                            Write-Host "Adding Lnaguage Version - Done" -ForegroundColor Green

                            #Contact Page
                            Write-Host "Setting DataSource for Contact Pages - Starting"
                            $contact_Page = "master:/sitecore/content/Klepierre/$RegionName/$MallName/Presentation/Partial Designs/Forms/Contact Page"
                            $contact_Page_item = if (Test-Path -Path $contact_Page -ErrorAction SilentlyContinue) { Get-Item -Path $contact_Page -Language $version }else { Write-Error "Cannot find $contact_Page " }
                            
                            $ContactForms = "master:/sitecore/content/Klepierre/Master Region/Alpha/Presentation/Partial Designs/Contact Pages/Contact Page"
                            $rendererItem = if (Test-Path -Path $ContactForms -ErrorAction SilentlyContinue) { Get-Item -Path $ContactForms } else { Write-Error "Cannot find $ContactForms " }
                            
                            $contact_Page_rendering = Get-Rendering -Item $rendererItem -Device (Get-LayoutDevice "Default") -FinalLayout
                            $forms = Get-Item "master:/sitecore/Forms/$regionName/$MallName/Contact Page"
                            $formsID = $forms.ID

                            $contact_Page_rendering | Foreach {
                                if ($_.Name -eq "ContactForms") {
                                    Set-Rendering -Item $contact_Page_item -Instance $_ -DataSource $formsID.ToString() -FinalLayout -Language $version
                                }
                                else {
                                    Set-Rendering -Item $contact_Page_item -Instance $_ -FinalLayout -Language $version
                                }
                            }
                            Write-Host "Setting DataSource for Contact Pages - Done" -ForegroundColor Green

                            #Rent A Local
                            Write-Host "Setting DataSource for Rent a Local - Starting"
                            $Rent_a_local = "master:/sitecore/content/Klepierre/$regionName/$MallName/Presentation/Partial Designs/Forms/Rent a Local"
                            $item = if (Test-Path -Path $Rent_a_local -ErrorAction SilentlyContinue) { Get-Item -Path $Rent_a_local -Language $version }else { Write-Error "Cannot find $Rent_a_local " }
                            $RentLocalForms = "master:/sitecore/content/Klepierre/Master Region/Alpha/Presentation/Partial Designs/Rent a Local/Rent a Local"
                            $rendererItem = if (Test-Path -Path $RentLocalForms -ErrorAction SilentlyContinue) { Get-Item -Path $RentLocalForms } else { Write-Error "Cannot find $RentLocalForms " }
                            $rendering = Get-Rendering -Item $rendererItem -Device (Get-LayoutDevice "Default") -FinalLayout
                            $formsRAL = Get-Item "master:/sitecore/Forms/$regionName/$MallName/Rent A Local"
                            $formsRALID = $formsRAL.ID

                            $rendering | Foreach {
                                if ($_.Name -eq "RentLocalForms") {
                                    Set-Rendering -Item $item -Instance $_ -DataSource $formsRALID.ToString() -FinalLayout -Language $version
                                }
                                else {

                                    Set-Rendering -Item $item -Instance $_ -FinalLayout -Language $version
                                }
                            }

                            Write-Host "Setting DataSource for Rent a Local - Done" -ForegroundColor Green

                            #page Design Contact Page
                            Write-Host "Setting Page Design for Contact Pages - Starting"
                            $ContactPageItem = Get-Item -Path "master:/sitecore/content/Klepierre/$RegionName/$MallName/Presentation/Partial Designs/Forms/Contact Page" -Language $version
                            $cpID = $ContactPageItem.ID
                            $partialDesignContactPage = Get-Item -Path "master:/sitecore/content/Klepierre/$RegionName/$MallName/Presentation/Page Designs/$MallName Contact Pages" -Language $version
                            $partialDesignContactPage.Editing.BeginEdit() | Out-Null
                            $partialDesignContactPage['PartialDesigns'] = "{4B6B79E3-D9BC-45C1-9E2E-2C3AC6AB5D95}|{29407F75-D721-4D37-8679-7F98773858C8}|$cpID"
                            $partialDesignContactPage.Editing.EndEdit() | Out-Null
                            Write-Host "Setting Page Design for Contact Pages - Done" -ForegroundColor Green

                            #page Design Rent a Local
                            Write-Host "Setting Page Design for Rent a Local - Starting"
                            $RentALocalItem = Get-Item -Path "master:/sitecore/content/Klepierre/$RegionName/$MallName/Presentation/Partial Designs/Forms/Rent a Local" -Language $version
                            $RALID = $RentALocalItem.ID
                            $PartialDesignRentALocal = Get-Item -Path  "master:/sitecore/content/Klepierre/$RegionName/$MallName/Presentation/Page Designs/$MallName Rent a Local" -Language $version
                            $PartialDesignRentALocal.Editing.BeginEdit() | Out-Null
                            $PartialDesignRentALocal['PartialDesigns'] = "{4B6B79E3-D9BC-45C1-9E2E-2C3AC6AB5D95}|{29407F75-D721-4D37-8679-7F98773858C8}|$RALID"
                            $PartialDesignRentALocal.Editing.EndEdit() | Out-Null
                            Write-Host "Setting Page Design for Rent a Local - Done" -ForegroundColor Green

                            #setting partial design for Forms Repository

                            $MallContactPage = "master:/sitecore/content/Klepierre/$RegionName/$MallName/Presentation/Page Designs/$MallName Contact Pages"
                            $MallRentALocalPage = "master:/sitecore/content/Klepierre/$RegionName/$MallName/Presentation/Page Designs/$MallName Rent a Local"

                            $ContactPageItem = Get-Item -Path $MallContactPage -Language $version
                            $RentLocalItem = Get-Item -Path $MallRentALocalPage -Language $version

                            $FrContactFormsPage = "master:/sitecore/content/Klepierre/$RegionName/$MallName/Home/Forms Repository/Contact Forms Page"
                            $cfpItem = Get-Item -Path $FrContactFormsPage -Language $version
                            $cfpItem.Editing.BeginEdit() | Out-Null
                            $cfpItem["Page Design"] = $ContactPageItem.ID
                            $cfpItem.Editing.EndEdit() | Out-Null
                            $FrRentPS = "master:/sitecore/content/Klepierre/$RegionName/$MallName/Home/Forms Repository/Rent Permanent Space Page"
                            $RPSItem = Get-Item -Path $FrRentPS -Language $version
                            $RPSItem.Editing.BeginEdit() | Out-Null
                            $RPSItem["Page Design"] = $RentLocalItem.ID
                            $RPSItem.Editing.EndEdit() | Out-Null
                            $FRREntTS = "master:/sitecore/content/Klepierre/$RegionName/$MallName/Home/Forms Repository/Rent Temporary Space Page"
                            $RTSItem = Get-Item -Path $FRREntTS -Language $version
                            $RTSItem.Editing.BeginEdit() | Out-Null
                            $RTSItem["Page Design"] = $RentLocalItem.ID
                            $RTSItem.Editing.EndEdit() | Out-Null

                            $cpPath = "master:/sitecore/content/Klepierre/$RegionName/$MallName/Presentation/Partial Designs/Forms/Contact Page"
                            $cpItem = Get-Item -Path $cpPath -Language $version
                            $cpItem.Editing.BeginEdit() | Out-Null
                            $FinalValue = $cpItem["__Final Renderings"]
                            $cpItem["__Renderings"] = $FinalValue -replace ("ds=`"`"", "ds=`"$formsID`"")
                            $cpItem["__Final Renderings"] = $FinalValue -replace ("ds=`"`"", "ds=`"$formsID`"")
                            $cpItem.Editing.EndEdit() | Out-Null
                    
                            #set Layout
                            $contactItem = Get-Item -Path "master:/sitecore/content/Klepierre/$RegionName/$MallName/Presentation/Partial Designs/Forms/Contact Page"
                            $Rent_a_local_device = Get-LayoutDevice -Default
                            $Rent_a_local_layout = Get-Item -Path '/sitecore/layout/Layouts/Project/Kortex/Main'
                            Set-Layout -Item $contactItem -Device $Rent_a_local_device -Layout $Rent_a_local_layout | Out-Null

                            $RentItem = Get-Item -Path "master:/sitecore/content/Klepierre/$RegionName/$MallName/Presentation/Partial Designs/Forms/Rent a Local"
                            $Rent_device = Get-LayoutDevice -Default
                            $Rent_layout = Get-Item -Path '/sitecore/layout/Layouts/Project/Kortex/Main'
                            Set-Layout -Item $RentItem -Device $Rent_device -Layout $Rent_layout | Out-Null

                            #update footer links
                            Write-Host "Update Footer Links - Start"
                            $TeporaryLocal = Get-Item -Path "master:/sitecore/content/Klepierre/$RegionName/$MallName/Home/Navigation Container/Footer Repository/Contact/Louer un emplacement temporaire" -Language $version
                            $PermanentLocal = Get-Item -Path "master:/sitecore/content/Klepierre/$RegionName/$MallName/Home/Navigation Container/Footer Repository/Contact/Louer un local" -Language $version
                            $ContactUs = Get-Item -Path "master:/sitecore/content/Klepierre/$RegionName/$MallName/Home/Navigation Container/Footer Repository/Contact/Nous Contacter" -Language $version

                            $ContactFormsPage = Get-Item -Path "master:/sitecore/content/Klepierre/$RegionName/$MallName/Home/Forms Repository/Contact Forms Page" -Language $version
                            $TeporaryLocalPage = Get-Item -Path "master:/sitecore/content/Klepierre/$RegionName/$MallName/Home/Forms Repository/Rent Temporary Space Page" -Language $version
                            $PermanentLocalPage = Get-Item -Path "master:/sitecore/content/Klepierre/$RegionName/$MallName/Home/Forms Repository/Rent Permanent Space Page" -Language $version

                            $ContactId = $ContactFormsPage.ID
                            $TempId = $TeporaryLocalPage.ID
                            $PermanentID = $PermanentLocalPage.ID

                            Write-Host "Contact page" -ForegroundColor Yellow
                            $ContactUs.Editing.BeginEdit() | Out-Null
                            $ContactUs["Link"] = "<link text=`"`" anchor=`"`" linktype=`"internal`" class=`"`" title=`"`"  querystring=`"`" id=`"$ContactId`" />"
                            $ContactUs.Editing.EndEdit() | Out-Null

                            Write-Host "Temporary Local page" -ForegroundColor Yellow
                            $TeporaryLocal.Editing.BeginEdit() | Out-Null
                            $TeporaryLocal["Link"] = "<link text=`"`" anchor=`"`" linktype=`"internal`" class=`"`" title=`"`"  querystring=`"`" id=`"$TempId`" />"
                            $TeporaryLocal.Editing.EndEdit() | Out-Null

                            Write-Host "Permanent Local page" -ForegroundColor Yellow
                            $PermanentLocal.Editing.BeginEdit() | Out-Null
                            $PermanentLocal["Link"] = "<link text=`"`" anchor=`"`" linktype=`"internal`" class=`"`" title=`"`"  querystring=`"`" id=`"$PermanentID`" />"
                            $PermanentLocal.Editing.EndEdit() | Out-Null
                            Write-Host "Update Footer Links - Updated" -ForegroundColor Green


                        }
                        else {
                            Write-Host "Presentation Item Creation for $MallName - Starting"
                            New-Item -Path $PresentationPath -ItemType "{0A70FA73-8923-4A6E-ABF3-4134F25F3221}" | Out-Null
                            Write-Host "Done"

                            Write-Host "Page Design and Sub Items Creation for $MallName - Starting"
                            if (!(Test-Path -Path "$PresentationPath/Page Designs" -ErrorAction SilentlyContinue)) {
                                Copy-Item -Path "$AlphaPresentation/Page Designs" -Destination $PresentationPath
                            }
                            
                            Copy-Item -Path "$AlphaPresentation/Page Designs/Contact Pages" -Destination "$PresentationPath/Page Designs/Contact Pages"
                            Rename-Item -Path "$PresentationPath/Page Designs/Contact Pages" -NewName "$MallName Contact Pages"
                            Copy-Item -Path "$AlphaPresentation/Page Designs/Rent a Local" -Destination "$PresentationPath/Page Designs/Rent a Local"
                            Rename-Item -Path "$PresentationPath/Page Designs/Rent a Local" -NewName "$MallName Rent a Local"
                            Write-Host "Page Design and Sub Items Creation - Done" -ForegroundColor Green

                            Write-Host $version "Version"
                            Add-ItemVersion -Path "$PresentationPath/Page Designs" -TargetLanguage $version -Language "en" -IfExist Skip
                            Add-ItemVersion -Path "$PresentationPath/Page Designs/$MallName Contact Pages" -TargetLanguage $version -Language "en" -IfExist Skip
                            Add-ItemVersion -Path "$PresentationPath/Page Designs/$MallName Rent a Local" -TargetLanguage $version -Language "en" -IfExist Skip
                            Write-Host "Adding Lnaguage Version - Done" -ForegroundColor Green

                   

                            Write-Host "Partial Design and Sub Items Creation - Starting"
                            if (!(Test-Path -Path "$PresentationPath/Partial Designs" -ErrorAction SilentlyContinue)) {
                                Copy-Item -Path "$AlphaPresentation/Partial Designs" -Destination $PresentationPath
                            }
                            
                            New-Item -Path "$PresentationPath/Partial Designs/Forms" -ItemType "{25AF5AB2-CF8A-4DE3-9B3C-DC0A4434032C}" | Out-Null
                            Copy-Item -Path "$AlphaPresentation/Partial Designs/Contact Pages/Contact Page" -Destination "$PresentationPath/Partial Designs/Forms"
                            Copy-Item -Path "$AlphaPresentation/Partial Designs/Rent a Local/Rent a Local" -Destination "$PresentationPath/Partial Designs/Forms"
                            Write-Host "Partial Design and Sub Items Creation for $MallName - Done" -ForegroundColor Green

                            Write-Host "Adding Language Version"
                            Add-ItemVersion -Path "$PresentationPath/Partial Designs" -TargetLanguage $version -Language "en" -Recurse -IfExist Skip
                            Add-ItemVersion -Path "$PresentationPath/Partial Designs/Forms" -TargetLanguage $version -Language "en" -Recurse -IfExist Skip
                            Write-Host "Adding Lnaguage Version - Done" -ForegroundColor Green

                            #Contact Page
                            Write-Host "Setting DataSource for Contact Pages - Starting"
                            $contact_Page = "master:/sitecore/content/Klepierre/$RegionName/$MallName/Presentation/Partial Designs/Forms/Contact Page"
                            $contact_Page_item = if (Test-Path -Path $contact_Page -ErrorAction SilentlyContinue) { Get-Item -Path $contact_Page -Language $version }else { Write-Error "Cannot find $contact_Page " }
                            $ContactForms = "master:/sitecore/content/Klepierre/Master Region/Alpha/Presentation/Partial Designs/Contact Pages/Contact Page"
                            $rendererItem = if (Test-Path -Path $ContactForms -ErrorAction SilentlyContinue) { Get-Item -Path $ContactForms } else { Write-Error "Cannot find $ContactForms " }
                            $contact_Page_rendering = Get-Rendering -Item $rendererItem -Device (Get-LayoutDevice "Default") -FinalLayout
                            $forms = Get-Item "master:/sitecore/Forms/$regionName/$MallName/Contact Page"
                            $formsID = $forms.ID
                            $contact_Page_rendering | Foreach {
                                if ($_.Name -eq "ContactForms") {
                                    Set-Rendering -Item $contact_Page_item -Instance $_ -DataSource $formsID.ToString() -FinalLayout -Language $version
                                }
                                else {
                                    Set-Rendering -Item $contact_Page_item -Instance $_ -FinalLayout -Language $version
                                }
                            }
                            Write-Host "Setting DataSource for Contact Pages - Done" -ForegroundColor Green

                            #Rent A Local
                            Write-Host "Setting DataSource for Rent a Local - Starting"
                            $Rent_a_local = "master:/sitecore/content/Klepierre/$regionName/$MallName/Presentation/Partial Designs/Forms/Rent a Local"
                            $item = if (Test-Path -Path $Rent_a_local -ErrorAction SilentlyContinue) { Get-Item -Path $Rent_a_local -Language $version }else { Write-Error "Cannot find $Rent_a_local " }
                            $RentLocalForms = "master:/sitecore/content/Klepierre/Master Region/Alpha/Presentation/Partial Designs/Rent a Local/Rent a Local"
                            $rendererItem = if (Test-Path -Path $RentLocalForms -ErrorAction SilentlyContinue) { Get-Item -Path $RentLocalForms } else { Write-Error "Cannot find $RentLocalForms " }
                            $rendering = Get-Rendering -Item $rendererItem -Device (Get-LayoutDevice "Default") -FinalLayout
                            $formsRAL = Get-Item "master:/sitecore/Forms/$regionName/$MallName/Rent A Local"
                            $formsRALID = $formsRAL.ID

                            $rendering | Foreach {
                                if ($_.Name -eq "RentLocalForms") {
                                    Set-Rendering -Item $item -Instance $_ -DataSource $formsRALID.ToString() -FinalLayout -Language $version
                                }
                                else {

                                    Set-Rendering -Item $item -Instance $_ -FinalLayout -Language $version
                                }
                            }

                            Write-Host "Setting DataSource for Rent a Local - Done" -ForegroundColor Green

                            #page Design Contact Page
                            Write-Host "Setting Page Design for Contact Pages - Starting"
                            $ContactPageItem = Get-Item -Path "master:/sitecore/content/Klepierre/$RegionName/$MallName/Presentation/Partial Designs/Forms/Contact Page" -Language $version
                            $cpID = $ContactPageItem.ID
                            $partialDesignContactPage = Get-Item -Path "master:/sitecore/content/Klepierre/$RegionName/$MallName/Presentation/Page Designs/$MallName Contact Pages" -Language $version
                            $partialDesignContactPage.Editing.BeginEdit() | Out-Null
                            $partialDesignContactPage['PartialDesigns'] = "{4B6B79E3-D9BC-45C1-9E2E-2C3AC6AB5D95}|{29407F75-D721-4D37-8679-7F98773858C8}|$cpID"
                            $partialDesignContactPage.Editing.EndEdit() | Out-Null
                            Write-Host "Setting Page Design for Contact Pages - Done" -ForegroundColor Green

                            #page Design Rent a Local
                            Write-Host "Setting Page Design for Rent a Local - Starting"
                            $RentALocalItem = Get-Item -Path "master:/sitecore/content/Klepierre/$RegionName/$MallName/Presentation/Partial Designs/Forms/Rent a Local" -Language $version
                            $RALID = $RentALocalItem.ID
                            $PartialDesignRentALocal = Get-Item -Path  "master:/sitecore/content/Klepierre/$RegionName/$MallName/Presentation/Page Designs/$MallName Rent a Local" -Language $version
                            $PartialDesignRentALocal.Editing.BeginEdit() | Out-Null
                            $PartialDesignRentALocal['PartialDesigns'] = "{4B6B79E3-D9BC-45C1-9E2E-2C3AC6AB5D95}|{29407F75-D721-4D37-8679-7F98773858C8}|$RALID"
                            $PartialDesignRentALocal.Editing.EndEdit() | Out-Null
                            Write-Host "Setting Page Design for Rent a Local - Done" -ForegroundColor Green

                            #setting partial design for Forms Repository

                            $MallContactPage = "master:/sitecore/content/Klepierre/$RegionName/$MallName/Presentation/Page Designs/$MallName Contact Pages"
                            $MallRentALocalPage = "master:/sitecore/content/Klepierre/$RegionName/$MallName/Presentation/Page Designs/$MallName Rent a Local"

                            $ContactPageItem = Get-Item -Path $MallContactPage -Language $version
                            $RentLocalItem = Get-Item -Path $MallRentALocalPage -Language $version

                            $FrContactFormsPage = "master:/sitecore/content/Klepierre/$RegionName/$MallName/Home/Forms Repository/Contact Forms Page"
                            $cfpItem = Get-Item -Path $FrContactFormsPage -Language $version
                            $cfpItem.Editing.BeginEdit()
                            $cfpItem["Page Design"] = $ContactPageItem.ID
                            $cfpItem.Editing.EndEdit()
                            $FrRentPS = "master:/sitecore/content/Klepierre/$RegionName/$MallName/Home/Forms Repository/Rent Permanent Space Page"
                            $RPSItem = Get-Item -Path $FrRentPS -Language $version
                            $RPSItem.Editing.BeginEdit()
                            $RPSItem["Page Design"] = $RentLocalItem.ID
                            $RPSItem.Editing.EndEdit()
                            $FRREntTS = "master:/sitecore/content/Klepierre/$RegionName/$MallName/Home/Forms Repository/Rent Temporary Space Page"
                            $RTSItem = Get-Item -Path $FRREntTS -Language $version
                            $RTSItem.Editing.BeginEdit()
                            $RTSItem["Page Design"] = $RentLocalItem.ID
                            $RTSItem.Editing.EndEdit()

                            $cpPath = "master:/sitecore/content/Klepierre/$RegionName/$MallName/Presentation/Partial Designs/Forms/Contact Page"
                            $cpItem = Get-Item -Path $cpPath -Language $version
                            $cpItem.Editing.BeginEdit() | Out-Null
                            $FinalValue = $cpItem["__Final Renderings"]
                            $cpItem["__Renderings"] = $FinalValue -replace ("ds=`"`"", "ds=`"$formsID`"")
                            $cpItem["__Final Renderings"] = $FinalValue -replace ("ds=`"`"", "ds=`"$formsID`"")
                            $cpItem.Editing.EndEdit() | Out-Null
                    
                            #set Layout
                            $contactItem = Get-Item -Path "master:/sitecore/content/Klepierre/$RegionName/$MallName/Presentation/Partial Designs/Forms/Contact Page"
                            $Rent_a_local_device = Get-LayoutDevice -Default
                            $Rent_a_local_layout = Get-Item -Path '/sitecore/layout/Layouts/Project/Kortex/Main'
                            Set-Layout -Item $contactItem -Device $Rent_a_local_device -Layout $Rent_a_local_layout | Out-Null

                            $RentItem = Get-Item -Path "master:/sitecore/content/Klepierre/$RegionName/$MallName/Presentation/Partial Designs/Forms/Rent a Local"
                            $Rent_device = Get-LayoutDevice -Default
                            $Rent_layout = Get-Item -Path '/sitecore/layout/Layouts/Project/Kortex/Main'
                            Set-Layout -Item $RentItem -Device $Rent_device -Layout $Rent_layout | Out-Null

                            #update footer links
                            Write-Host "Update Footer Links - Start"
                            $TeporaryLocal = Get-Item -Path "master:/sitecore/content/Klepierre/$RegionName/$MallName/Home/Navigation Container/Footer Repository/Contact/Louer un emplacement temporaire" -Language $version
                            $PermanentLocal = Get-Item -Path "master:/sitecore/content/Klepierre/$RegionName/$MallName/Home/Navigation Container/Footer Repository/Contact/Louer un local" -Language $version
                            $ContactUs = Get-Item -Path "master:/sitecore/content/Klepierre/$RegionName/$MallName/Home/Navigation Container/Footer Repository/Contact/Nous Contacter" -Language $version

                            $ContactFormsPage = Get-Item -Path "master:/sitecore/content/Klepierre/$RegionName/$MallName/Home/Forms Repository/Contact Forms Page" -Language $version
                            $TeporaryLocalPage = Get-Item -Path "master:/sitecore/content/Klepierre/$RegionName/$MallName/Home/Forms Repository/Rent Temporary Space Page" -Language $version
                            $PermanentLocalPage = Get-Item -Path "master:/sitecore/content/Klepierre/$RegionName/$MallName/Home/Forms Repository/Rent Permanent Space Page" -Language $version

                            $ContactId = $ContactFormsPage.ID
                            $TempId = $TeporaryLocalPage.ID
                            $PermanentID = $PermanentLocalPage.ID

                            Write-Host "Contact page" -ForegroundColor Yellow
                            $ContactUs.Editing.BeginEdit() | Out-Null
                            $ContactUs["Link"] = "<link text=`"`" anchor=`"`" linktype=`"internal`" class=`"`" title=`"`"  querystring=`"`" id=`"$ContactId`" />"
                            $ContactUs.Editing.EndEdit() | Out-Null

                            Write-Host "Temporary Local page" -ForegroundColor Yellow
                            $TeporaryLocal.Editing.BeginEdit() | Out-Null
                            $TeporaryLocal["Link"] = "<link text=`"`" anchor=`"`" linktype=`"internal`" class=`"`" title=`"`"  querystring=`"`" id=`"$TempId`" />"
                            $TeporaryLocal.Editing.EndEdit() | Out-Null

                            Write-Host "Permanent Local page" -ForegroundColor Yellow
                            $PermanentLocal.Editing.BeginEdit() | Out-Null
                            $PermanentLocal["Link"] = "<link text=`"`" anchor=`"`" linktype=`"internal`" class=`"`" title=`"`"  querystring=`"`" id=`"$PermanentID`" />"
                            $PermanentLocal.Editing.EndEdit() | Out-Null
                            Write-Host "Update Footer Links - Updated" -ForegroundColor Green

                        }
                    }
                }
            }
            else {
                Write-Information "$regionName skiped"
            }
        }
    } 
    end {
        Write-Host "All Steps are Done " -BackgroundColor Green -ForegroundColor white
    }
}

Forms-Creation