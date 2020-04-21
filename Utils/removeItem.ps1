function removeItem {

    $myArray = @(
        "acessibilidade-de-pessoas-com-mobilidade-reduzida",
        "bomba-de-gasolina",
        "cadeira-de-rodas",
        "cadeiras-de-massagem",
        "cambios-e-transferencias",
        "carregamento-de-baterias",
        "carregamento-de-viaturas-eletricas",
        "carrinhos-de-passeio",
        "carrossel",
        "Cartao-Presente",
        "desfibrilhador",
        "diretorios",
        "emprestimo-de-power-banks",
        "enfermaria",
        "engraxadora-de-sapatos",
        "estacionamento-de-bicicletas",
        "estacionamento-de-motociclos",
        "estacionamento-reservado",
        "estacionamento-reservado-para-familias",
        "fraldarios",
        "imprensa-gratuita",
        "kit-primeiros-socorros",
        "kit-reparacao-de-bicicletas",
        "lavagem-de-automoveis",
        "lounge-e-seating-area",
        "maquinas-de-vending",
        "marco-de-correios",
        "minicars",
        "multibanco",
        "papapoint",
        "parque-de-estacionamento",
        "perdidos-e-achados",
        "quiosque-de-informacoes",
        "taxis",
        "telefone-publico",
        "wc",
        "wc-para-mobilidade-reduzida",
        "wifi"
    )

    foreach($myArrays in $myArray){

        $path = "master:/sitecore/content/Klepierre/Czech Republic/PlzenPlaza/Home/Services/$myArrays"

        if((Test-Path -Path $path -ErrorAction SilentlyContinue)){
            Write-Host "Removing $path "
            Remove-Item -Path $path -Permanently
            Write-Host "done" -ForegroundColor Green
        } 
    }
    
}
removeItem