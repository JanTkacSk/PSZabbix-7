function Set-ZXHostStatus{
    param(
        [string]$HostName,
        [string]$HostId,
        [ValidateSet("0","1","Enabled","Disabled")]
        [Parameter(Mandatory=$true)]
        [string]$Status,
        [switch]$WhatIf
    )
    #Verify parameters
    if ($HostName -and $HostId){
        Write-Host -ForegroundColor Yellow 'Not allowed to use -HostName and -HostID parameters together'
        continue
    }
    
    #Basic PS Object wich will be edited based on the used parameters and finally converted to json
    $PSObj = New-ZXApiRequestObject -Method "host.update"
    $PSObj | Add-Member -MemberType NoteProperty -Name "hostid" -Value $HostId

    switch ($Status) {
        "Enabled" {$Status = "0"}
        "Disabled" {$Status = "1"}
    }

    if($Status){

        if($HostId){
            $ZXHost = Get-ZXHost -HostID $HostId -IncludeTags
            if($null -eq $ZXHost.hostid){
                Write-Host -ForegroundColor Yellow "[Not Found]" -NoNewline
                Write-Host " $HostId"
                $LogObject.HostsNotFound += $HostId
                Continue
            }

        }
        elseif ($HostName){
            $ZXHost = Get-ZXHost -Name $HostName -IncludeTags
            if($null -eq $ZXHost.host){
                Write-Host -ForegroundColor Yellow "[Not Found]" -NoNewline
                Write-Host " $HostName"
                $LogObject.HostsNotFound += $HostName
                Continue
            }

        }
        #Read the $ZXHost properties and use the values to fill in $PSobject properties. $PSobject is later converted to $json request
        $PSObj.params.hostid = $ZXHost.hostid
        $PSObj.params |  Add-Member -MemberType NoteProperty -Name "host" -Value $ZXHost.host
        $PSObj.params |  Add-Member -MemberType NoteProperty -Name "name" -Value $ZXHost.name
        $PSObj.params |  Add-Member -MemberType NoteProperty -Name "status" -Value $Status
    }
    
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


