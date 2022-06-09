if(Test-Path 'C:\Temp\toolkitwork.txt')
{
    Exit
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
    $username = "toolkit@wwcs.com"
    $password = ConvertTo-SecureString "authMailbx2022!" -AsPlainText -Force
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
function Log-Event($eventInfo)
{
    Write-Host "Time passed: $(Get-TimeSince)"
    Write-Host $eventInfo
    Out-File "C:\Temp\WWCS-TOOLKIT.log" -InputObject "Time passed: $(Get-TimeSince)" -Append
    Out-File "C:\Temp\WWCS-TOOLKIT.log" -InputObject $eventInfo -Append
}

Out-File "C:\Temp\WWCS-TOOLKIT.log" -InputObject "Starting ($($startTime))" -Append

$logPath = "C:\Program Files\WWCS\Logs"
$dataPath = "C:\Program Files\WWCS\DataControl"
$programPaths = "C:\Program Files\WWCS\Programs"
$fileName = "WWCS-TOOLKIT.log"
$tempPath = "C:\Temp"
$modulePath =  "C:\Windows\system32\WindowsPowerShell\v1.0\Modules"
$RepositoryZipUrl = "https://github.com/Crimson-Wheeler/WWCSToolkit/archive/main.zip" 

$errors = ""

#region Cleaup 
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
if(Test-Path 'C:\Temp\WWCS-TOOLKIT.log'){
    Remove-Item 'C:\Temp\WWCS-TOOLKIT.log'
}
#endregion

#region downloading 
#download the zip 
Log-Event 'Starting downloading the GitHub Repository'

#sets a temporary 
[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
Invoke-RestMethod -Uri $RepositoryZipUrl -OutFile 'C:\Temp\wwcstoolkit.zip'

#extract to toolkit
Log-Event 'Extract Folder'
if(Test-Path 'C:\Temp\wwcstoolkit.zip')
{
    Expand-Archive -Path 'C:\Temp\wwcstoolkit.zip' -DestinationPath 'C:\Temp\wwcstoolkit'
}
else
{
    $errors += "ERROR: Zip File Failed to Download.`n"
    Add-Type -assembly "system.io.compression.filesystem"
    [io.compression.zipfile]::CreateFromDirectory('C:\Temp\wwcstoolkit.zip', 'C:\Temp\wwcstoolkit')
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


Log-Event "Finishing Toolkit Install."

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

    Out-File "C:\Temp\WWCS-TOOLKIT.log" -InputObject $errors -Append
}
else 
{
    Out-File "C:\Temp\WWCS-TOOLKIT.log" -InputObject "SUCCESS: WWCS-TOOLKIT is Up to date" -Append
}

<#
Write-Host "Testing Time Since $(Get-TimeSince -inSeconds)."
if(Get-TimeSince -inSeconds -ge 60)
{
    Write-Host "Time greater than 60 $(Get-TimeSince -inSeconds)."
    Send-Email -Subject "WWCS Toolkit took too long to install on $($env:COMPUTERNAME) at $($env:USERDOMAIN)" `
                -Body "Took $(Get-TimeSince) to finish install script."

}
#>


if(Test-Path 'C:\Temp\toolkitwork.txt')
{
    Remove-Item 'C:\Temp\toolkitwork.txt'
}





