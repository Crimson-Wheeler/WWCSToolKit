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
    New-Process “C:\Program Files\WWCS\Programs\NotificationWindow.exe" -ArgumentList @($Title,$Message)
}

