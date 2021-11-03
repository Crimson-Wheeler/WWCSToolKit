@{
    Author = "WWCS Inc."
    CompanyName = "WWCS Inc."
    Copyright = "© WWCS Inc. All Rights Reserved"
    HelpInfoUri="wwcs.com"
    ModuleVersion = "1.0.0.1"
    NestedModules = @('WWCS-TOOLKIT.psm1',
                        'WWCS_AD.psm1',
                        'WWCS_Office.psm1',
                        'WWCS_Messages.psm1',
                        'WWCS_PasswordManagement.psm1',
                        'WWCS_PrinterManagement.psm1',
                        'WWCS_NetworkManagement.psm1'
                        )
    FunctionsToExport = @('Send-Email',
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
                            'Clear-PrintSpooler'
                        )
}