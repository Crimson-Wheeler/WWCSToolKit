param($InputUsername, $InputPassword)


echo net user |findstr /I /R /C:"\<tes\>"




function Send-Email($Subject,$Body)
{
    $EmailFrom = “Reports@wwcs.com”
    $EmailTo = “helpdesk@wwcs.com”
   

    $SMTPServer = “wwcs-com.mail.protection.outlook.com”
    $SMTPClient = New-Object Net.Mail.SmtpClient($SMTPServer)
    echo "$($Subject) : $($Body)"
    $SMTPClient.Send($EmailFrom, $EmailTo, $Subject, $Body)
}

function User-Exists($username)
{
    $objComputer = [ADSI]"WinNT://$($env:COMPUTERNAME)"
    $colUsers = ($objComputer.psbase.children |
        Where-Object {$_.psBase.schemaClassName -eq "User"} |
            Select-Object -expand Name)
    $blnFound = $colUsers -contains $username
    if ($blnFound)
    {  
        return [bool]$true
    }
    else
    {
        return [bool]$false
    }
}

function Set-User($username, $password, $IsAdmin = $false)
{
    try{
        $alertSubject = "ALERT: Failure to Create New User"
        $alertBody = "Failed to create a new user $($username) on the computer $($env:COMPUTERNAME)"
        [bool]$sendEmail = $false


        [bool]$exists = [String](User-Exists -username $username) -contains "true"
        if($exists)
        {
            Net User $username $password /Y
        }
        else
        {
            #New-LocalUser -Name $username -Password $password -PasswordNeverExpires $true
            Net User $username $password /add /Y
            if($IsAdmin){Net localgroup Administrators $username /add}
            $alertSubject = "ALERT: New User Created"
            $alertBody = "Created a new user $($username) on the computer $($env:COMPUTERNAME)"
            $sendEmail = $true

            [bool]$exists = [String](User-Exists -username $username) -contains "true"
            if(-not $exists)
            {
                $alertSubject = "ALERT: Failure to Create New User"
                $alertBody = "Failed to create a new user $($username) on the computer $($env:COMPUTERNAME)"
            }
        }

        if($sendEmail)
        {
            Send-Email -Subject $alertSubject -Body $alertBody
        }
    }catch{   
        Send-Email -Subject "ERROR: THERE WAS A POWERSHELL ERROR" -Body "ERROR on $($env:COMPUTERNAME): $($Error)"
    }
}

Set-User -username "wwcsadmin" -password "Clown!pie!seltzer!"


