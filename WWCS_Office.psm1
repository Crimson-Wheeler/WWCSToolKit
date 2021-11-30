function Connect-MSOL()
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
            try{Get-Package -Name $module}
            catch{Install-Module $module -Force}

            Import-Module $module -Force
        }
        


        
        
        Connect-MsolService -Credential $creds
        Connect-AzureAD -Credential $creds
        Connect-ExchangeOnline -Credential $creds 
    }
}
function Select-O365User()
{

    $objs = (Get-MsolUser | Where-Object {$_.FirstName.Length -gt 0} |Sort-Object -Property FirstName)
    $m = 0

    Write-Host "$(New-TextSpacing -amount 8 -inputText "Index")|$(New-TextSpacing -amount 12 -inputText "First Name")|$(New-TextSpacing -amount 12 -inputText "Last Name")|$($(New-TextSpacing -amount 16 -inputText "Principal Name"))" 
    Write-Host "--------------------------------------------------------------------------------------------"
    foreach($i in $objs)
    {
        $m++
        Write-Host "$(New-TextSpacing -amount 8 -inputText $m.ToString())|$(New-TextSpacing -amount 12 -inputText $i.FirstName)|$(New-TextSpacing -amount 12 -inputText $i.LastName)|$($i.UserPrincipalName)"
      
    }
    $index = (Read-Host -Prompt "Select which user(s) you want by typing the associated number").Split(",")

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
    $userToDelete = (Select-O365User)
    foreach($userDeleting in $userToDelete)
    {
        $userEmail = $userToDelete.UserPrincipalName
        $identity = "$($userToDelete.FirstName) $($userToDelete.LastName)"
        Write-Host $identity
        Write-Host "Getting ready to delete $($userToDelete.UserPrincipalName) $($identity)"

        #if((Read-Host -Prompt "This fully deletes the user and cannot be undone. Would you like to continue? Y or N?").ToLower() -eq 'n' ){return}
        #if((Read-Host -Prompt "Are you sure you want to delete $($userEmail) this is perminant? Y or N?").ToLower() -eq 'n' ){return}

        Write-Host "Removing User..."
        Remove-MsolUser -UserPrincipalName $userEmail
        Write-Host "Removing User From Recycle Bin..."
        Remove-MsolUser -UserPrincipalName $userEmail -RemoveFromRecycleBin
        Write-Host "Removing Mailbox"
        Remove-Mailbox -Identity $identity

        Write-Host "Continue deleting----------------------------------------------------------------------------------------------------"
    }
    
}
function Decomission-O365User()
{
    Connect-MSOL
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

function Reset-O365Pass()
{
    
}


