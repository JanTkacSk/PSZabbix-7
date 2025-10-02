function Remove-ZXTriggerPrototype{
    param(
        [array]$TriggerID,
        [switch]$WhatIf
    )
   
    #Basic PS Object wich will be edited based on the used parameters and finally converted to json
    $PSObj = New-ZXApiRequestObject -Method "triggerprototype.delete"
    $PSObj.params = $TriggerID

    $Json = $PSObj | ConvertTo-Json -Depth 5

    #Show JSON Request if -Whatif switch is used
    If ($WhatIf){
        Write-JsonRequest
    }
    
    #Make the API call
    if(!$Whatif){
        $Request = Invoke-RestMethod -Uri $ZXAPIUrl -Body $Json -ContentType "application/json" -Method Post
        Resolve-ZXApiResponse -Request $Request
    }   
}


