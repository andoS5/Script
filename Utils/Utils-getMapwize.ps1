function Utils-getMapwize($url){
        $mapwize = ""
        $HTTP_Request = [System.Net.WebRequest]::Create($url)
        $HTTP_Response = $HTTP_Request.GetResponse()
        $HTTP_Status = [int]$HTTP_Response.StatusCode
        if ($HTTP_Status -eq 200) {
            $HttpContent = Invoke-WebRequest -Uri $url -UseBasicParsing
            $Content= $HttpContent.Links 
            foreach($Contents in $Content){
                if($Contents.outerHTML.Contains("icon-pin")){
                    $rawID = $Contents.outerHTML
                    $begin = $rawID.indexOf("#")
                    $end = $rawID.indexOf("`" rel")
                    $mapwize = $rawID.Substring($begin+1,($end - $begin)-1)
                }
            }
        }
       return $mapwize
    }