cls



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
        "$($event.ComputerName),$($event.CompletionType),$($event.LogonType),$($event.LogonFrom),$($event.TimeStampt)," | Export-Csv -Path $path -Append
    }
    return $events
}

