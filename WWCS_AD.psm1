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

