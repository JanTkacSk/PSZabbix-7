@{
    # Script module or binary module file associated with this manifest
    RootModule = 'PSZabbix-7.psm1'

    # Version number of this module.
    ModuleVersion = '0.0.7'

    # ID used to uniquely identify this module
    GUID = 'd3e66cb0-4c68-4f07-9d70-b92a15a26c7a'

    # Author of this module
    Author = 'Jan Tkac'

    # Company or vendor of this module
    CompanyName = 'Jan Tkac'

    # Copyright statement for this module
    Copyright = '(c) 2025 Jan Tkac. All rights reserved.'

    # Description of the functionality provided by this module
    Description = 'PowerShell module for managing Zabbix via API.'

    # Minimum version of the Windows PowerShell engine required by this module
    PowerShellVersion = '5.1'

    # Functions to export from this module
    FunctionsToExport = 'Add-ZXHostToGroup,
    Add-ZXHostNameSuffix,
    Add-ZXHostTag,
    Copy-ZXHostProperties,
    Disable-ZXTrigger,
    Enable-ZXTrigger,
    Get-ZXAction,
    Get-ZXAlert,
    Get-ZXApiVersion,
    Get-ZXAuditLog,
    Get-ZXDiscoveryRule,
    Get-ZXEvent,
    Get-ZXHistory,
    Get-ZXHost,
    Get-ZXHostGroup,
    Get-ZXHostInterface,
    Get-ZXItem,
    Get-ZXItemPrototype,
    Get-ZXMaintenance,
    Get-ZXProblem,
    Get-ZXProxy,
    Get-ZXService,
    GEt-ZXSession,
    Get-ZXTemplate,
    Get-ZXTrigger,
    Get-ZXTriggerPrototype,
    Get-ZXUserMacro,
    Invoke-ZXTask,
    Invoke-ZXAddHostTagLoop,
    Invoke-ZXRemoveHostTagLoop,
    New-ZXHost,
    New-ZXProblemTagList,
    New-ZXService,
    New-ZXTagFilter,
    New-ZXTagList,
    New-ZXTokenSession,
    Remove-ZXDiscoveryRule,
    Remove-ZXHost,
    Remove-ZXHostFromGroup,
    Remove-ZXHostNameSuffix,
    Remove-ZXHostTag,
    Remove-ZXItem,
    Remove-ZXMaintenance,
    Remove-ZXTrigger,
    Remove-ZXTriggerPrototype,
    Set-ZXHostLetterCase,
    Set-ZXHostName,
    Set-ZXHostStatus,
    Update-ZXHostTemplateList,
    Update-ZXMaintenance,
    Update-ZXService
'

    # Cmdlets to export from this module
    CmdletsToExport = '*'

    # Variables to export from this module
    VariablesToExport = '*'

    # Aliases to export from this module
    AliasesToExport = '*'

    # Private data to pass to the module specified in RootModule/ModuleToProcess
    PrivateData = @{
        PSData = @{
            # Tags applied to this module. These help with module discovery in online galleries.
            Tags = @('Zabbix', 'API', 'Monitoring')

            # ReleaseNotes of this module
            ReleaseNotes = 'Refactored Add-ZXHostTag - added nulloremplty validation for -HostID and -TagName,
            Refactored Remove-ZXHostTag - added nulloremplty validation for -HostID and -TagName
            and prevented using -TagName without using -TagValue or -Force,
            removed write-host no data if no host was found, there will be standard api error reply
            added Get-ZXUserMacro
            added Invoke-ZXAddHostTagLoop
            added Invoke-ZXRemoveHostTagLoop,
            '
            # Projed URL
            ProjectUri = 'https://github.com/JanTkacSk/PSZabbix-7'
        }
    }
}
