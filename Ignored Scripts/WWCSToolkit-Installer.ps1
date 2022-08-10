param([string]$pass = "UNCHANGED") 


if(Test-Path 'C:\Temp\toolkitwork.txt')
{
    if(Test-Path "C:\Temp\WWCS-TOOLKIT.log")
    {
        $lastLogData = Get-Content "C:\Temp\WWCS-TOOLKIT.log"
        if($lastLogData.Contains("SUCCESS"))
        {
            Exit
        }
    }
}

Out-File 'C:\Temp\toolkitwork.txt' -InputObject "Temporary Install"

function Send-PSEmail($Subject,$Body,[string[]]$attachments)
{
    $MailMessage = @{
        From = "toolkit@wwcs.com"
        To = "toolkit@wwcs.com"
        Subject = $Subject
        Body = $Body
        Smtpserver = "smtp.office365.com"
        Port = 587
        UseSsl = $true
        Attachments = $attachments
        }
    if($null -eq $attachments)
    {
        $MailMessage = @{
            From = "toolkit@wwcs.com"
            To = "toolkit@wwcs.com"
            Subject = $Subject
            Body = $Body
            Smtpserver = "smtp.office365.com"
            Port = 587
            UseSsl = $true
            }
    }

    $username = "toolkit@wwcs.com"
    $password = ConvertTo-SecureString $pass -AsPlainText -Force
    $credential = New-Object System.Management.Automation.PSCredential ($username, $password)
    Send-MailMessage @MailMessage -Credential $credential
}


$startTime = Get-Date
function Get-TimeSince([switch]$inSeconds)
{
    $currTime = Get-Date
    if($inSeconds)
    {
        return (NEW-TIMESPAN –Start $startTime –End $currTime).Seconds
    }
    return (NEW-TIMESPAN –Start $startTime –End $currTime).ToString("mm'min:'ss'sec'")
}

$eventStr = ""
function Log-Event($eventInfo,[switch] $push, [switch] $logTime)
{
    if($push)
    {
        Out-File "C:\Temp\WWCS-TOOLKIT.log" -InputObject $Global:eventStr #-Append
    }
    else 
    {
        #Write-Host "Time passed: $(Get-TimeSince)"
        #Write-Host $eventInfo
        if($logTime)
        {
            $Global:eventStr += "Time passed: $(Get-TimeSince)`n"
        }
        $Global:eventStr += "$eventInfo`n"
        Write-Host "EVENT STR: ----------------------"
        Write-Host $Global:eventStr
    }
}

Log-Event "Starting ($($startTime))"

$RepositoryZipUrl = "https://github.com/Crimson-Wheeler/WWCSToolkit/archive/main.zip" 
$errors = ""

#region Cleanup 
if(Test-Path 'C:\Windows\system32\WindowsPowerShell\v1.0\Modules\WWCS-TOOLKITnew'){
    Remove-Item 'C:\Windows\system32\WindowsPowerShell\v1.0\Modules\WWCS-TOOLKITnew' -Recurse -Force
}
if(Test-Path 'C:\Windows\system32\WindowsPowerShell\v1.0\Modules\WWCS-TOOLKITold'){
    Remove-Item 'C:\Windows\system32\WindowsPowerShell\v1.0\Modules\WWCS-TOOLKITold' -Recurse -Force
}
if(Test-Path 'C:\Windows\system32\WindowsPowerShell\v1.0\Modules\WWCSToolKit-main'){
    Remove-Item 'C:\Windows\system32\WindowsPowerShell\v1.0\Modules\WWCSToolKit-main' -Recurse -Force
}
if(Test-Path 'C:\Temp\WWCSToolKit-main'){
    Remove-Item  'C:\Temp\WWCSToolKit-main' -Recurse -Force
}
if(Test-Path 'C:\Temp\wwcstoolkit'){
    Remove-Item  'C:\Temp\wwcstoolkit' -Recurse -Force
}
if(Test-Path 'C:\Temp\.zip'){
    Remove-Item 'C:\Temp\.zip' -Recurse -Force
}
if(Test-Path 'C:\Temp\wwcstoolkit.zip'){
    Remove-Item 'C:\Temp\wwcstoolkit.zip' -Recurse -Force
}
#endregion

