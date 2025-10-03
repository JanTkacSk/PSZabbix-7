function Update-ZXHostTagList{
    param(
        [string]$HostName,
        [string]$HostId,
        [string]$AddTag, 
        [string]$AddTagValue,
        [string]$RemoveTag,
        [string]$RemoveTagValue,
        [switch]$RemoveAllTags,
        [switch]$WhatIf
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

    if ($AddTag -eq $RemoveTag -and $AddTagValue -eq $RemoveTagValue){
        Write-Host -ForegroundColor Red "You are trying to add and remove an identical tag/value pair. Choose only one operation."
        continue
    }

    if($RemoveTag -and -not $RemoveTagValue ) {
        Write-Host -ForegroundColor Yellow "-RemoveTagValue parameter was not specified. This will remove all $RemoveTag tags regardless of the value. Continue ?"
        Pause    
    }

    #Funcions
    function DateToString{
        (Get-Date).ToString("2024-MM-dd_HH.mm.ss.ffff")
    }

    
    #Basic PS Object wich will be edited based on the used parameters and finally converted to json
    $PSObj = New-ZXApiRequestObject -Method "host.update"
    $PSObj | Add-Member -MemberType NoteProperty -Name "hostid" -Value $HostId

    if($AddTag -or $RemoveTag -or $RemoveAllTags){
       
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

        if($AddTag){
            $TagList =  $Taglist += [PSCustomObject]@{"tag"= $AddTag; "value"=$AddTagValue}
        }

        if($RemoveTag){
            if (!$RemoveTagValue){                
                $TagList.Remove(($TagList|Where-Object {$_.tag -ceq $TagName}))
            }
            if($RemoveTagValue){
                $TagList.Remove(($TagList|Where-Object {$_.tag -ceq $RemoveTag -and $_.value -ceq $RemoveTagValue}))
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


