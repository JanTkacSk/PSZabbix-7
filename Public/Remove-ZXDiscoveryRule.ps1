function Remove-ZXDiscoveryRule{
    param(
        [array]$LLDRuleID,
        [switch]$WhatIf
    )
   
    #Basic PS Object wich will be edited based on the used parameters and finally converted to json
    $PSObj = New-ZXApiRequestObject -Method "discoveryrule.delete"
    $PSObj.params = $LLDRuleID

    $ZXDiscoveryRule = Get-ZXDiscoveryRule -ItemID $LLDRuleID
    if($null -eq $ZXDiscoveryRule.itemid){
        Write-Host -ForegroundColor Yellow "[Not Found]" -NoNewline
        Write-Host " $LLDRule"
        Continue
    }

    $Json = $PSObj | ConvertTo-Json -Depth 5

    #Show JSON Request if -ShowJsonRequest switch is used
    If ($WhatIf){
        Write-JsonRequest
    }
    
    #Make the API call
    if(!$Whatif){
        $Request = Invoke-RestMethod -Uri $ZXAPIUrl -Body $Json -ContentType "application/json" -Method Post
        Resolve-ZXApiResponse -Request $Request
    }
   
}


