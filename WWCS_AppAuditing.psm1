#Emails the toolkit shared mailbox the latest app changes log
function Get-AppChangesLog($EmailPassword)
{
    [string]$appChangeLog = "APP CHANGES LOG"

    #check if the log file exists
    if(Test-Path -Path "C:\Program Files\WWCS\Logs\Auditing\ApplicationAuditLogs\AppChanges.log")
    {
        $appChangeLog += "`n"
        $appChangeLog += Get-Content -Path "C:\Program Files\WWCS\Logs\Auditing\ApplicationAuditLogs\AppChanges.log"


        Send-PSEmail -Password $EmailPassword `
                        -Subject "App changes from $($env:COMPUTERNAME) at $($env:USERDOMAIN)"
                        -Body $appChangeLog
                        -attachments @("C:\Program Files\WWCS\Logs\Auditing\ApplicationAuditLogs\AppChanges.log")
    }
    else
    {
        Send-PSEmail -Password $EmailPassword `
                    -Subject "App changes cannot be found for $($env:COMPUTERNAME) at $($env:USERDOMAIN)"
                    -Body "THE APP CHANGES LOG CANNOT BE FOUND"
    }
}


#Runs the applicaiton auditing exe file
function Get-ApplicationDifferences($Password)
{
    &"C:\Program Files\WWCS\Programs\Application Auditing.exe '$($Password)'"
}