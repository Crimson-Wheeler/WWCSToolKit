
function Get-ClipboardDirectory($set = $false)
{
    if(-not (Test-Path -Path "$(Get-WWCSDataPath)\ClipboardFiles"))
    {
        New-Item -Path "$(Get-WWCSDataPath)\ClipboardFiles" -ItemType directory
    }

    if($set -eq $true)
    {
        Set-Clipboard -Value "$(Get-WWCSDataPath)\ClipboardFiles"
    }
    return "$(Get-WWCSDataPath)\ClipboardFiles"
}
function Set-WWCSClipboard($text)
{
    "Your Clipboard is: $(Get-Clipboard)"

    [string]$path = Get-ClipboardDirectory
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

    Write-Host "VALUES: $($val) : $(Get-Content $val)"
    Set-Clipboard -Value $(Get-Content $val)
}

function New-ClipboardEntry($text,$fileName,$Inputfile)
{
    if($text -ne $null)
    {
        $path = "$(Get-ClipboardDirectory)\$($fileName).txt"

        Set-Content -Path $path -Value $text
    }
}

function Get-ClipboardHistory($outputFile)
{
    
}