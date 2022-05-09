function DownloadGitHubRepository 
{ 
    if (Test-Path -Path 'C:\Temp\.zip')
    {
        Remove-Item 'C:\Temp\.zip' -Recurse -Force
    }
    if (Test-Path -Path 'C:\Temp\WWCSToolKit-main')
    {
        Remove-Item  'C:\Temp\WWCSToolKit-main' -Recurse -Force
    }
    if (Test-Path -Path 'C:\Windows\system32\WindowsPowerShell\v1.0\Modules\WWCSToolKit-main')
    {
        Remove-Item 'C:\Windows\system32\WindowsPowerShell\v1.0\Modules\WWCSToolKit-main' -Recurse -Force
    }
    
    $logPath = "C:\Program Files\WWCS\Logs"
    $dataPath = "C:\Program Files\WWCS\DataControl"
    $programPaths = "C:\Program Files\WWCS\Programs"
    $fileName = "WWCS-TOOLKIT.log"
    $tempPath = "C:\Temp"
    if (Test-Path -Path 'C:\Windows\system32\WindowsPowerShell\v1.0\Modules\WWCS-TOOLKIT') {
        "Path exists!"
        Remove-Item 'C:\Windows\system32\WindowsPowerShell\v1.0\Modules\WWCS-TOOLKIT' -Recurse -Force
    }
    
     
    # Force to create a zip file 
    $ZipFile = "C:\Temp\.zip"

    if(Test-Path -Path "($tempPath)\WWCSToolKit-main")
    {
        Remove-Item -Path "($tempPath)\WWCSToolKit-main" -Recurse -Force
    }
    if(Test-Path -Path $ZipFile)
    {
        Remove-Item -Path $ZipFile -Recurse -Force
    }



    New-Item $ZipFile -ItemType File -Force

    #$RepositoryZipUrl = "https://github.com/sandroasp/Microsoft-Integration-and-Azure-Stencils-Pack-for-Visio/archive/master.zip"
    $RepositoryZipUrl = "https://github.com/Crimson-Wheeler/WWCSToolkit/archive/main.zip" 
    # download the zip 
    Write-Host 'Starting downloading the GitHub Repository'
    Invoke-RestMethod -Uri $RepositoryZipUrl -OutFile $ZipFile
    Write-Host 'Download finished'
    $modulePath =  "C:\Windows\system32\WindowsPowerShell\v1.0\Modules"
    #Extract Zip File
    Write-Host 'Starting unzipping the GitHub Repository locally'

    try
    {
        Expand-Archive -Path $ZipFile -DestinationPath $tempPath
        Expand-Archive -Path $ZipFile -DestinationPath $modulePath
    }
    catch
    {
        #Add-Type -Path "C:\Program Files (x86)\Reference Assemblies\Microsoft\Framework\.NETFramework\v4.5\System.IO.Compression.FileSystem.dll"
        [System.IO.Compression.ZipFile]::ExtractToDirectory($ZipFile, $tempPath)
        [System.IO.Compression.ZipFile]::ExtractToDirectory($Zipfile, $modulePath)
    }

    Write-Host 'Unzip finished'
    Write-Host 'Compare Module Versions'
    $tempModule = "$($tempPath)\WWCSToolKit-main"
    $module = "C:\Windows\system32\WindowsPowerShell\v1.0\Modules\WWCSToolKit-main"
    $tempVersion = getVersionOfModule("$($tempModule)\WWCS-TOOLKIT.psd1")
    $moduleVersion = getVersionOfModule("$($module)\WWCS-TOOLKIT.psd1")
    $module = "C:\Windows\system32\WindowsPowerShell\v1.0\Modules\WWCS-TOOLKIT"
    if($tempVersion -eq $moduleVersion)
    {
        "SUCCESS: WWCS-TOOLKIT is Up to date" > "$($tempPath)\$($fileName)"
    } 
    else
    {
        "ERROR: Toolkit Out Of Date" > "$($tempPath)\$($fileName)"
    }

    Write-Host "Renaming to WWCS-TOOLKIT"
    Rename-Item -Path "C:\Windows\system32\WindowsPowerShell\v1.0\Modules\WWCSToolKit-main" -NewName $module
     
    Write-Host "Copy programs to #($progamPaths)"
    if(Test-Path -Path "$($programPaths)")#removes so everything can be overridden
    {
        Remove-Item -Path "$($programPaths)" -Recurse -Force
    }
    Copy-Item -Path "$($module)\Programs" -Destination $programPaths -Recurse

    Write-Host "Copy data to #($dataPath)"
    if(Test-Path -Path "$($dataPath)")#removes so everything can be overridden
    {
        Remove-Item -Path "$($dataPath)" -Recurse -Force
    }
    Copy-Item -Path "$($module)\DataControl" -Destination $dataPath -Recurse





    if(-not (Test-Path -Path "$($logPath)"))
    {
        New-Object -TypeName '' -Path $logPath
    }
    


    
    



    Remove-Item -Path $tempModule -Recurse -Force
    Remove-Item -Path $ZipFile -Force
}

function getVersionOfModule($DataPath)
{
    #$data = Get-Content -Path $DataPath
    
    $data = Import-PowerShellDataFile $DataPath
    $dataInfo = "$($data.Values)".Split(' ')
    $version = $dataInfo[$dataInfo.Count-1]

    Write-Host "VERSION: $($version)"
    return $version
}

function getInstalledVersion()
{
    $module = Get-Module "WWCS-TOOLKIT" -ListAvailable
    return Write-Output $module.Version.ToString()    
}




try{
    $psversion = "$(Get-Host | Select-Object Version)"

    if($PSVersionTable.PSVersion.Major -ge 5)
    {
        try
        {
            #Set-ExecutionPolicy -ExecutionPolicy Undefined -Scope CurrentUser -Force
            ##Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope LocalMachine -Force
            #Set-ExecutionPolicy -ExecutionPolicy Undefined -Scope MachinePolicy -Force
            #Set-ExecutionPolicy -ExecutionPolicy Undefined -Scope Process -Force
            #Set-ExecutionPolicy -ExecutionPolicy Undefined -Scope UserPolicy -Force
            Import-Module Microsoft.PowerShell.Archive
            DownloadGitHubRepository
        }
        catch
        {
            foreach($err in $Error)
            {
                "ERROR: $($err)" > "C:\Temp\WWCS-TOOLKIT.log"
            }
        }
    }
    else
    {
        "ERROR: PowerShell Outdated $($PSVersionTable.PSVersion)" > "C:\Temp\WWCS-TOOLKIT.log"
    }
}
catch
{
    foreach($err in $Error)
    {
        Write-Host "ERROR: $($err)"
    }
    Start-Sleep -Seconds 5
}
