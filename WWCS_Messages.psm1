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
function Send-Email($Subject,$Body, $attachments)
{
    Write-Host "Subject: $subject"
    Write-Host "Body: $body"
    Write-Host "Attachments: $attachments"
    Write-Host "Arguments---"
    Write-Host "`"$from`" `"$to`" `"$Subject`" `"$Body`" $attachments" 
    #cd 'C:\Program Files\WWCS\Programs\'
    &"C:\Program Files\WWCS\Programs\EmailSender.exe" `"$Subject`" `"$Body`" $attachments 
}

