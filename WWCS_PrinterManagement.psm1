function Clear-PrintSpooler
{
    net stop spooler
    del %systemroot%\System32\spool\printers\* /Q 
    net start spooler
}

function Get-WWCSPrinter($input = "Installed Printers", $SelectPrompt = "Select Printer", $Selecting = $false)
{

    $printers = Get-Printer
    $index = 1;


    
    Write-Host $input
    Write-Host "Index$(New-WhiteSpace -amount 25
    )|   Printer Name"
    Write-Host "-----------------------------------------------------------"
    foreach($printer in $printers)
    {

        Write-Host "$($index)$(New-WhiteSpace -amount 7 -textOffset $index)|   $($printer.Name)"

        $index++
    }
    
    if($Selecting -eq $true) 
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

