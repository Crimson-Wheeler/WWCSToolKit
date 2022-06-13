function Get-AppChangesLog($EmailPassword)
{
    [string]$appChangeLog = "APP CHANGES LOG"
    
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