function Get-NetworkInfo
{

    $fileName = "NetworkInfo.txt"
    $directory = "C:\Temp\Logs"
    $filePath = "$($directory)\$($fileName)"


    if(-not (Test-Path -Path $directory))
    {
        New-Item $directory -ItemType Directory
    }
    if(Test-Path -Path $filePath)
    {
        Remove-Item $filePath
    }
    

    "IPCONFIG -----------------------------------------------------------------------------" | Out-File -FilePat $filePath -Append
    ipconfig -all | Out-File -FilePath $filePath -Append

    "Network Info-----------------------------------------------------------------------------" | Out-File -FilePath $filePath -Append
    Get-NetworkInfo | Out-File -FilePath $filePath -Append

    "Net Adapters-----------------------------------------------------------------------------" | Out-File -FilePath $filePath -Append
    "DNS Settings-----------------------------------------------------------------------------" | Out-File -FilePath $filePath -Append
    "DNS Settings-----------------------------------------------------------------------------" | Out-File -FilePath $filePath -Append
    "DNS Settings-----------------------------------------------------------------------------" | Out-File -FilePath $filePath -Append
    notepad.exe $filePath
}

function Clear-NetworkCache($reboot = $false)
{
    ipconfig /flushdns
    ipconfig /registerdns
    ipconfig /release
    ipconfig /renew
    netsh winsock reset

    if($reboot -eq $true)
    {
        shutdown /r /t 0
    }
}