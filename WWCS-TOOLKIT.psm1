function Get-WWCSTOOLKITPath
{
    return "C:\Windows\system32\WindowsPowerShell\v1.0\Modules\WWCS-TOOLKIT"
}
fucntion Get-WWCSDataPath
{
    return "C:\Users\$($env:USERNAME)\AppData\Local\WWCS\ClipboardFiles"
}
function test()
{
    echo "This is a test to test the testing test"
}

function logError($message)
{
    $logPath = "C:\temp\wwcsLogs"
    $fileName = "errorLog.txt"
    if(Test-Path -Path $logPath)
    {

    }
    else
    {
        mkdir C:\temp\wwcsLogs
    }
    $message >> "$($logPath)\$($fileName)"
}

function Send-Email($From,$Subject,$Body)
{
    try
    {
        $EmailFrom = “Reports@wwcs.com”
        $EmailTo = “helpdesk@wwcs.com”
        if($From -ne $null) {$EmailFrom = $From}
   

        $SMTPServer = “wwcs-com.mail.protection.outlook.com”
        $SMTPClient = New-Object Net.Mail.SmtpClient($SMTPServer)
        echo "$($Subject) : $($Body)"
        $SMTPClient.Send($EmailFrom, $EmailTo, $Subject, $Body)
    }
    catch
    {
        logError -message $Error
    }
}

function changeLocalUserCredentials($username, $password)
{
    try
    {
        
        $var = cmdkey /list

        [bool]$domainJoined = $env:USERDOMAIN -ne $env:COMPUTERNAME

        for (($i = 0); $i -lt $var.Count; $i++)
        {
            [String]$line = [String]$var[$i]

            [String]$condition = "User:"
    
            if($line.Contains($condition) -and $line.Substring($line.IndexOf($condition) + $condition.Length+1).Contains($username))
            {
                    $user = $line.Substring($line.IndexOf($condition) + $condition.Length+1)
                    [String]$computer = $var[$i-2]
                    $computer = $computer.Substring($computer.IndexOf("=")+1)

                    if($domainJoined -and -not $user.Contains($env:USERDOMAIN))
                    {
                        cmdkey /add:$computer /user:$user /pass:$password
                        #echo "Setting the credential for the user $($username) on $($computer) to $($computer),$($user),$($password)"
                    }
            }
    
        }
    }
    catch
    {
        Send-Email -Subject "ERROR: THERE WAS A POWERSHELL ERROR" -Body "ERROR on $($env:COMPUTERNAME): $($Error)"
    }
}
function New-WWCSComputer()
{
   
    winget install -e --id Google.Chrome --force
    winget install -e --id Adobe.AdobeAcrobatReaderDC --force
    winget install -e --id Oracle.JavaRuntimeEnvironment --force

    invoke-expression -Command "C:\Windows\system32\WindowsPowerShell\v1.0\Modules\WWCS-TOOLKIT\ODT\runODT.ps1"

    
}
function Get-WWCSDocumentation()
{
   
    
    invoke-expression -Command "$(Get-WWCSTOOLKITPath)\showDocumentation.ps1"
}