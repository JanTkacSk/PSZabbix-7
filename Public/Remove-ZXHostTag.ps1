function Remove-ZXHostTag{
    param(
        [string]$HostName,
        [string]$HostId,
        [string]$TagName,
        [string]$TagValue,
        [switch]$RemoveAllTags,
        [switch]$WhatIf,
        [Alias("f")]
        [switch]$Force
    )
    #Validate Parameters
    if ($HostId -and $HostName){
    Write-Host -ForegroundColor Red 'You cannot use -HostId and -HostName parameter at the same time'
    continue
    }

    if ($HostId){
        If ($HostId.GetType().Name -ne "String"){
            Write-Host -ForegroundColor Red "HostId must be a String, your input is $($HostId.GetType().Name)"
            continue
        }
    }
    elseif($HostName){
            If ($HostName.GetType().Name -ne "String"){
            Write-Host -ForegroundColor Red "HostName must be a String, your input is $($HostId.GetType().Name)"
            continue
        }
    }

    if($TagName -and -not $TagValue -and -not $Force ) {
        Write-Host -ForegroundColor Yellow "'TagValue' parameter was not specified. This will remove all $TagName tags regardless of the value. Continue ?"
        Pause    
    }
   
    #Basic PS Object wich will be edited based on the used parameters and finally converted to json
    $PSObj = New-ZXApiRequestObject -Method "host.update"
    $PSObj | Add-Member -MemberType NoteProperty -Name "hostid" -Value $HostId

    if($TagName -or $RemoveAllTags){
       
        if($HostId){
            $ZXHost = Get-ZXHost -HostID $HostId -IncludeTags
        }
        elseif ($HostName){
            $ZXHost = Get-ZXHost -Name $HostName -IncludeTags
        }

        if($ZXHost -eq $null){
        Write-Host -ForegroundColor Yellow "Host not found"
        continue
        }
    

        $PSObj.params.hostid = $ZXHost.hostid
        $PSObj.params |  Add-Member -MemberType NoteProperty -Name "host" -Value $ZXHost.host
        $PSObj.params |  Add-Member -MemberType NoteProperty -Name "name" -Value $ZXHost.name
        [System.Collections.ArrayList]$TagList = $ZXHost.tags

        if($TagName){
            if (!$TagValue){                
                $TagList.Remove(($TagList|Where-Object {$_.tag -ceq $TagName}))


            }
            if($TagValue){
                $TagList.Remove(($TagList|Where-Object {$_.tag -ceq $TagName -and $_.value -ceq $TagValue}))
            }
        }
        
        if($RemoveAllTags){
            $TagList = @()
        } 

        $PSObj.params |  Add-Member -MemberType NoteProperty -Name "tags" -Value @($TagList)

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


