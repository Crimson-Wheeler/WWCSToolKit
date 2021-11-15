function Get-WWCSTOOLKITPath()
{
    return "C:\Windows\system32\WindowsPowerShell\v1.0\Modules\WWCS-TOOLKIT"
}

function Set-WindowStyle {
param(
    [Parameter()]
    [ValidateSet('FORCEMINIMIZE', 'HIDE', 'MAXIMIZE', 'MINIMIZE', 'RESTORE', 
                 'SHOW', 'SHOWDEFAULT', 'SHOWMAXIMIZED', 'SHOWMINIMIZED', 
                 'SHOWMINNOACTIVE', 'SHOWNA', 'SHOWNOACTIVATE', 'SHOWNORMAL')]
    $Style = 'SHOW',
    [Parameter()]
    $MainWindowHandle = (Get-Process -Id $pid).MainWindowHandle
)
    $WindowStates = @{
        FORCEMINIMIZE   = 11; HIDE            = 0
        MAXIMIZE        = 3;  MINIMIZE        = 6
        RESTORE         = 9;  SHOW            = 5
        SHOWDEFAULT     = 10; SHOWMAXIMIZED   = 3
        SHOWMINIMIZED   = 2;  SHOWMINNOACTIVE = 7
        SHOWNA          = 8;  SHOWNOACTIVATE  = 4
        SHOWNORMAL      = 1
    }
    Write-Verbose ("Set Window Style {1} on handle {0}" -f $MainWindowHandle, $($WindowStates[$style]))

    $Win32ShowWindowAsync = Add-Type –memberDefinition @” 
    [DllImport("user32.dll")] 
    public static extern bool ShowWindowAsync(IntPtr hWnd, int nCmdShow);
“@ -name “Win32ShowWindowAsync” -namespace Win32Functions –passThru

    $Win32ShowWindowAsync::ShowWindowAsync($MainWindowHandle, $WindowStates[$Style]) | Out-Null
}

(Get-Process -Name powershell).MainWindowHandle | foreach { Set-WindowStyle MAXIMIZE $_ }



$BaseModuleFunctions = Import-Csv -Path "$(Get-WWCSTOOLKITPath)\Data\WWCSStandardFunctions.csv"
$WWCSProgramFunctions = Import-Csv -Path "$(Get-WWCSTOOLKITPath)\Data\WWCSStandardFunctions.csv"
$PrinterManagementFunctions = Import-Csv -Path "$(Get-WWCSTOOLKITPath)\Data\WWCSStandardFunctions.csv"
$UserManagementFunctions = Import-Csv -Path "$(Get-WWCSTOOLKITPath)\Data\WWCSStandardFunctions.csv"
$OfficeFunctions = Import-Csv -Path "$(Get-WWCSTOOLKITPath)\Data\WWCSStandardFunctions.csv"
$NetworkManagementFunctions = Import-Csv -Path "$(Get-WWCSTOOLKITPath)\Data\WWCSStandardFunctions.csv"
$LoggingMessagingFunctions = Import-Csv -Path "$(Get-WWCSTOOLKITPath)\Data\WWCSStandardFunctions.csv"


Write-Host ""
Write-Host ""
Write-Host ""
Write-Host ""
Write-Host "Base Module: ________________________________________________________________________________________________"
$BaseModuleFunctions | Format-Table