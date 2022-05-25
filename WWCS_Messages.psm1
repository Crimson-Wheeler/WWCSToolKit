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
function Send-Email($Subject,$Body, $attachments)
{
    $to = "toolkit@wwcs.com"
    $from = "toolkit@wwcs.com"
    Write-Host "Sending to: $to"
    Write-Host "Sending from: $from"
    Write-Host "Subject: $subject"
    Write-Host "Body: $body"
    Write-Host "Attachments: $attachments"
    Write-Host "Arguments---"
    Write-Host "`"$from`" `"$to`" `"$Subject`" `"$Body`" $attachments" 
    #cd 'C:\Program Files\WWCS\Programs\'
    &"C:\Program Files\WWCS\Programs\EmailSender.exe" `"$from`" `"$to`" `"$Subject`" `"$Body`" $attachments 
}

