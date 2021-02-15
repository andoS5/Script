function dowloadImage {
    param(
        [Parameter(Mandatory)]
        [string]$ImgUrl,
        [Parameter(Mandatory)]
        [string]$OutPath,
        [Parameter(Mandatory)]
        [string]$folderName
    )

    process {
        
        $imageNameSplited = $ImgUrl.Split("/")
        $imageName = $imageNameSplited[$imageNameSplited.Count - 1]

        #Output
        $outputPath = "$OutPath/$folderName"
        if(!(Test-Path $outputPath -ErrorAction SilentlyContinue)){

            New-Item -ItemType Directory -Force -Path $outputPath

            $WebClient = New-Object System.Net.WebClient
            $WebClient.DownloadFile($ImgUrl,"$outputPath/$imageName")
        }else{
            
            $WebClient = New-Object System.Net.WebClient
            $WebClient.DownloadFile($ImgUrl,"$outputPath/$imageName")
        }

    }
}