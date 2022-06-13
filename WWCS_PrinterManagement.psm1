function Clear-PrintSpooler
{
    Get-Service *spooler* | Stop-Service
    Remove-Item -Path %systemroot%\System32\spool\printers\* -Recurse
    Get-Service *spooler* | Start-Service
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

Function Get-WWCSPrinters($Password)
{

    $newPrinterList = [System.Collections.ArrayList]@()

    $exclusions = @("Fax", "OneNote", "PDF", "XPS")
    
    $printers = Get-Printer | select Name,PortName,DriverName,Shared

    foreach($printer in $printers)
    {
        $excluded = $false
        $name = $printer.Name
        foreach($exclusion in $exclusions)
        {
            if($name -like "*$($exclusion)*")
            {
                Write-Host "Excluding: $($name)"
                $excluded = $true
            }
        }
        if(-not $excluded)
        {
            $newPrinterList.Add($printer)
        }
    }
    $newPrinterList | Export-Csv C:\Temp\Printers.csv -NoTypeInformation
    Send-PSEmail -Password $Password `
                    -Subject "WWCS Toolkit Printers on $($env:COMPUTERNAME) at $($env:USERDOMAIN)" `
                    -Body "Printers" `
                    -attachments @('C:\Temp\Printers.csv')
    return $newPrinterList
}

