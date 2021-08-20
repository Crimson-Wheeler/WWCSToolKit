clear

function Send-Email($Subject,$Body)
{
    $EmailFrom = “Reports@wwcs.com”
    $EmailTo = “helpdesk@wwcs.com”
   

    $SMTPServer = “wwcs-com.mail.protection.outlook.com”
    $SMTPClient = New-Object Net.Mail.SmtpClient($SMTPServer)
    $SMTPClient.Send($EmailFrom, $EmailTo, $Subject, $Body)
}

function Set-User($username, $password, $IsAdmin = $false)
{
    $alertSubject = "ALERT: Failure to Create New User"
    $alertBody = "Failed to create a new user $($username) on the computer $($env:COMPUTERNAME)"
    [bool]$sendEmail = $false

    $user = Get-LocalUser | Where-Object {$_.Name -eq $username}

    if($user)
    {
        $user | Set-LocalUser -Password $password -PasswordNeverExpires $true
    }
    else
    {
        #New-LocalUser -Name $username -Password $password -PasswordNeverExpires $true
        Net User $username $password /add
        $alertSubject = "ALERT: New User Created"
        $alertBody = "Created a new user $($username) on the computer $($env:COMPUTERNAME)"
        $sendEmail = $true
    }

    $user = Get-LocalUser | Where-Object {$_.Name -eq $username}
    if(-not $user)
    {
        $alertSubject = "ALERT: Failure to Create New User"
        $alertBody = "Failed to create a new user $($username) on the computer $($env:COMPUTERNAME)"
        $sendEmail = $true
    }


    if($sendEmail)
    {
        Send-Email -Subject $alertSubject -Body $alertBody
    }

}

Set-User -username "wwcsadmin02" -password "Qwertyui"


