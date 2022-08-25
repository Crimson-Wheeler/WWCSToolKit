
function Get-WWCSLogPath()
{
    #Check to see if log path exists, creates it if it doesn'tt
    if(-not (Test-Path -Path "C:\Program Files\WWCS\Logs"))
    {
        New-Item -Path "C:\Program Files\WWCS\Logs" -ItemType directory
    }
    return "C:\Program Files\WWCS\Logs"
}


function Write-LogError($message)
{
    #Gets the log path
    $logPath = Get-WWCSLogPath
    $fileName = "error.log"

    #Creates a error log if it does not exists
    if(-not(Test-Path -Path $logPath))
    {
        New-Item -Path $logPath
    }
    $message >> "$($logPath)\$($fileName)"
}
function Write-Log([string]$message,$rootPath,$path,[switch]$Append)
{
    # if the path has a value overwrite the log path
    $logPath = "$(Get-WWCSLogPath)\$($rootPath)"
    if($null -ne $path)
    {
        $logPath = $path
    }

    $logPath = 'C:\Program Files\WWCS\Logs\Temp\error.txt'
    write-host $logpath
    $testString = $logPath.SubString(0,$logPath.LastIndexOf('\'))
    Write-Host $testString
    
    if(-not(Test-Path -Path $testString))
    {
        New-Item -path $testString -ItemType Directory 
    }

    #Create log if it doesn't exist
    if(-not(Test-Path -Path $logPath))
    {
        New-Item -Path $logPath
    }

    #Chooses to overwrite or append file
    if($Append){
        Out-File -FilePath $logPath -InputObject $message -Append
    }
    else {
        Out-File -FilePath $logPath -InputObject $message
    }


}

