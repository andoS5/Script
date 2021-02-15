cls
$link ='<link text="Instagram" linktype="external" url="http://instagram.com/fieldsshopping" anchor="" target="_blank" />'

$reg = ((Select-String '(http[s]?)(:\/\/)([^\s,]+)(?=")' -Input $link).Matches.Value) 
$reg