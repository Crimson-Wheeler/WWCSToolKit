function Get-WWCSUsers ($password ) 
{
    $bodyTxt = "Administrators"
    $path = 'c:\temp\administrators.csv'
    $admins = Get-LocalGroupMember administrators
    foreach ($admin in $admins)
    {
        Write-Host $admin.name

        $user = [PSCustomObject]@{
            Username = $admin.Name
            Access = 'Admin'
        }
        Export-Csv -path $path -InputObject $user -Append
        $bodyTxt += "`n $($admin.Name)"
    }

    if($password -ne $null)
    {
        Send-PSEmail -Subject "Local Admins From $($env:COMPUTERNAME)" -Password $password -Body "This is a list of local admins from $($env:COMPUTERNAME) `n $($bodyTxt)" -attachments $path
    }
}