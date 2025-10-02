function Remove-ZXHostGroup {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [array]$HostID,
        [Parameter(Mandatory=$false)]
        [array]$GroupID,
        [Parameter(Mandatory=$false)]
        [switch]$WhatIf
    )
    
    #Basic PS Object wich will be edited based on the used parameters and finally converted to json
    $PSObj  = New-ZXApiRequestObject -Method "hostgroup.massremove"
    
    #Add properties to the basic PS object based on the used parameters
    if($GroupID){
        $PSObj.params | Add-Member -MemberType NoteProperty -Name "groupids" -Value $GroupID
    }
    if($HostID){
        $PSObj.params | Add-Member -MemberType NoteProperty -Name "hostids" -Value $HostID
    }
    $Json = $PSObj | ConvertTo-Json -Depth 5 

    if($WhatIf){
        Write-JsonRequest
    }
            
    #Make the API call
    if (!$WhatIf){
        $Request = Invoke-RestMethod -Uri $ZXAPIUrl -Body $Json -ContentType "application/json" -Method Post
        Resolve-ZXApiResponse -Request $Request
    }   
}
