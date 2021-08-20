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