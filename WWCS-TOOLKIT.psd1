@{
    Author = "WWCS Inc."
    CompanyName = "WWCS Inc."
    Copyright = "© WWCS Inc. All Rights Reserved"
    HelpInfoUri="wwcs.com"
    ModuleVersion = "1.4.23.21" #Key [Structure Change].[New File].[New Function].[Function Change/Bug Fix]

    # Modules that must be imported into the global environment prior to importing this module
    RequiredModules = @()
    # Script files (.ps1) that are run in the caller's environment prior to importing this module.
    ScriptsToProcess = @('showDocumentation')


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
                        'WWCS_LogonAuditing.psm1'
                        )
    FunctionsToExport = @('Send-Email',
                            'Get-WWCSTOOLKITPath',
                            'Get-WWCSDataPath',
                            'test',
                            'Check-O365PasswordValid',
                            'Create-ADUser',
                            'Connect-MSOL',
                            'Delete-O365User',
                            'Decomission-O365User',
                            'Create-O365User',
                            'Clear-PrintSpooler',
                            'Add-Printer',
                            'Get-ADComputersLastLogon',
                            'Get-NetworkInfo',
                            'Clear-NetworkCache',
                            'Clear-PrintSpooler',
                            'Get-WWCSPrinter',
                            'Remove-WWCSPrinter',
                            'New-WWCSPrinter',
                            'Open-Program',
                            'Open-WWCSProgram',
                            'New-WWCSComputer',
                            'Get-WWCSDocumentation',
                            'Get-WWCSCommands',
                            'Set-WWCSClipboard',
                            'New-ClipboardEntry',
                            'Get-ClipboardDirectory',
                            'Get-ClipboardHistory',
                            'New-WhiteSpace',
                            'New-TextSpacing',
                            'Get-WWCSLogons',
                            'Write-WWCSLogons',
                            'Get-WWCSFailedLogonAudit',
                            'New-TextSpacing',
                            'New-WhiteSpace'
                        )


}