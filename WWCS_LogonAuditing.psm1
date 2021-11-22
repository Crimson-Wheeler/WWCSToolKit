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
    }

    return $customWinEvent
}


function Get-WWCSLogons($maxEvents)
{   
    $successEvents = Get-WinEvent -ComputerName "TECH-NUC" -Logname 'security' -MaxEvents ($maxEvents/2) -FilterXPath '*[System[EventID=4624]]'
    $failedEvents = Get-WinEvent -ComputerName "TECH-NUC" -Logname 'security' -MaxEvents ($maxEvents/2) -FilterXPath '*[System[EventID=4625]]'
    
    $events = [System.Collections.ArrayList]@()
    Write-Host ""
    Write-Host "Success ------------------------------"
    Write-Host $(CreateSuccessEventObj -winEventObj $successEvents[0])
    foreach($event in $successEvents)
    {
        $obj = CreateSuccessEventObj -winEventObj $event
        Write-Host $obj
        $events.Add($obj)
    }
    Write-Host ""
    Write-Host "Failed ------------------------------"
    foreach($event in $failedEvents)
    {
        $obj = CreateFailedEventObj -winEventObj $event
        Write-Host $obj
        $events.Add($obj)
    }
   
    
    
}



Get-WWCSLogons -MaxEvents 100
