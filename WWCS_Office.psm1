function Start-MSOL()
{
    $neededPackages = @("MSOnline",
                        "AzureADPreview",
                        "ExchangePowerShell")
    try
    {
        Get-MsolDomain -ErrorAction Stop > $null
    }
    catch 
    {
        $creds = Get-Credential -Message "Credentials for Office 365 Admin User"
        
        foreach($module in $neededPackages)
        {
            try
            {
            Get-Package -Name $module
            }
            catch
            {
                try
                {
                    Install-Module $module -Force
                }
                catch
                {
                    Write-Host "Could not install module: " $module
                }
            }

            try
            {
                Import-Module $module -Force
            }
            catch
            {
                Write-Host "Could not import module: " $module
            }
        }
        


        
        
        try{Connect-MsolService -Credential $creds}catch{Write-Host "Connection to MSOL failed."}
        try{Connect-AzureAD -Credential $creds}catch{Write-Host "Connection to AzureAD failed."}
        try{Connect-ExchangeOnline -Credential $creds}catch{Write-Host "Connection to Exchange failed."}
    }
}
function Select-O365User($prompt = "Select which user(s) you want by typing the associated number")
{

    $objs = (Get-MsolUser | Where-Object {$_.FirstName.Length -gt 0} |Sort-Object -Property FirstName)
    $m = 0

    Write-Host "$(New-TextSpacing -amount 8 -inputText "Index")|$(New-TextSpacing -amount 12 -inputText "First Name")|$(New-TextSpacing -amount 12 -inputText "Last Name")|$($(New-TextSpacing -amount 16 -inputText "Principal Name"))" 
    Write-Host "--------------------------------------------------------------------------------------------"
    foreach($i in $objs)
    {
        $m++
        Write-Host "$(New-TextSpacing -amount 8 -inputText $m.ToString())|$(New-TextSpacing -amount 12 -inputText $i.FirstName) $(New-TextSpacing -amount 12 -inputText $i.LastName) $($i.UserPrincipalName)"
      
    }
    $index = (Read-Host -Prompt $prompt).Split(",")

    # $users = Get-MsolUser
    $listOfSelectedUsers = [System.Collections.ArrayList]@()
    foreach($i in $index)
    {
        Write-Host "You selected $($objs[$i-1].UserPrincipalName)"
        $listOfSelectedUsers.Add($objs[$i-1])
    }
    
    

    return $listOfSelectedUsers
}


function Delete-O365User()
{
    Connect-MSOL
    $users = (Select-O365User -prompt "Select user(s) to decomission.")
    foreach($user in $users)
    {
        Write-Host $user.FirstName
    }
    
}
function Decomission-O365User()
{
    Connect-MSOL
    $users = (Select-O365User -prompt "Select user(s) to decomission.")
    foreach($user in $users)
    {
        Write-Host $user.FirstName
    }
}
function Create-O365User()
{
    Connect-MSOL
    Write-Host "Please fill out the information below..."
    $firstName = Read-Host -Prompt "First Name"
    $lastName = Read-Host -Prompt "Last Name"

    $displayName = "$($firstName) $($lastName)"
    if((Read-Host "The default display name is $($displayName), would you like to change it? Y or N").ToLower() -eq 'y')
    {$displayName = Read-Host -Prompt "What would you like the display name to be"}

    $userName = "$($firstName.Substring(0,1))$($lastName)"
    if((Read-Host "The default username is $($userName), would you like to change it? Y or N").ToLower() -eq 'y')
    {$userName = Read-Host -Prompt "What would you like the username to be"}
    



    #show all possible emails and then select one
    $domains = Get-MsolDomain
    $m = 0
    foreach($i in $domains)
    {
        $m++
        Write-Host "$($m) : $($i.Name)"  
    }
    $index = [int](Read-Host -Prompt "Select which address you want by typing its associated number")

    $email = "$($userName)@$($domains[$index-1].Name)"
    Write-Host $email

    #ask if want it randomely generated
    $password = Read-Host -Prompt "Password"

    #list available licenses to select
    $license = Read-Host -Prompt "License"

    `

    #New-MsolUser -DisplayName $displayNameTxtBox.Text -FirstName $nameTxtBox.Text -LastName $lastNameTxtBox.Text -Password $passTxtBox.Text -LicenseAssignment $skuPartNumVal -ForceChangePassword $false  -UserPrincipalName $princName -UsageLocation "US" 


}

function Reset-O365Pass($csvFile = $null)
{
    if($csvFile -eq $null)
    {
        Connect-MSOL
        $users = (Select-O365User -prompt "Select user(s) to reset a password for.")
        foreach($user in $users)
        {
            Write-Host "Resetting password for "$user.FirstName" "$user.LastName

        }
    }
    else
    {
    
    }
}


