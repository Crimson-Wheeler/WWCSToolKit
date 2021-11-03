function Get-NetworkInfo
{
    $fileName = "NetworkInfo.txt"
    $directory = "C:\Temp\Logs"
    $filePath = "$($directory)\$($fileName)"
    if(Test-Path -Path "C:\Temp\Logs" -ne $true)
    {
        New-Item $directory -ItemType Directory
    }

    "IPCONFIG" > $filePath
    ipconfig /all >$filePath
}