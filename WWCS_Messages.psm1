function SSend-Email($From,$Subject,$Body)
{
    try
    {
        if($null -eq $null){$From = "WWCSToolkit@wwcs.com"}

        $mailParams = @{
            SmtpServer                 = 'wwcs-com.mail.protection.outlook.com'
            Port                       = '25' #'587' or '25' if not using TLS
            UseSSL                     = $true ## or not if using non-TLS
            From                       = $From
            To                         = "helpdesk@wwcs.com"
            Subject                    = $Subject
            Body                       = $Body
            DeliveryNotificationOption = 'OnFailure', 'OnSuccess'
        }
    
        ## Send the message
        Send-MailMessage @mailParams
    }
    catch
    {
        Write-LogError -message $Error
        Write-Host $Error
    }
}
function Send-Email($From, $to,$Subject,$Body, $attachments)
{
    Write-Host "Sending to: $to"
    Write-Host "Sending from: $from"
    Write-Host "Subject: $subject"
    Write-Host "Body: $body"
    Write-Host "Attachments: $attachments"
    Write-Host "Arguments---"
    Write-Host "$From $to $Subject $Body $attachments" 
    Start-Process -FilePath "C:\Program Files\WWCS\Programs\EmailSender.exe" `
                 -ArgumentList "`"$From`" `"$to`" `"$Subject`" `"$Body`" $attachments" 
}