#region downloading 
#download the zip 
Log-Event 'Starting downloading the GitHub Repository' -logTime

#sets a temporary 
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-RestMethod -Uri $RepositoryZipUrl -OutFile 'C:\Temp\wwcstoolkit.zip'

#extract to toolkit
Log-Event 'Extract Toolkit Folder'
if(Test-Path 'C:\Temp\wwcstoolkit.zip')
{
    Expand-Archive -Path 'C:\Temp\wwcstoolkit.zip' -DestinationPath 'C:\Temp\wwcstoolkit'
    #Add-Type -assembly "system.io.compression.filesystem"
    #[io.compression.zipfile]::CreateFromDirectory('C:\Temp\wwcstoolkit.zip', 'C:\Temp\wwcstoolkit')
}
else
{
    $errors += "ERROR: Zip File Failed to Download.`n"
}




if(Test-Path 'C:\Temp\wwcstoolkit\WWCSToolKit-main')
{
    Copy-Item 'C:\Temp\wwcstoolkit\WWCSToolKit-main' -Destination 'C:\Windows\system32\WindowsPowerShell\v1.0\Modules\WWCS-TOOLKITnew' -Recurse -Force
}
else
{
    $errors += "ERROR: Zip Extraction Failed.`n"
}
#endregion

#region Renaming and Deleting old toolkit
if(Test-Path -Path "C:\Windows\system32\WindowsPowerShell\v1.0\Modules\WWCS-TOOLKIT")
{
    Rename-Item -Path "C:\Windows\system32\WindowsPowerShell\v1.0\Modules\WWCS-TOOLKIT" `
                -NewName "C:\Windows\system32\WindowsPowerShell\v1.0\Modules\WWCS-TOOLKITold"
}
if(Test-Path -Path "C:\Windows\system32\WindowsPowerShell\v1.0\Modules\WWCS-TOOLKITnew")
{
    Rename-Item -Path "C:\Windows\system32\WindowsPowerShell\v1.0\Modules\WWCS-TOOLKITnew" `
                -NewName "C:\Windows\system32\WindowsPowerShell\v1.0\Modules\WWCS-TOOLKIT"
}
else
{
    $errors += "ERROR: Failed to Copy Toolkit to Module Path.`n"
}
if(Test-Path -Path "C:\Windows\system32\WindowsPowerShell\v1.0\Modules\WWCS-TOOLKITold")
{
    Remove-Item "C:\Windows\system32\WindowsPowerShell\v1.0\Modules\WWCS-TOOLKITold" -Recurse -Force
}
#endregion

#region Move Programs and Data, Create Directories
if(-not(Test-Path "C:\Program Files\WWCS"))
{
    New-Item -Path "C:\Program Files\WWCS" -ItemType "directory"
}  

if(Test-Path "C:\Program Files\WWCS")
{
    if(Test-Path 'C:\Program Files\WWCS\DataControl')
    {
        Remove-Item 'C:\Program Files\WWCS\DataControl' -Recurse
    }
    Copy-Item 'C:\Windows\system32\WindowsPowerShell\v1.0\Modules\WWCS-TOOLKIT\DataControl' `
                'C:\Program Files\WWCS\DataControl' -Recurse -Force
}  
if(Test-Path "C:\Program Files\WWCS")
{
    if(Test-Path 'C:\Program Files\WWCS\Images')
    {
        Remove-Item 'C:\Program Files\WWCS\Images' -Recurse
    }
    Copy-Item 'C:\Windows\system32\WindowsPowerShell\v1.0\Modules\WWCS-TOOLKIT\Images' `
                'C:\Program Files\WWCS\Images' -Recurse -Force
}  
if(Test-Path "C:\Program Files\WWCS")
{
    if(Test-Path 'C:\Program Files\WWCS\Programs')
    {
        Remove-Item 'C:\Program Files\WWCS\Programs' -Recurse
    }
    Copy-Item 'C:\Windows\system32\WindowsPowerShell\v1.0\Modules\WWCS-TOOLKIT\Programs' `
                'C:\Program Files\WWCS\Programs' -Recurse -Force
}
else
{
    $errors += "ERROR: WWCS Directory Does not exist.`n"
}





