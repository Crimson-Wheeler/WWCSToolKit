
function Get-ClipboardDirectory([switch]$set)
{
    if(-not (Test-Path -Path "$(Get-WWCSDataPath)\ClipboardFiles"))
    {
        New-Item -Path "$(Get-WWCSDataPath)\ClipboardFiles" -ItemType directory
    }

    if($set)
    {
        Set-Clipboard -Value "$(Get-WWCSDataPath)\ClipboardFiles"
    }
    return "$(Get-WWCSDataPath)\ClipboardFiles"
}


function Set-WWCSClipboard()
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
    #lists all clipbard files
    foreach($item in $files)
    {
        Write-Output "$($index)        | $($files[($index-1)])"
        $index++
    }
    Write-Output " "
    Write-Output " "
    Write-Output " "

    #asks the user which file contents they want to set their clipboard to 
    [int]$choice =  Read-Host -Prompt 'Pick your File to set to your clipboard'

    #Gets the file path for the chosen file
    [string]$val = "$($path)\$($files[($choice-1)])"

    #writes the chosen values to write to clipboard
    Write-Host "VALUES: $($val) : $(Get-Content $val)"

    #Sets the clipboard
    Set-Clipboard -Value $(Get-Content $val)
}

#Creates a text file that can be used later to set your clipboard
function New-ClipboardEntry($text,$fileName)
{
    #if text was provided
    if($text -ne $null)
    {
        $path = "$(Get-ClipboardDirectory)\$($fileName).txt"
        
        #Write the input to a file
        Set-Content -Path $path -Value $text
    }
}

function Get-ClipboardHistory($outputFile)
{
    #get clipboard history from windows computer and return it
}