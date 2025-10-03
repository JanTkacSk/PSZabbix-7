function Update-ZXHostTemplateList{
    param(
        [string]$HostId,
        [string]$LinkTemplateID, 
        [string]$UnlinkTemplateID,
        [string]$UnlinkClearTemplateID,
        [switch]$WhatIf
    )

    #Basic PS Object wich will be edited based on the used parameters and finally converted to json
    $PSObj = New-ZXApiRequestObject -Method "host.update"
    $PSObj | Add-Member -MemberType NoteProperty -Name "hostid" -Value $HostId

    if($LinkTemplateID -or $UnlinkTemplateID){
        $ZXHost = Get-ZXHost -HostID $HostId -IncludeParentTemplates

        $PSObj.params.hostid = $ZXHost.hostid
        $PSObj.params |  Add-Member -MemberType NoteProperty -Name "host" -Value $ZXHost.host
        $PSObj.params |  Add-Member -MemberType NoteProperty -Name "name" -Value $ZXHost.name
        $TemplateList = $ZXHost.ParentTemplates

        if($LinkTemplateID){
            $TemplateList =  $TemplateList += @{"templateid"= $LinkTemplateID}
        } 
    
        if($UnlinkTemplateID){
            $TemplateList = $TemplateList | Where-Object {$_.templateid -ne $UnlinkTemplateID}
        } 

        $PSObj.params |  Add-Member -MemberType NoteProperty -Name "templates" -Value @($TemplateList)

    }
    
    if($UnlinkClearTemplateID){
        $ZXHost = Get-ZXHost -HostID $HostId -IncludeParentTemplates
        $TemplatesToClear = $ZXHost.ParentTemplates | Where-Object {$_.templateid -eq $UnlinkClearTemplateID}
        $PSObj.params.hostid = $HostId
        $PSObj.params |  Add-Member -MemberType NoteProperty -Name "host" -Value $ZXHost.host
        $PSObj.params |  Add-Member -MemberType NoteProperty -Name "name" -Value $ZXHost.name
        $PSObj.params |  Add-Member -MemberType NoteProperty -Name "templates_clear" -Value @($TemplatesToClear)
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


