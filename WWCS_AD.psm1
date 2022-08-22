function Get-ADInfo()
{
    echo "This is a test to the active directory."
}

function New-ADUser()
{
    
}

#Gets a list of all the AD Computers and shows their last log on time
function Get-ADComputersLastLogon()
{
	return Get-ADComputer -Filter * -Properties * | Sort LastLogonDate | FT Name, LastLogonDate -AutoSize
}

function Get-LocalUsers()
{
    Write-Host "Function has yet to be implemented."
    <#
    $date = Get-Date
    $computerNames = Get-ADcomputer -Filter * -properties * | `
                    Select-Object -Property name,lastlogondate,Enabled | `
                    Where-Object {($_.Enabled -eq $true) -and ($null -ne $_.LastLogonDate) -and ((New-TimeSpan -Start $_.LastLogonDate -End ($date)).TotalDays -lt 100)} |
                    Sort-Object -Property name

    
    foreach ($i in $computerNames) 
    {
        #Get-Date - $i.LastLogonDate
        invoke-command -ComputerName $i.Name -ScriptBlock {Get-LocalGroupMember -Group "Administrators"}
    }
    
    #invoke-command $_.Name ScriptBlock {Get-LocalGroupMember -Group "Administrators"}
    #>
}


#Sets the credentials for a domain user in windows credential manager

function Set-DomainUserWinCredentials($username, $password)
{
    try
    {
        #gets list of all windows credentials
        $var = cmdkey /list
        
        #determine if domain joined based on if the computer name is the domain, a non-domain joined computer will have its domain as it's name
        [bool]$domainJoined = $env:USERDOMAIN -ne $env:COMPUTERNAME


        for (($i = 0); $i -lt $var.Count; $i++)
        {
            [String]$line = [String]$var[$i]
            [String]$condition = "User:"
    
            #filters each line of the cmdkey output
            #only look at lines that contain the condition value
            #only look at lines that contain the username directly after the condition value
            if($line.Contains($condition) -and $line.Substring($line.IndexOf($condition) + $condition.Length+1).Contains($username))
            {
                    #grab the username by getting the substring of the line after the condition
                    $user = $line.Substring($line.IndexOf($condition) + $condition.Length+1)

                    #grab the computer name because it is two lines previous to the username of a saved credential
                    [String]$computer = $var[$i-2]

                    #remove junk text at the beginning of the line, computer name is always after the first = sign
                    $computer = $computer.Substring($computer.IndexOf("=")+1)

                    #Continues if the computer is domain joined
                    #Continues if username does not contain the domain name
                    #overwrites or adds the specified credential
                    if($domainJoined -and -not $user.Contains($env:USERDOMAIN))
                    {
                        cmdkey /add:$computer /user:$user /pass:$password
                    }
            }
    
        }
    }
    catch 
    {
        #if there was an error, send an email with the details
        Send-Email -Subject "ERROR: THERE WAS A POWERSHELL ERROR" -Body "ERROR on $($env:COMPUTERNAME): $($Error)"
    }
}
