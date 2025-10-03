function Stop-ZXSession {
    param(
        [string]$SessionID,
        [string]$ZXAPIUrl = $ZXAPIUrl,
        [switch]$WhatIf
    )

    if ($null -eq $ZXAPIUrl){
        $ZXAPIUrl = Read-Host -Prompt "Enter the zabbix API url:" 
    }

    if ($SessionID){     
        $Auth = $SessionID
    }
    else {
        $Auth = [Runtime.InteropServices.Marshal]::PtrToStringAuto([Runtime.InteropServices.Marshal]::SecureStringToBSTR(($ZXAPIToken)));
    }
    #Basic PS Object wich will be edited based on the used parameters and finally converted to json
    $PSObj = [PSCustomObject]@{
        "jsonrpc" = "2.0";
        "method" = "user.logout";
        "params" = @();
        "auth" = "$Auth"
        "id" = "1"

    }
    $JSON = $PSObj | ConvertTo-Json
    
    #Show JSON Request if -Whatif switch is used
    If ($WhatIf){
        Write-JsonRequest
    }

    if(!$WhatIf){
        $request = Invoke-RestMethod -Uri $ZXAPIUrl -Body $Json -ContentType "application/json" -Method Post
        Resolve-ZXApiResponse -Request $request
    }
}
