function Clear-PrintSpooler
{
    #stop print service
    Get-Service *spooler* | Stop-Service

    #delete queue
    Remove-Item -Path %systemroot%\System32\spool\printers\* -Recurse
    
    #start print service
    Get-Service *spooler* | Start-Service
}

function Get-WWCSPrinter($prompt = "Installed Printers", $SelectPrompt = "Select Printer", [Switch] $Selecting)
{

    $printers = Get-Printer
    $index = 1;

    #display all printers
    Write-Host $prompt
    Write-Host "$(New-TextSpacing -amount 7 -inputText "Choice")|   Printer Name"
    Write-Host "-----------------------------------------------------------"
    foreach($printer in $printers)
    {
        Write-Host "$(New-TextSpacing -amount 7 -inputText $index.ToString())|   $($printer.Name)"
        $index++
    }
    
    #if selecting then choose a printer obj to return
    if($Selecting) 
    {
        $inputVal = Read-Host -Prompt $SelectPrompt
        return Get-Printer -Name $printers[$inputVal-1].Name
    }

}

#Calls get printer and lets the user to select one to remove
Function Remove-WWCSPrinter()
{
    #prompts the user to select printer to remove
    $printerToRemove = Get-WWCSPrinter -SelectPrompt "Select a Printer to Remove" -Selecting $true
    Write-Host "Removing: $($printerToRemove.Name)"
}

Function New-WWCSPrinter()
{
    
}


Function Get-WWCSPrinters($Password)
{
    #defines the array list
    $newPrinterList = [System.Collections.ArrayList]@()

    #defines types to exclude from output
    $exclusions = @("Fax", "OneNote", "PDF", "XPS")
    
    #gets all printers
    $printers = Get-Printer | select Name,PortName,DriverName,Shared

    #increments through printers and if they are not excluded, adds it to the ones to export
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

    #export to csv
    $newPrinterList | Export-Csv C:\Temp\Printers.csv -NoTypeInformation
    
    #send email
    Send-PSEmail -Password $Password `
                    -Subject "WWCS Toolkit Printers on $($env:COMPUTERNAME) at $($env:USERDOMAIN)" `
                    -Body "Printers" `
                    -attachments @('C:\Temp\Printers.csv')
    return $newPrinterList
}

