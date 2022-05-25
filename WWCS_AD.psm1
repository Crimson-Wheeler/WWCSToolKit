function Get-ADInfo()
{
    echo "This is a test to the active directory."
}

function Create-ADUser()
{
    
}

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

function Set-DomainUserCredentials($username, $password)
{
    try
    {
        
        $var = cmdkey /list

        [bool]$domainJoined = $env:USERDOMAIN -ne $env:COMPUTERNAME

        for (($i = 0); $i -lt $var.Count; $i++)
        {
            [String]$line = [String]$var[$i]

            [String]$condition = "User:"
    
            if($line.Contains($condition) -and $line.Substring($line.IndexOf($condition) + $condition.Length+1).Contains($username))
            {
                    $user = $line.Substring($line.IndexOf($condition) + $condition.Length+1)
                    [String]$computer = $var[$i-2]
                    $computer = $computer.Substring($computer.IndexOf("=")+1)

                    if($domainJoined -and -not $user.Contains($env:USERDOMAIN))
                    {
                        cmdkey /add:$computer /user:$user /pass:$password
                    }
            }
    
        }
    }
    catch
    {
        Send-Email -Subject "ERROR: THERE WAS A POWERSHELL ERROR" -Body "ERROR on $($env:COMPUTERNAME): $($Error)"
    }
}
