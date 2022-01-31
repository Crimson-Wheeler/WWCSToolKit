function Send-Email($From,$Subject,$Body)
{
    try
    {
        $EmailFrom = “Reports@wwcs.com”
        $EmailTo = “helpdesk@wwcs.com”
        if($null -ne $From) {$EmailFrom = $From}
   

        $SMTPServer = “wwcs-com.mail.protection.outlook.com”
        $SMTPClient = New-Object Net.Mail.SmtpClient($SMTPServer)
        Write-Output "$($Subject) : $($Body)"
        $SMTPClient.Send($EmailFrom, $EmailTo, $Subject, $Body)
    }
    catch
    {
        logError -message $Error
    }
}