function Get-WWCSTOOLKITPath
{
    return "C:\Windows\system32\WindowsPowerShell\v1.0\Modules\WWCS-TOOLKIT"
}
function Get-WWCSDataPath
{
    #Check to see if it exists, creates it if it doesn't
    if(-not (Test-Path -Path "C:\Users\$($env:USERNAME)\AppData\Local\WWCS"))
    {
        New-Item -Path "C:\Users\$($env:USERNAME)\AppData\Local\WWCS" -ItemType directory
    }
    return "C:\Users\$($env:USERNAME)\AppData\Local\WWCS"
}
function Get-WWCSLogPath()
{
    #Check to see if log path exists, creates it if it doesn'tt
    if(-not (Test-Path -Path "C:\Program Files\WWCS\Logs"))
    {
        New-Item -Path "C:\Program Files\WWCS\Logs" -ItemType directory
    }
    return "C:\Program Files\WWCS\Logs"
}


function Write-LogError($message)
{
    #Gets the log path
    $logPath = Get-WWCSLogPath
    $fileName = "error.log"

    #Creates a error log if it does not exists
    if(-not(Test-Path -Path $logPath))
    {
        New-Item -Path $logPath
    }
    $message >> "$($logPath)\$($fileName)"
}
function Write-Log($message,$rootPath,$path,[switch]$Append)
{

    # if the path has a value overwrite the log path
    $logPath = "$(Get-WWCSLogPath)\$($rootPath)"
    if($null -ne $path)
    {
        $logPath = $path
    }
    
    #Create log if it doesn't exist
    if(-not(Test-Path -Path $logPath))
    {
        New-Item -Path $logPath
    }

    #Chooses to overwrite or append file
    if($Append){
        Out-File -FilePath $logPath -InputObject $message -Append
    }
    else {
        Out-File -FilePath $logPath -InputObject $messageA
    }
}

function Get-WWCSCommands()
{
    return Get-Module WWCS-TOOLKIT -ListAvailable | Select-Object -ExpandProperty exportedcommands | Format-Table -Property Value
}



function Get-WWCSReports([switch]$pickLocation)
{
    $copyToLoc = "C:\Users\$($env:username)\WorldWide Computer Solutions, Inc\WWCS - Documents\Customers\Reports\Executive Summary\Summary"

    $folders = Get-ChildItem "C:\Users\$($env:username)\WorldWide Computer Solutions, Inc\WWCS - Documents\Customers\Customers - Active" Summary -recurse
    foreach ($folder in $folders) 
    {
        $newestFile = Get-ChildItem $folder -File | Sort-Object -Descending -Property LastWriteTime | Select-Object -First 1
        Write-Host $newestFile.FullName
        try 
        {
            Copy-Item $newestFile.PSPath $copyToLoc 
        }
        catch
        {
            Write-Host $Error
        }
        
    }
}

function Invoke-ToolkitTest()
{
    Write-Host "Beginning Test with logging to WWCS log files"
    Write-LogError "This is a test WWCS Log"

    Write-Host "Sending Test email"
    Send-Email -Body "This is a test email from $($env:COMPUTERNAME)" -Subject "This is a test email from $($env:COMPUTERNAME) at $($env:USERDOMAIN)"

}