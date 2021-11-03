﻿function Get-NetworkInfo
{

    $fileName = "NetworkInfo.txt"
    $directory = "C:\Temp\Logs"
    $filePath = "$($directory)\$($fileName)"

    if(Test-Path -Path $filePath)
    {
        Remove-Item $directory    
    }
    if(-not (Test-Path -Path $directory))
    {
        New-Item $directory -ItemType Directory
    }

    "IPCONFIG -----------------------------------------------------------------------------" | Out-File -FilePat $filePath -Append
    ipconfig | Out-File -FilePath $filePath -Append

    "DNS Settings-----------------------------------------------------------------------------" | Out-File -FilePath $filePath -Append
    "Net Adapters-----------------------------------------------------------------------------" | Out-File -FilePath $filePath -Append
    "DNS Settings-----------------------------------------------------------------------------" | Out-File -FilePath $filePath -Append
    "DNS Settings-----------------------------------------------------------------------------" | Out-File -FilePath $filePath -Append
    "DNS Settings-----------------------------------------------------------------------------" | Out-File -FilePath $filePath -Append
    notepad.exe $filePath
}