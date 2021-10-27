function Connect-MSOL()
{
    try
    {
        Get-MsolDomain -ErrorAction Stop > $null
    }
    catch 
    {
        $creds = Get-Credential -Message "Credentials for Office 365 Admin User"
        


        Import-Module MSOnline -Force
        Import-Module azureADPreview -Force
        Import-Module ExchangePowerShell -Force
        
        Connect-MsolService -Credential $creds
        Connect-AzureAD -Credential $creds
        Connect-ExchangeOnline -Credential $creds
    }
}
function Select-O365User()
{
    Connect-MSOL
    $objs = (Get-MsolUser | Sort-Object -Property FirstName)
    $m = 0
    foreach($i in $objs)
    {
        $m++
        Write-Host "$($m) : $($i.FirstName) $($i.LastName)"  
    }
    $index = [int](Read-Host -Prompt "Select which user your want by typing its associated number")
    return $objs[$index-1]
}


function Delete-O365User()
{
    Connect-MSOL
    $userToDelete = (Select-O365User)
    $userEmail = $userToDelete.UserPrincipalName
    $identity = "$($userToDelete.FirstName) $($userToDelete.LastName)"
    Write-Host $identity
    Write-Host "Getting ready to delete $($userEmail)"

    if((Read-Host -Prompt "This fully deletes the user and cannot be undone. Would you like to continue? Y or N?").ToLower() -eq 'n' ){return}
    if((Read-Host -Prompt "Are you sure you want to delete $($userEmail) this is perminant? Y or N?").ToLower() -eq 'n' ){return}

    Write-Host "Removing User..."
    Remove-MsolUser -UserPrincipalName $userEmail
    Write-Host "Removing User From Recycle Bin..."
    Remove-MsolUser -UserPrincipalName $userEmail -RemoveFromRecycleBin
    Write-Host "Removing Mailbox"
    Remove-Mailbox -Identity $identity

    Write-Host "Continue deleting----------------------------------------------------------------------------------------------------"
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


