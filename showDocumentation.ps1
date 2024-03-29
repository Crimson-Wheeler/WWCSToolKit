﻿function Get-WWCSTOOLKITPath()
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


Write-Host ""
Write-Host ""
Write-Host ""


$files = [System.Collections.ArrayList]@()
$files.AddRange(@(Get-ChildItem $(;"$(Get-WWCSTOOLKITPath)\Data")))

foreach($item in $files)
{
    if(-NOT ([string]$item).Contains("~"))
    {
        Write-Host "$(([string]$item).Split('.')[0]):________________________________________________________________________________________________"
        $data = Import-Csv -Path "$(Get-WWCSTOOLKITPath)\Data\$($item)"
        $data | Format-Table
        Write-Host ""
        Write-Host ""
    }
    
}


