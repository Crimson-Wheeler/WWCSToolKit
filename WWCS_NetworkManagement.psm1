function Get-NetworkInfo
{

    $fileName = "NetworkInfo.txt"
    $directory = "C:\Temp\Logs"
    $filePath = "$($directory)\$($fileName)"

    #creates dir if not exist
    if(-not (Test-Path -Path $directory))
    {
        New-Item $directory -ItemType Directory
    }

    #removes info file if exists
    if(Test-Path -Path $filePath)
    {
        Remove-Item $filePath
    }
    
    #write ipconfig to the file
    "IPCONFIG -----------------------------------------------------------------------------" | Out-File -FilePat $filePath -Append
    ipconfig -all | Out-File -FilePath $filePath -Append

    #write net info to the file
    "Network Info-----------------------------------------------------------------------------" | Out-File -FilePath $filePath -Append
    Get-NetworkInfo | Out-File -FilePath $filePath -Append

    #write dns info to the file
    "DNS Settings-----------------------------------------------------------------------------" | Out-File -FilePath $filePath -Append
    ipconfig -displaydns | Out-File -FilePath $filePath -Append

    
    notepad.exe $filePath | Out-File -FilePath $filePath -Append
}


#resets everything associated with the networks cache
function Clear-NetworkCache([switch]$reboot)
{
    #basic network troubleshooting
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