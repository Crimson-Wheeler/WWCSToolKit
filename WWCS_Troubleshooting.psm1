function Start-Repair()
{
    Dism.exe /online /Cleanup-Image /checkhealth
    Dism.exe /online /Cleanup-Image /scanhealth
    Dism.exe /online /Cleanup-Image /Restorehealth
    sfc /scannow
    Dism.exe /Online /Cleanup-Image /AnalyzeComponentStore
    Dism.exe /Online /Cleanup-Image /StartComponentCleanup
}