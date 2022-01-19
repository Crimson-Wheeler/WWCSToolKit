function Get-ParentOutputDir
{
    $auditingPath = "$(Get-WWCSLogPath)\Auditing"
    if(-not (Test-Path -Path $auditingPath))
    {
        New-Item -Path $auditingPath -ItemType directory
    }
    return $auditingPath
}
function Log($line, $path = $null)
{
    if($null -eq $path){$path = Get-ParentOutputDir}
    if(-not (Test-Path -Path $path))
    {
        New-Item -Path $path -ItemType directory
    }
    Out-File -FilePath "$($path)\LogonAudit.log" -InputObject $line -Append
}

function Convert-LogonType($val)
{
    Switch ($val) {
        2 {return "Interactive (logon at keyboard and screen of system)"} 
        3 {return "Network (i.e. connection to shared folder on this computer from elsewhere on network)"} 
        4 {return "Batch (i.e. scheduled task)"} 
        5 {return "Service (Service startup)"} 
        7 {return "Unlock (i.e. unnattended workstation with password protected screen saver)"} 
        8 {return "NetworkCleartext (Logon with credentials sent in the clear text. Most often indicates a logon to IIS with basic authentication)"} 
        9 {return "NewCredentials such as with RunAs or mapping a network drive with alternate credentials."} 
        10 {return "RemoteInteractive (Terminal Services, Remote Desktop or Remote Assistance)"} 
        11 {return "CachedInteractive (logon with cached domain credentials such as when logging on to a laptop when away from the network)"} 
        Default {return "($($val)) N/A"}
    }
}

function Get-SuccessfulLogonEvents ($computer, $OutputPath,$numOfEvents = 100, [switch]$findDir)
{
    if($findDir)
    {
        Add-Type -AssemblyName System.Windows.Forms
        $browser = New-Object System.Windows.Forms.FolderBrowserDialog
        #$browser.initialDirectory = "C:\"
        $null = $browser.ShowDialog((New-Object System.Windows.Forms.Form -Property @{TopMost = $true; TopLevel = $true}))
        $OutputPath = $browser.SelectedPath
    }


    $winEvent = Get-WinEvent -ComputerName $computer.Name -Logname 'security' -MaxEvents $numOfEvents -FilterXPath '*[System[EventID=4624]]' 
    
    foreach ($event in $winEvent){            
        $auditEvent = [PSCustomObject]@{
            LogonType =  "$(Convert-LogonType $event.Properties[8].Value.ToString())"
            Username = "$($event.Properties[6].Value)\$($event.Properties[5].Value)"
            ComputerName = $computer.Name
            LogonTime = $event.TimeCreated
            SourceAddress = "$($event.Properties[18].Value):$($event.Properties[19].Value)"
            ID = $event.Id
        }

        Log "$($auditEvent.Username) -- $($auditEvent.LogonTime)"
        Export-Csv -InputObject $auditEvent -Path $OutputPath -Append
    } 
}

function Get-ADComputerLogonEvents(){
    $computers = Get-ADComputer -Filter * -Properties Name,LastLogonDate | Select-Object Name,LastLogonDate
    Log "Testing $($computers.Count) computers"
    Log "Domain Computers ---------------------------------"
    Log ($computers | Format-Table)
    Log "End Domain Computers"

    foreach ($computer in $computers)
    {
        if($null -eq $computer.LastLogonDate){continue}
        if(((Get-Date) - $computer.LastLogonDate.Date).days -gt 30) {continue}
        Log "Gathering events for $($computer.Name)----------------------------------------------"
        Get-SuccessfulLogonEvents $computer Get-ParentOutputDir
    }

}




<#




foreach ($item in $event.Properties) {
                Write-Host "VALUE: "$item.Value
            }








#>


<#
function Get-LogonType([System.Diagnostics.Eventing.Reader.EventLogRecord]$winEventObj)
{
    [string]$description = $winEventObj.
    $index = $description.IndexOf("Account For Which")
    $description = $description.Substring($index -5, $index)
    Write-Host "DESK " $description "END DEKS"
}


function CreateSuccessEventObj([System.Diagnostics.Eventing.Reader.EventLogRecord]$winEventObj)
{
    $customWinEvent = [PSCustomObject]@{
        ComputerName = $winEventObj.MachineName
        CompletionType = "Success"
        LogonType = $winEventObj.Properties[8].Value #8 for success 10 for failed
        LogonFrom =  $winEventObj.Properties[11].Value
        TimeStampt = $winEventObj.TimeCreated
    }
    if($customWinEvent.LogonFrom -eq "-") 
    {
        $customWinEvent.LogonFrom = $env:COMPUTERNAME
    }
    return $customWinEvent
}
function CreateFailedEventObj([System.Diagnostics.Eventing.Reader.EventLogRecord]$winEventObj)
{
    $customWinEvent = [PSCustomObject]@{
        ComputerName = $winEventObj.MachineName
        CompletionType = "Failed"
        LogonType = $winEventObj.Properties[10].Value #8 for success 10 for failed
        LogonFrom = $winEventObj.Properties[13].Value
        TimeStampt = $winEventObj.TimeCreated
    }

    return $customWinEvent
}

function Get-SuccessLogons([int]$count = 0)
{
   if($count -ne 0)
   {
   return Get-WinEvent -ComputerName "TECH-NUC" -Logname 'security' -MaxEvents $count -FilterXPath '*[System[EventID=4624]]'
   }
   return [System.Collections.ArrayList]@()
}
function Get-FailedLogons([int]$count = 0)
{
   if($count -ne 0)
   {
   return Get-WinEvent -ComputerName "TECH-NUC" -Logname 'security' -MaxEvents $count -FilterXPath '*[System[EventID=4625]]'
   }
   return [System.Collections.ArrayList]@()
}
function Get-WWCSLogons($succesCount = 0, $failedCount = 0)
{   
    $successEvents = Get-SuccessLogons -count $successCount
    $failedEvents = Get-FailedLogons -count $failedCount
    
    $events = [System.Collections.ArrayList]@()
    foreach($event in $successEvents)
    {
        $obj = CreateSuccessEventObj -winEventObj $event
        $events.Add($obj)
    }
    foreach($event in $failedEvents)
    {
        $obj = CreateFailedEventObj -winEventObj $event
        $events.Add($obj)
    }
   
    
    return $events
}
function Write-WWCSLogons($succesCount = 0, $failedCount = 0, $path = "C:\Temp\output.csv")
{   
    $successEvents = Get-SuccessLogons -count $successCount
    $failedEvents = Get-FailedLogons -count $failedCount

    $events = [System.Collections.ArrayList]@()
    foreach($event in $successEvents)
    {
        $obj = CreateSuccessEventObj -winEventObj $event
        $events.Add($obj)
    }
    foreach($event in $failedEvents)
    {
        $obj = CreateFailedEventObj -winEventObj $event
        $events.Add($obj)
    }
   
    if(Test-Path -Path $path)
    {
        Remove-Item -Path $path -Recurse -Force
    }
    foreach($event in $events)
    {
       
    }
    return $events
}

function Get-WWCSFailedLogonAudit($count,$timeCap,$logPath)
{
    $failedEvents = Get-FailedLogons -count $count
    [DateTime]$startTime = $failedEvents[0].TimeStamp
    [DateTime]$endTime = $failedEvents[$failedEvents.Cout -1].TimeStamp

    Write-Host $startTime " - " $endTime
    if($logPath -eq $null)
    {
        
    }
    else
    {
        
    }
}
#>
