

function Get-WWCSCommands()
{
    return Get-Module WWCS-TOOLKIT -ListAvailable | Select-Object -ExpandProperty exportedcommands | Format-Table -Property Value
}



function Get-WWCSReports()
{
    $copyToLoc = "C:\Users\$($env:username)\WorldWide Computer Solutions, Inc\WWCS - Documents\Customers\Reports\Executive Summary\Summary"

    $folders = Get-ChildItem "C:\Users\$($env:username)\WorldWide Computer Solutions, Inc\WWCS - Documents\Customers\Customers - Active" Summary -recurse
    foreach ($folder in $folders) 
    {
        $newestFile = Get-ChildItem $folder.FullName -File | Sort-Object -Descending -Property LastWriteTime | Select-Object -First 1
        Write-Host $newestFile.FullName
        try 
        {
            Copy-Item $newestFile.PSPath $copyToLoc 
        }
        catch
        {
            Write-Host $Error
        }
        
    }

    # foreach ($folder in $folders) 
    # {
    #     #$newestFile = Get-ChildItem $folder -File | Sort-Object -Descending -Property LastWriteTime | Select-Object -First 1
    #     #Write-Host $newestFile.FullName
    #     Write-host $folder.FullName
        
    # }
}

function Invoke-ToolkitTest()
{
    Write-Host "Beginning Test with logging to WWCS log files"
    Write-LogError "This is a test WWCS Log"

    Write-Host "Sending Test email"
    Send-Email -Body "This is a test email from $($env:COMPUTERNAME)" -Subject "This is a test email from $($env:COMPUTERNAME) at $($env:USERDOMAIN)"

}