if(Test-Path 'C:\Program Files\WWCS\Programs')
{
    Remove-Item 'C:\Windows\system32\WindowsPowerShell\v1.0\Modules\WWCS-TOOLKIT\Programs' -Recurse
}
else
{
    $errors += "ERROR: Programs Folder Failed.`n"
}
if(Test-Path 'C:\Program Files\WWCS\DataControl')
{
    Remove-Item 'C:\Windows\system32\WindowsPowerShell\v1.0\Modules\WWCS-TOOLKIT\DataControl' -Recurse
}
else
{
    $errors += "ERROR: Data Control Folder Failed.`n"
}
if(Test-Path 'C:\Program Files\WWCS\Images')
{
    Remove-Item 'C:\Windows\system32\WindowsPowerShell\v1.0\Modules\WWCS-TOOLKIT\Images' -Recurse
}
else
{
    $errors += "ERROR: Images Folder Failed.`n"
}
#endregion

#region Cleaup Again
if(Test-Path 'C:\Windows\system32\WindowsPowerShell\v1.0\Modules\WWCS-TOOLKITnew'){
    Remove-Item 'C:\Windows\system32\WindowsPowerShell\v1.0\Modules\WWCS-TOOLKITnew' -Recurse -Force
}
if(Test-Path 'C:\Windows\system32\WindowsPowerShell\v1.0\Modules\WWCS-TOOLKITold'){
    Remove-Item 'C:\Windows\system32\WindowsPowerShell\v1.0\Modules\WWCS-TOOLKITold' -Recurse -Force
}
if(Test-Path 'C:\Windows\system32\WindowsPowerShell\v1.0\Modules\WWCSToolKit-main'){
    Remove-Item 'C:\Windows\system32\WindowsPowerShell\v1.0\Modules\WWCSToolKit-main' -Recurse -Force
}
if(Test-Path 'C:\Temp\WWCSToolKit-main'){
    Remove-Item  'C:\Temp\WWCSToolKit-main' -Recurse -Force
}
if(Test-Path 'C:\Temp\wwcstoolkit'){
    Remove-Item  'C:\Temp\wwcstoolkit' -Recurse -Force
}
if(Test-Path 'C:\Temp\.zip'){
    Remove-Item 'C:\Temp\.zip' -Recurse -Force
}
if(Test-Path 'C:\Temp\wwcstoolkit.zip'){
    Remove-Item 'C:\Temp\wwcstoolkit.zip' -Recurse -Force
}
#endregion


Log-Event "Finishing Toolkit Install." -logTime

if($errors.Length -gt 0)
{
    if((Test-Path "C:\Temp\WWCS-TOOLKIT.log") -and (Get-Module WWCS-TOOLKIT).length -gt 0)
    {
        $body = ""
        $lastLog = Get-Content "C:\Temp\WWCS-TOOLKIT.log"
        if($lastLog.Contains("SUCCESS"))
        {
            $body += "SWITCHED TO FAILED"
            $body += "`n"
        }
 
        
        $body += $errors
        Import-Module WWCS-TOOLKIT 
        Send-PSEmail -Subject "WWCS Toolkit switched to failed on $($env:COMPUTERNAME) at $($env:USERDOMAIN)" `
                    -Body $body `
                    -attachments @('C:\Temp\WWCS-TOOLKIT.log')
    }
    Write-Host $errors

    Log-Event $errors -logTime
}
else 
{
    Log-Event "SUCCESS: WWCS-TOOLKIT is Up to date" -logTime
}

$timeInSeconds = Get-TimeSince -inSeconds
Write-Host "Time: $($timeInSeconds)."
if(Get-TimeSince -inSeconds -ge 180)
{
    Write-Host "Time greater than 180 it took $($timeInSeconds)."
    
    Send-PSEmail -Subject "WWCS Toolkit took too long to install on $($env:COMPUTERNAME) at $($env:USERDOMAIN)" `
                -Body "Took $($timeInSeconds) to finish install script."
            
}

if(Test-Path 'C:\Temp\WWCS-TOOLKIT.log')
{
    Remove-Item 'C:\Temp\WWCS-TOOLKIT.log'
}


if(Test-Path 'C:\Temp\toolkitwork.txt')
{
    Remove-Item 'C:\Temp\toolkitwork.txt'
}

Write-Host "EVENT INFO -----------------"
Write-Host $Global:eventStr
Log-Event -push





