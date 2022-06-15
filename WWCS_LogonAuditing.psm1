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
    Write-Host "$line being sent to $path"
    Out-File -FilePath "$path\LogonAudit.log" -InputObject $line -Append
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
function Get-LogonEvent($computerName, 
                        $OutputPath,
                        $numOfEvents, 
                        $eventID, 
                        $LogonTypeIndex, 
                        $DomainIndex, 
                        $UsernameIndex, 
                        $SourceAddressIndex, 
                        $SourcePortIndex, 
                        [switch]$listPropertyIndexes)
{
    if(-not $computerName){$computerName = $env:COMPUTERNAME}

    if($listPropertyIndexes)
    {
        $tempWinEvent = Get-WinEvent -ComputerName $computerName -Logname 'security' -MaxEvents 1 -FilterXPath "*[System[EventID=$eventID]]"
        foreach ($event in $tempWinEvent) {
            Write-Host $event.Message
            Write-Host "___________________________________________________________________"
            for ($i = 0; $i -lt $event.Properties.Count; $i++) {
                Write-Host "($($i)) $($event.Properties[$i].Value)"
            }
        }
        return
    }


    $winEvent = Get-WinEvent -ComputerName $computerName -Logname 'security' -MaxEvents $numOfEvents -FilterXPath "*[System[EventID=$eventID]]" 
    foreach ($event in $winEvent){            
        $auditEvent = [PSCustomObject]@{
            LogonType =  "$(Convert-LogonType $event.Properties[$LogonTypeIndex].Value.ToString())"
            Username = "$($event.Properties[$DomainIndex].Value)\$($event.Properties[$UsernameIndex].Value)"
            ComputerName = $computerName
            LogonTime = $event.TimeCreated
            SourceAddress = "$($event.Properties[$SourceAddressIndex].Value):$($event.Properties[$SourcePortIndex].Value)"
            ID = $event.Id
        }
        Log "$($auditEvent.Username) -- $($auditEvent.LogonTime)"
        Export-Csv -InputObject $auditEvent -Path "$OutputPath\$computerName-LogonEvents.csv" -Append
    }
}
function Get-SuccessfulLogonEvents ($computerName, $OutputPath = "C:\temp",$numOfEvents = 100, [switch]$findDir)
{
    if($findDir){$OutputPath = Get-Directory}
    Get-LogonEvent $computerName $OutputPath $numOfEvents -eventID "4624" -LogonTypeIndex 8 -DomainIndex 6 -UsernameIndex 5 -SourceAddressIndex 18 -SourcePortIndex 19
}

function Get-FailedLogonEvents ($computerName, $OutputPath = "C:\temp",$numOfEvents = 100, [switch]$findDir)
{
    if($findDir){$OutputPath = Get-Directory}
    Get-LogonEvent $computerName $OutputPath $numOfEvents -eventID "4624" -LogonTypeIndex 10 -DomainIndex 6 -UsernameIndex 5 -SourceAddressIndex 19 -SourcePortIndex 20
}
function Get-LogoffEvents ($computerName, $OutputPath = "C:\temp",$numOfEvents = 100, [switch]$findDir)
{
    if($findDir){$OutputPath = Get-Directory}
    Get-LogonEvent $computerName $OutputPath $numOfEvents -eventID "4634" -LogonTypeIndex 4 -DomainIndex 2 -UsernameIndex 1
}

function Get-EventIDProperties([int]$eventID)
{
    Write-Host (Get-LogonEvent $env:COMPUTERNAME -eventID $eventID -listPropertyIndexes)
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
        Get-ADComputerLogonEvents -computerName
    }
}
function Get-ADComputerLogonEvents($computerName)
{
    Get-SuccessfulLogonEvents $computer Get-ParentOutputDir
    Get-FailedLogonEvents $computer Get-ParentOutputDir
    Get-LogoffEvents $computer Get-ParentOutputDir
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
