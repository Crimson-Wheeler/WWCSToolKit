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

    "DNS Settings-----------------------------------------------------------------------------" | Out-File -FilePath $filePath -Append
    ipconfig -displaydns

    "DNS Settings-----------------------------------------------------------------------------" | Out-File -FilePath $filePath -Append
    "DNS Settings-----------------------------------------------------------------------------" | Out-File -FilePath $filePath -Append
    notepad.exe $filePath | Out-File -FilePath $filePath -Append
}

function Clear-NetworkCache([switch]$reboot)
{
    ipconfig /flushdns
    ipconfig /registerdns
    ipconfig /release
    ipconfig /renew
    netsh winsock reset
    

    if($reboot)
    {
        shutdown /r /t 0
    }
}

function Set-DNSAddress()
{
    $adapter = Get-NetAdapter | where {$_.InterfaceDescription -like "*Check point Virtual Network Adapter*"}
    Set-DnsClientServerAddress $adapter.Name -ServerAddresses ("192.168.101.1","192.168.101.1")
}