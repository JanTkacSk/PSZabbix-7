function Update-ZXMaintenance {
    param(
        [array]$GroupID,
        [array]$HostIDReplace,
        [string]$MaintenanceID,
        [switch]$WhatIf
    )

    #Basic PS Object wich will be edited based on the used parameters and finally converted to json
    $PSObj = New-ZXApiRequestObject -Method "maintenance.update"

    if ($HostIDReplace){
        $HostIDObjects = ConvertArrayToObjects -PropertyName "hostid" -Array $HostIDReplace
        $PSObj.params | Add-Member -MemberType NoteProperty -Name "hosts" -Value @($HostIDObjects)
    }
    if ($GroupID){
        $PSObj.params | Add-Member -MemberType NoteProperty -Name "groupids" -Value $GroupID
    }
    if ($MaintenanceID){
        $PSObj.params | Add-Member -MemberType NoteProperty -Name "maintenanceid" -Value $MaintenanceID
    }

    $Json =  $PSObj | ConvertTo-Json -Depth 3

    if($WhatIf){
        Write-JsonRequest
    }
    
    #Make the API call
    if(!$WhatIf){
        $Request = Invoke-RestMethod -Uri $ZXAPIUrl -Body $Json -ContentType "application/json" -Method Post
        Resolve-ZXApiResponse -Request $Request
    }
}
