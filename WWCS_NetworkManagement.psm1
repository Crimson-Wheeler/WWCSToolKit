function Get-NetworkInfo
{
    $fileName = "NetworkInfo.txt"
    $directory = "C:\Temp\Logs"
    $filePath = "$($directory)\$($fileName)"
    if(-not (Test-Path -Path "C:\Temp\Logs"))
    {
        New-Item $directory -ItemType Directory
    }

    "IPCONFIG" > $filePath
    ipconfig /all >$filePath
}