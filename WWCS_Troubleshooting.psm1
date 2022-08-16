function Start-Repair()
{
    Dism.exe /online /Cleanup-Image /checkhealth
    Dism.exe /online /Cleanup-Image /scanhealth
    Dism.exe /online /Cleanup-Image /Restorehealth
    sfc /scannow
    Dism.exe /Online /Cleanup-Image /AnalyzeComponentStore
    Dism.exe /Online /Cleanup-Image /StartComponentCleanup
}

#Removes all data held for windows updates so that the computer can start fresh
function Clear-UpdateCache()
{
    #stop the update service
    Stop-Service wuauserv

    #delete files
    Remove-Item 'C:\Windows\SoftwareDistribution\Download\' -Recurse

    #start the update service
    Start-Service wuauserv
}

#Removes all data associated with windows updates and other services that aassist in the update process
#Suggests a reboot after to finalize the windows clearing process
function Reset-WindowsUpdate()
{

    #stop update services
    Stop-Service wuauserv
    Stop-Service cryptSvc
    Stop-Service bits
    Stop-Service msiserver

    #renames the cache folders so that update can retry the download
    Rename-Item "C:\Windows\SoftwareDistribution" "C:\Windows\SoftwareDistribution.old" -Force
    Rename-Item "C:\Windows\System32\catroot2" "C:\Windows\System32\catroot2.old" -Force

    #start the update services
    Start-Service wuauserv
    Start-Service cryptSvc
    Start-Service bits
    Start-Service msiserver


    Write-Host "Please reboot your computer to finalize windows update reset."
}