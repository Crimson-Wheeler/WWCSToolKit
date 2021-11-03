function Get-NetworkInfo
{
    ipconfig /all >"C:\Temp\Logs\ipconfigLog.txt"
}