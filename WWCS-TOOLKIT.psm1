function Get-WWCSTOOLKITPath
{
    return "C:\Windows\system32\WindowsPowerShell\v1.0\Modules\WWCS-TOOLKIT"
}
function Get-WWCSDataPath
{
    if(-not (Test-Path -Path "C:\Users\$($env:USERNAME)\AppData\Local\WWCS"))
    {
        New-Item -Path "C:\Users\$($env:USERNAME)\AppData\Local\WWCS" -ItemType directory
    }
    return "C:\Users\$($env:USERNAME)\AppData\Local\WWCS"
}
function Get-WWCSLogPath()
{
    if(-not (Test-Path -Path "C:\Program Files\WWCS\Logs"))
    {
        New-Item -Path "C:\Program Files\WWCS\Logs" -ItemType directory
    }
    return "C:\Program Files\WWCS\Logs"
}
function Get-Directory(){
    Add-Type -AssemblyName System.Windows.Forms
    $browser = New-Object System.Windows.Forms.FolderBrowserDialog
    $null = $browser.ShowDialog((New-Object System.Windows.Forms.Form -Property @{TopMost = $true; TopLevel = $true}))
    return $browser.SelectedPath
}

function Write-LogError($message)
{
    $logPath = Get-WWCSLogPath
    $fileName = "errorLog.txt"
    if(-not(Test-Path -Path $logPath))
    {
        New-Item -Path $logPath
    }
    $message >> "$($logPath)\$($fileName)"
}
function Write-Log($message,$rootPath,$path,[switch]$Append)
{

    $logPath = "$(Get-WWCSLogPath)\$($rootPath)"
    if($null -ne $path)
    {
        $logPath = $path
    }
    
    if(-not(Test-Path -Path $logPath))
    {
        New-Item -Path $logPath
    }

    if($Append){
        Out-File -FilePath $logPath -InputObject $message -Append
    }
    else {
        Out-File -FilePath $logPath -InputObject $messageA
    }
}

function changeLocalUserCredentials($username, $password)
{
    try
    {
        
        $var = cmdkey /list

        [bool]$domainJoined = $env:USERDOMAIN -ne $env:COMPUTERNAME

        for (($i = 0); $i -lt $var.Count; $i++)
        {
            [String]$line = [String]$var[$i]

            [String]$condition = "User:"
    
            if($line.Contains($condition) -and $line.Substring($line.IndexOf($condition) + $condition.Length+1).Contains($username))
            {
                    $user = $line.Substring($line.IndexOf($condition) + $condition.Length+1)
                    [String]$computer = $var[$i-2]
                    $computer = $computer.Substring($computer.IndexOf("=")+1)

                    if($domainJoined -and -not $user.Contains($env:USERDOMAIN))
                    {
                        cmdkey /add:$computer /user:$user /pass:$password
                    }
            }
    
        }
    }
    catch
    {
        Send-Email -Subject "ERROR: THERE WAS A POWERSHELL ERROR" -Body "ERROR on $($env:COMPUTERNAME): $($Error)"
    }
}
function New-WWCSComputer()
{
    winget install -e --id Google.Chrome --force
    winget install -e --id Adobe.AdobeAcrobatReaderDC --force
    winget install -e --id Oracle.JavaRuntimeEnvironment --force
    invoke-expression -Command "C:\Windows\system32\WindowsPowerShell\v1.0\Modules\WWCS-TOOLKIT\ODT\runODT.ps1"
}
function Get-WWCSDocumentation()
{ 
    invoke-expression -Command "$(Get-WWCSTOOLKITPath)\showDocumentation.ps1"
}
function Get-WWCSCommands()
{
    Get-Module WWCS-TOOLKIT -ListAvailable | Select-Object -ExpandProperty exportedcommands 
}



function Get-WWCSReports([switch]$pickLocation)
{
    $copyToLoc = "C:\Users\crimson.wheeler\WorldWide Computer Solutions, Inc\WWCS - Documents\Customers\Reports\Executive Summary\Summary"

    $folders = Get-ChildItem "C:\Users\crimson.wheeler\WorldWide Computer Solutions, Inc\WWCS - Documents\Customers\Customers - Active" Summary -recurse
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
        #>
    }
}

function Invoke-ToolkitTest()
{
    Write-Host "Beginning Test with logging to WWCS log files"
    Write-LogError "This is a test WWCS Log"

    Write-Host "Sending Test email"
    Send-Email -Body "This is a test email from $($env:COMPUTERNAME)" -Subject "This is a test email from $($env:COMPUTERNAME) at $($env:USERDOMAIN)"

}