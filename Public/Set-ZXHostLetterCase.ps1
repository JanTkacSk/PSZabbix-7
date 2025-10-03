function Set-ZXHostLetterCase{
    param(
        [string]$HostName,
        [switch]$ToUpper,
        [switch]$ToLower,
        [string]$HostId,
        [switch]$SameAlias,
        [switch]$WhatIf
    )
    #Verify parameters

    #WARNING if you want the alias to be equal to the name, use -SameAlias switch and run the command again.
    if(!$SameAlias){
        Write-Host "If you want the alias to be equal to the name, use -SameAlias switch to set it to the same value as name"
        pause
    }
        

    if ($HostName -and $HostId){
        Write-Host -ForegroundColor Yellow 'Not allowed to use -HostName and -HostID parameters together'
        continue
    }
    
    #Basic PS Object wich will be edited based on the used parameters and finally converted to json
    $PSObj = New-ZXApiRequestObject -Method "host.update"
    $PSObj | Add-Member -MemberType NoteProperty -Name "hostid" -Value $HostId

    if($HostId){
        $ZXHost = Get-ZXHost -HostID $HostId
        if($null -eq $ZXHost.hostid){
            Write-Host -ForegroundColor Yellow "[Not Found]" -NoNewline
            Write-Host " $HostId"
            Continue
        }

    }
    elseif ($HostName){
        $ZXHost = Get-ZXHost -Name $HostName
        if($null -eq $ZXHost.host){
            Write-Host -ForegroundColor Yellow "[Not Found]" -NoNewline
            Write-Host " $HostName"
            Continue
        }

    }
    #NewHostName
    if ($ToUpper){
        $NewHostName ="$($ZXHost.host)".ToUpper()
    }
    if ($ToLower){
        $NewHostName ="$($ZXHost.host)".ToLower()
    }
    
    #Read the $ZXHost properties and use the values to fill in $PSobject properties. $PSobject is later converted to $json request
    #This is setting host parameter
    $PSObj.params.hostid = $ZXHost.hostid
    $PSObj.params |  Add-Member -MemberType NoteProperty -Name "host" -Value $NewHostName
    #If -SameAlias switch is not used, the host alias is not changed.
    if($SameAlias){
        #This is setting name parameter to what you set as the host
        $PSObj.params |  Add-Member -MemberType NoteProperty -Name "name" -Value $NewHostName
    }
    else{
        #This is setting name parameter to the same name as it was before
        $PSObj.params |  Add-Member -MemberType NoteProperty -Name "name" -Value $ZXHost.name
    } 
    
    $Json = $PSObj | ConvertTo-Json -Depth 5

    #Show JSON Request if -Whatif switch is used
    If ($WhatIf){
        Write-JsonRequest
    }

    #Make the API call
    if(!$Whatif){
        $Request = Invoke-RestMethod -Uri $ZXAPIUrl -Body $Json -ContentType "application/json" -Method Post
    }

    #This will be returned by the function
    if($null -ne $Request.error){
        $Request.error
        return
    } 
    elseif ($null -ne $Request.result) {
        Write-Host -ForegroundColor Green "$($Request.result.hostids) [$HostName] > $NewHostName"
        return
    }
    elseif(!$WhatIf) {
        Write-Host -ForegroundColor Yellow "No result"
        return
    }    
}