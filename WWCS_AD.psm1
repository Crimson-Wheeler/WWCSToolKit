function Get-ADInfo()
{
    echo "This is a test to the active directory."
}

function Create-ADUser()
{
    
}

function Get-ADComputersLastLogon()
{
	Get-ADComputer -Filter * -Properties * | Sort LastLogonDate | FT Name, LastLogonDate -AutoSize
}

function Get-LocalUsers()
{
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

}

