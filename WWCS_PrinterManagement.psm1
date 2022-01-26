function Clear-PrintSpooler
{
    net stop spooler
    del %systemroot%\System32\spool\printers\* /Q 
    net start spooler
}

function Get-WWCSPrinter($prompt = "Installed Printers", $SelectPrompt = "Select Printer", [Switch] $Selecting)
{

    $printers = Get-Printer
    $index = 1;


    
    Write-Host $prompt
    Write-Host "$(New-TextSpacing -amount 7 -inputText "Choice")|   Printer Name"
    Write-Host "-----------------------------------------------------------"
    foreach($printer in $printers)
    {

        Write-Host "$(New-TextSpacing -amount 7 -inputText $index.ToString())|   $($printer.Name)"

        $index++
    }
    
    if($Selecting) 
    {
        $inputVal = Read-Host -Prompt $SelectPrompt
        return Get-Printer -Name $printers[$inputVal-1].Name
    }

}

Function Remove-WWCSPrinter()
{
    $printerToRemove = Get-WWCSPrinter -SelectPrompt "Select a Printer to Remove" -Selecting $true
    Write-Host "Removing: $($printerToRemove.Name)"
}

Function New-WWCSPrinter()
{
    
}

