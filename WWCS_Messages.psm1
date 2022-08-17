function Send-PSEmail($Password,$Subject,$Body,[string[]]$attachments)
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
    $pass = ConvertTo-SecureString $Password -AsPlainText -Force
    
    $credential = New-Object System.Management.Automation.PSCredential ($username, $pass)
    
    
    Send-MailMessage @MailMessage -Credential $credential
}

function Send-Notification([string] $Title,[string]$Message)
{
    #Closes current notification and creates a new process for another notification
    Get-Process *NotificationWindow* | Stop-Process -Force
    New-Process "C:\Program Files\WWCS\Programs\NotificationWindow.exe" -Argument "`"$($Title)`" `"$($Message)`""
}

function Send-UptimeNotification($threshold)
{

    #calculate how long the computer has been on for
    $bootuptime = (Get-CimInstance -ClassName Win32_OperatingSystem).LastBootUpTime
    $CurrentDate = Get-Date
    $uptime = $CurrentDate - $bootuptime

    #if the computer has been on longer than the given value than send the notification
    if($uptime.Days -gt $threshold)
    {
        Send-Notification "Message from WWCS..." "Your computer has not been restarted in $($uptime.Days) days. `
        if you do not reboot your computer, then it has a higher chance of experiancing errors."

    }
}

