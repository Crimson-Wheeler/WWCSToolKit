﻿

function Set-Clipboard()
{
    "Your Clipboard is: $(Get-Clipboard)"

    [string]$path = Get-WWCSDataPath
    Write-Host $path
    
    $files = [System.Collections.ArrayList]@()
    $files.AddRange(@(Get-ChildItem $($path)));

    Write-Output " "
    Write-Output " "
    Write-Output " "
    Write-Output "File Num | File Choices For Your Clipboard"
    Write-Output "-------------------------------------------"
    [int]$index = 1
    foreach($item in $files)
    {
        Write-Output "$($index)        | $($files[($index-1)])"
        $index++
    }
    Write-Output " "
    Write-Output " "
    Write-Output " "
    [int]$choice =  Read-Host -Prompt 'Pick your File to set to your clipboard'


    [string]$val = "$($path)\$($files[($choice-1)])"
    Set-Clipboard -Value $(Get-Content $val)
}

function New-ClipboardEntry($text,$fileName,$Inputfile)
{
    if($text -ne $null)
    {
        $text > "$($path)\$($fileName).txt"
    }
}