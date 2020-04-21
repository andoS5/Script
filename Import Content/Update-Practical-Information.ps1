function Import-Content-Practical-Information {
	begin { 
		Write-Host "Import Practical Information - Begin"
		import-function Utils-Upload-CSV-File
	}
	process {
		$praticalInfo = Utils-Upload-CSV-File -Title "Import Practical Info"
		$Region = $praticalInfo[0]."Region Name"
		$Mall = $praticalInfo[0]."Mall Name"
		$Mall = $Mall -Replace '[\W]', '-'
		$Language = $praticalInfo[0]."Version"
		$pathPracticalInfo = "master:/sitecore/content/Klepierre/$Region/$Mall/Home/Practical Information"
		$pathAccessRepo = $pathPracticalInfo + "/Access Repository"
		$pathAccessCar = $pathAccessRepo + "/car"
		$pathAccessPublicTransport = $pathAccessRepo + "/Public Transport"
		
		New-Item -Path $pathAccessCar -ItemType "{3BB963C9-FD3F-4C75-B3EC-933481337F45}" -Language $Language | Out-Null
		New-Item -Path $pathAccessPublicTransport -ItemType "{3BB963C9-FD3F-4C75-B3EC-933481337F45}" -Language $Language | Out-Null
		
		##Update Practical-Info
		$practicalInfoItem = Get-Item -Path $pathPracticalInfo -Language $Language
		$practicalInfoItem.Editing.BeginEdit()
		$practicalInfoItem["Breadcrumb title"] = $praticalInfo[0]."Breadcrumb title"
		$practicalInfoItem["Show on breadcrumb"] = "1"
		$practicalInfoItem["Page Design"] = "{A09ACC9D-483F-4C62-BD58-DB30174D1A36}"
		$practicalInfoItem["Banner Title"] = $praticalInfo[0]."Banner Title"
		$practicalInfoItem["SEO Paragraph"] = $praticalInfo[0]."SEO Paragraph"

		$practicalInfoItem["Background Image"] = '<image mediaid="{200EAF5E-49E1-4E9D-901A-0D5D02621130}" alt="Background Image" height="" width="" hspace="" vspace="" />'
		$practicalInfoItem["Mobile Image"] = '<image mediaid="{B0A0A417-41FA-4CEC-ABD9-C05495281364}" alt="Mobile Image" height="" width="" hspace="" vspace="" />'
		$practicalInfoItem["Tablet Image"] = '<image mediaid="{A8D4A475-1880-40C7-B827-07FAD42EDA8C}" alt="Tablet Image" height="" width="" hspace="" vspace="" />'
		$practicalInfoItem["Large Image"] = '<image mediaid="{18026B69-2071-4304-AAAC-BF6EF8E74FDB}" alt="Large Image" height="" width="" hspace="" vspace="" />'

		$practicalInfoItem.Editing.EndEdit() | Out-Null
		
		##update Access Repository
		#Car
		$carItem = Get-Item -Path $pathAccessCar -Language $Language
		$carItem.Editing.BeginEdit()
		$carItem["Title"] = "EN VOITURE"
		$carItem["Description"] = $praticalInfo[0]."Car"
		$carItem.Editing.EndEdit() | Out-Null
			
		#Public transport
		$publicTransportItem = Get-Item -Path $pathAccessPublicTransport -Language $Language
		$publicTransportItem.Editing.BeginEdit()
		$publicTransportItem["Title"] = "Public transport"
		$publicTransportItem["Description"] = $praticalInfo[0]."Public Transport"
		$publicTransportItem.Editing.EndEdit() | Out-Null
		
		##Update Opening hours Repository
		$pathOpenHourRepo = $pathPracticalInfo + "/Opening Hours Repository"
		foreach ($pi in $praticalInfo) {
				
			$pathDay = $pathOpenHourRepo + "/" + $pi.Day
			$dayItem = Get-Item -Path $pathDay -Language $Language
			$pathDayRepository = "master:/sitecore/content/Klepierre/Shared/Days Repository/" + $pi.Day
			$daysRepository = Get-Item -Path $pathDayRepository -Language "en"
			try {
				$dayItem.Editing.BeginEdit()
				$dayItem["Day"] = $daysRepository.ID
				$dayItem["Display Day"] = $pi."Display Day"
				$dayItem["Close"] = $pi.Close
				$dayItem["Opening Time"] = $pi."Opening Time"
				$dayItem["Closing Time"] = $pi."Closing Time"
				$dayItem.Editing.EndEdit() | Out-Null
			}
			catch {
				Write-Host "Faile for $pi.Day"
			}
		}
	}
	end {
		Write-Host "Practical Info has been updated"
	}
}
