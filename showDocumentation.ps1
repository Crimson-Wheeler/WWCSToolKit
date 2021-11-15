function Get-WWCSTOOLKITPath()
{
    return "C:\Windows\system32\WindowsPowerShell\v1.0\Modules\WWCS-TOOLKIT"
}





$BaseModuleFunctions = Import-Csv -Path "$(Get-WWCSTOOLKITPath)\Data\WWCSStandardFunctions.csv"
$WWCSProgramFunctions = Import-Csv -Path "$(Get-WWCSTOOLKITPath)\Data\WWCSStandardFunctions.csv"
$PrinterManagementFunctions = Import-Csv -Path "$(Get-WWCSTOOLKITPath)\Data\WWCSStandardFunctions.csv"
$UserManagementFunctions = Import-Csv -Path "$(Get-WWCSTOOLKITPath)\Data\WWCSStandardFunctions.csv"
$OfficeFunctions = Import-Csv -Path "$(Get-WWCSTOOLKITPath)\Data\WWCSStandardFunctions.csv"
$NetworkManagementFunctions = Import-Csv -Path "$(Get-WWCSTOOLKITPath)\Data\WWCSStandardFunctions.csv"
$LoggingMessagingFunctions = Import-Csv -Path "$(Get-WWCSTOOLKITPath)\Data\WWCSStandardFunctions.csv"

Write-Host "Base Module:"
$BaseModuleFunctions | Format-Table