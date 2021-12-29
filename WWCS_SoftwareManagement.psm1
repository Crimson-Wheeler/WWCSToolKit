function Test-AppInstalled($appName)
{
    [bool]$onHKLM = $false
    [bool]$onWMI = $false
    [bool]$onProgramFiles = $false
    [bool]$onProgramFiles86 = $false
    [bool]$onAppData = $false

    Write-Host "Future implementation of WMI here..."
    Write-Host "Testing HKLM..."
    $INSTALLED = Get-ItemProperty HKLM:\Software\Microsoft\Windows\CurrentVersion\Uninstall\* |  Select-Object DisplayName, UninstallString
    $INSTALLED += Get-ItemProperty HKLM:\Software\Wow6432Node\Microsoft\Windows\CurrentVersion\Uninstall\* | Select-Object DisplayName, UninstallString
    $SEARCH = $appName
    $RESULT =$INSTALLED | ?{ $_.DisplayName -ne $null } | Where-Object {$_.DisplayName -like "*$appName*" } 
    $RESULT # this is the application object
    if($RESULT -ne $null)
    {
        $onHKLM = $true
    }

    Write-Host "Testing Program Files..."
    $folders = Get-ChildItem -Path "C:\Program Files" *$appName* -Recurse -Depth 1
    if($folders.Count -gt 0)
    {
        $onProgramFiles = $true
    }

    Write-Host "Testing Program Files x86..."
    $folders = Get-ChildItem -Path "C:\Program Files (x86)" *$appName* -Recurse -Depth 1
    if($folders.Count -gt 0)
    {
        $onProgramFiles86 = $true
    }


    Write-Host "Testing App Data installs..."
    $children = Get-ChildItem -path "C:\users" Local -Recurse -Depth 3 -Force -ErrorAction SilentlyContinue
    for (($i = 0); $i -lt $children.Count; $i++)
    {
        try {
            $child = $children[$i]
            $path = $child.ToString()
            Write-Host $child.ToString()
            $app = Get-ChildItem $path *$appName*
            
            if($app -ne $null)
            {
                Write-Host "Application Installed under:"$child.Parent.Parent.Name
                $onAppData = $true
            }
        }
        catch {
            
        }
       
    }

    #Get a list through app and features
    #Get-ControlPanelItem "Programs and Features"     
    Write-Host "Informational Output...................."
    Write-Host "Install found with WMI.................."$onWMI
    Write-Host "Install found with HKLM................."$onHKLM
    Write-Host "Install found with Program Files........"$onProgramFiles
    Write-Host "Install found with Program Files x86...."$onProgramFiles86
    Write-Host "Install found with App Data............."$onAppData
    if($onHKLM -or $onWMI -or $onProgramFiles -or $onProgramFiles86 -or $onAppData)
    {
        return $true
    }
    return $false
}   