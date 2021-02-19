function Utils-Remove-Diacritics {
  [CmdletBinding()]
  param(
    [Parameter(Mandatory = $true, Position = 0 )]
    [String]$text
  )

  process {
    $alphabet = @{
      #    " "="-";
      ";" = "";
      "а" = "a";
      "б" = "b";
      "в" = "v";
      "г" = "g";
      "д" = "d";
      "е" = "e";
      "ё" = "yo";
      "ж" = "zh";
      "з" = "z";
      "и" = "i";
      "й" = "y";
      "к" = "k";
      "л" = "l";
      "м" = "m";
      "н" = "n";
      "о" = "o";
      "п" = "p";
      "р" = "r";
      "с" = "s";
      "т" = "t";
      "у" = "u";
      "ф" = "f";
      "х" = "h";
      "ц" = "c";
      "ч" = "ch";
      "ш" = "sh";
      "щ" = "shch";
      "ъ" = "y";
      "ы" = "y";
      "ь" = "-";
      "э" = "e";
      "ю" = "ju";
      "я" = "ja";
      "." = "-";
      "&"="-";
      "á" = "a"; 
      "à" = "a"; 
      "â" = "a"; 
      "ä" = "a"; 
      "å" = "a"; 
      "ã" = "a"; 
      "æ" = "ae"; 
      "ç" = "c"; 	
      "é" = "e"; 
      "è" = "e"; 
      "ê" = "e"; 
      "ë" = "e"; 	
      "í" = "i"; 
      "ì" = "i"; 
      "î" = "i"; 
      "ï" = "i"; 	
      "ñ" = "n"; 
      "ó" = "o"; 
      "ò" = "o"; 
      "ô" = "o"; 
      "ö" = "o"; 
      "õ" = "o"; 
      "ø" = "o"; 
      "œ" = "oe"; 	
      "š" = "s"; 	
      "ú" = "u"; 
      "ù" = "u"; 
      "û" = "u"; 
      "ü" = "u"; 	
      "ý" = "y"; 
      "ÿ" = "y"; 	
      "ž" = "z"; 
      "ð" = "e"; 
      "þ" = "t"; 
      "ß" = "s";
    }
    
    $akeys = $alphabet.Keys
    $splitKeys = $akeys.Split(" ")
    $avalues = $alphabet.Values
    $splitValues = $avalues.Split(" ")
    $rawText = $text.Replace(" ", "-")
    $res = $rawText.Split("-")
    $result = ""
    
    for ($j = 0; $j -lt $res.Length; $j++) {
      $item = ([string]$res[$j]).ToCharArray()
      for ($i = 0; $i -lt $item.Length; $i++) {
        $index = [string]$item[$i]
        if ($item[$i] -match '^\d+$' -or $alphabet[$index.ToLower()] -eq $null) {
          $result += $index.ToLower();
        }
        else {
          $result += $alphabet[$index.ToLower()]
        }
      }
      if ($j -lt $res.Length - 1) {
        $result += "-"
      }
    }
    
    $result = $result -replace '[^a-zA-Z0-9-]', ''
    $result = $result -Replace "-+", "-"
    $result
  }
}

cls

$tab = @(
  "3 Butikken",
"Apair",
"Apotek",
"ARKET",
"Babysam",
"Bahne",
"Balletkompagniet",
"Bertoni",
"Bilka OneStop",
"Børne-Foto",
"Bog&idé",
"Bolia.com",
"Bonells Smykker & Ure",
"BR",
"Brdr. Simonsen Menswear",
"Bruun & Stengade",
"Calvin Klein",
"Carat Diamanter",
"Centerkiosken",
"Change",
"Deichmann",
"Ecco /v Skoringen",
"Elgiganten",
"Envii",
"Esprit",
"Flowershop",
"Flying Tiger Copenhagen",
"Fonefix",
"Foot Locker",
"Frellsen Chokolade",
"Friluftsland",
"GameStop",
"Gina Tricot",
"Glitter",
"G-Star",
"Guess",
"Heat & Vape by Smoke-It",
"Helsemin",
"H&M",
"H&M Home",
"H&M MEN",
"Hunkemöller",
"iExpert",
"Illums Bolighus",
"Imerco",
"Jack & Jones",
"JD Sports",
"Jumpyard",
"JYSK",
"Kaufmann",
"Kings and Queens",
"Kjærstrup Chokolade",
"Klinik A",
"Levis Store",
"Lindex",
"Magasin",
"Magasin Mad & Vin",
"Matas",
"Message",
"MONKI",
"Moss Copenhagen",
"Nails Gallery",
"Name It",
"Nespresso",
"Neye",
"Neye Pop-up Plan 1",
"Nike Shop",
"Nordisk Film Biografer",
"Normal",
"Ørestad Kiropraktik & Sundhed",
"Only",
"Orion",
"&Other Stories",
"Pandora",
"Panduro Hobby",
"Partyland",
"Pieces",
"Pilgrim",
"Poul M",
"ProfessioNAIL",
"Profil Optik",
"qUINT",
"Rituals",
"Sam's",
"Samsøe & Samsøe",
"SATS",
"Selected",
"Skechers",
"Skoringen",
"Søstrene Grene",
"SPORT24",
"Sportmaster",
"Synoptik",
"Tandlæge plus1",
"Telenor",
"Telia",
"The Body Shop",
"Thiele",
"Tiger Of Sweden",
"Tøjeksperten",
"Vero Moda",
"Victoria's Secret",
"YouSee",
"Zara",
"Zizzi"

)

foreach ($t in $tab) {
  $res = Utils-Remove-Diacritics $t
  $res
}


$shopRepository = "master:/sitecore/content/Klepierre/Denmark/FieldsEN/Home/Shop Repository"
$shopChildItems = Get-ChildItem -Path $shopRepository -Language "en" | Where { $_.TemplateID -eq "{80D19FA2-B1EF-4E32-93BD-4B2C650A126F}" -or $_.TemplateID -eq "{A496118C-D0EF-440D-8DF5-5DEFE47E662E}" }

foreach ($s in $shopChildItems) {
  $s
}