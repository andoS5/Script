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
      #","="-";
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