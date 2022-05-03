function Start-Repair()
{
    Dism.exe /online /Cleanup-Image /checkhealth
    Dism.exe /online /Cleanup-Image /scanhealth
    Dism.exe /online /Cleanup-Image /Restorehealth
    sfc /scannow
    Dism.exe /Online /Cleanup-Image /AnalyzeComponentStore
    Dism.exe /Online /Cleanup-Image /StartComponentCleanup
}

function Clear-UpdateCache()
{
    #stop the update service
    Stop-Service wuauserv

    #delete files
    Remove-Item 'C:\Windows\SoftwareDistribution\Download\' -Recurse

    #start the update service
    Start-Service wuauserv
}

function Reset-WindowsUpdate()
{

    Stop-Service wuauserv
    Stop-Service cryptSvc
    Stop-Service bits
    Stop-Service msiserver

    Rename-Item "C:\Windows\SoftwareDistribution" "C:\Windows\SoftwareDistribution.old" 
    Rename-Item "C:\Windows\System32\catroot2" "C:\Windows\System32\catroot2.old"

    Start-Service wuauserv
    Start-Service cryptSvc
    Start-Service bits
    Start-Service msiserver

    Write-Host "Please reboot your computer to finalize windows update reset."
}