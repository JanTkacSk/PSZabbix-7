function Remove-ZXMaintenance{
    param(
        [array]$MaintenanceId,
        [switch]$WhatIf
    )
   
    #Basic PS Object wich will be edited based on the used parameters and finally converted to json
    $PSObj = New-ZXApiRequestObject -Method "maintenance.delete"
    $PSObj.params = $MaintenanceId

    $ZXMaintenance = Get-ZXMaintenance -MaintenanceID $MaintenanceId
    if($null -eq $ZXMaintenance){
        Write-Host -ForegroundColor Yellow "[Not Found]" -NoNewline
        Write-Host " $MaintenanceId"
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


