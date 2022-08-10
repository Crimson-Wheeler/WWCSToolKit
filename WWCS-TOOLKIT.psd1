@{
    
    <# Helpful links: 
    https://blog.danskingdom.com/fix-problem-where-windows-powershell-cannot-run-script-whose-path-contains-spaces/

    #>

    Author = "WWCS Inc."
    CompanyName = "WWCS Inc."
    Copyright = "© WWCS Inc. All Rights Reserved"
    HelpInfoUri="wwcs.com"
    ModuleVersion = "1.5.34.10" #Key [Structure Change].[New File].[New Function].[Function Change/Bug Fix]

    # Modules that must be imported into the global environment prior to importing this module
    RequiredModules = @()
    # Script files (.ps1) that are run in the caller's environment prior to importing this module.
    #ScriptsToProcess = @('showDocumentation')
    

    NestedModules = @('WWCS-TOOLKIT.psm1',
                        'WWCS_AD.psm1',
                        'WWCS_Office.psm1',
                        'WWCS_Messages.psm1',
                        'WWCS_PasswordManagement.psm1',
                        'WWCS_PrinterManagement.psm1',
                        'WWCS_NetworkManagement.psm1',
                        'WWCS_Programs.psm1',
                        'WWCS_Clipboard.psm1',
                        'WWCS_TextFormatting.psm1',
                        'WWCS_LogonAuditing.psm1',
                        'WWCS_BootDetails.psm1',
                        'WWCS_SoftwareManagement.psm1',
                        'WWCS_DirectoryManagement.psm1',
                        'WWCS_EventLogging.psm1',
                        'WWCS_Troubleshooting.psm1',
                        'WWCS_AppAuditing.psm1'
                        )

    FunctionsToExport =  @(
                            #Get ---
                            'Get-ApplicationDifferences',
                            'Get-WWCSTOOLKITPath',
                            'Get-WWCSDataPath',
                            'Get-WWCSLogPath',
                            'Get-WWCSPrinter',
                            'Get-WWCSFailedLogonAudit',
                            'Get-ApplicationList',
                            'Get-InstalledAppsFromRegistry',
                            'Get-ADComputerLogonEvents',
                            'Get-SuccessfulLogonEvents',
                            'Get-Directory',
                            'Get-LogonEvent',
                            'Get-LogoffEvents',
                            'Get-EventIDProperties',
                            'Get-DirectoryPermissions',
                            'Get-WWCSReports', 
                            'Get-ClipboardDirectory',
                            'Get-ClipboardHistory',
                            'Get-WWCSDocumentation',
                            'Get-WWCSCommands',
                            'Get-AppChangesLog',
                            'Get-WWCSPrinters',
                            #Set ---
                            'Set-WWCSClipboard',
                            'Set-DomainUserWinCredentials',
                            #Invoke ---
                            'Invoke-ToolkitTest',
                            #Clear ---
                            'Clear-PrintSpooler',
                            'Clear-UpdateCache',
                            #New ---
                            'New-WWCSPrinter',
                            'New-ComputerSetup',
                            'New-WhiteSpace',
                            'New-TextSpacing',
                            'New-ClipboardEntry',
                            'New-Process',
                            #Write ---,
                            'Write-Log',
                            #Remove---
                            'Remove-Path',
                            'Remove-WWCSPrinter',
                            #Start---
                            'Start-Repair',
                            'Start-MSOL',
                            #Reset---
                            'Reset-WindowsUpdate',
                            #Remove---
                            'Remove-AppServiceFile',
                            #Show---
                            #Need To Be Standardized --- 
                            'Check-O365PasswordValid',
                            'Reset-0365Pass',
                            'Create-ADUser',
                            'Delete-O365User',
                            'Decomission-O365User',
                            'Create-O365User',
                            'Send-PSEmail',
                            'Send-PSNotification',
                            'Send-UptimeNotification',
                            'Add-Printer',
                            'Get-ADComputersLastLogon',
                            'Get-NetworkInfo',
                            'Clear-NetworkCache',
                            'Clear-PrintSpooler',
                            'Open-Program',
                            'Open-WWCSProgram',
                            'Get-WWCSLogons',
                            'Write-WWCSLogons',
                            'New-TextSpacing',
                            'New-WhiteSpace',
                            'Get-DaysSinceBoot',
                            'Test-AppInstalled',
                            'Uninstall-WWCSToolkit',
                            'Write-LogError',
                            'Send-Notification'
                        )
}