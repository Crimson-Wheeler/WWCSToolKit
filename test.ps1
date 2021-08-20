# Init PowerShell Gui
Add-Type -AssemblyName System.Windows.Forms

$defaultEmail = "Email"
$defaultPass = "New Password" 

# Create a new form
$form                    = New-Object system.Windows.Forms.Form
# Define the size, title and background color
$form.ClientSize         = '320,140'
$form.text               = "Change Office 365 User Password"
$form.BackColor          = "#ffffff"

#----------------------------------------Username Textbox
$userTxtBox            = New-Object System.Windows.Forms.TextBox
$userTxtBox.text              = $defaultEmail
$userTxtBox.width             = 300
$userTxtBox.height            = 30
$userTxtBox.location          = New-Object System.Drawing.Point(10,10)
$userTxtBox.Font              = 'Microsoft Sans Serif,10'
$userTxtBox.ForeColor         = "#000000"

#----------------------------------------New Password Textbox
$passTxtBox            = New-Object System.Windows.Forms.TextBox
$passTxtBox.text              = $defaultPass
$passTxtBox.width             = 300
$passTxtBox.height            = 30
$passTxtBox.location          = New-Object System.Drawing.Point(10,50)
$passTxtBox.Font              = 'Microsoft Sans Serif,10'
$passTxtBox.ForeColor         = "#000000"

#----------------------------------------RUN BUTTON
$Btn                   = New-Object system.Windows.Forms.Button
$Btn.BackColor         = "#000000"
$Btn.text              = "GO!"
$Btn.width             = 90
$Btn.height            = 30
$Btn.location          = New-Object System.Drawing.Point(10,100)
$Btn.Font              = 'Microsoft Sans Serif,10'
$Btn.ForeColor         = "#ffffff"




$form.Controls.AddRange(@($Btn, $userTxtBox, $passTxtBox))


function ChangeUserPassword 
{
    Install-Module MSOnline

    [pscredential]$creds = Get-Credential -Message "ADMIN CREDENTIALS"

    Connect-MsolService -Credential $creds
    $user = $userTxtBox.Text
    $pass = $passTxtBox.Text
    

    if(($user -ne $defaultEmail) -and ($pass -ne $defaultPass))
    {
        Set-MsolUserPassword -UserPrincipalName "$($user)" -NewPassword "$($pass)" -ForceChangePassword $false 
    }    
    else
    {
        [pscredential]$userpass = Get-Credential -Message "Supply user/pass to change"
        $user = $userpass.UserName
        $pass = $userpass.Password
            
        Set-MsolUserPassword -UserPrincipalName "$($user)" -NewPassword "$($pass)" -ForceChangePassword $false
    }
    
}



$Btn.Add_Click({ChangeUserPassword})















# Display the form
[void]$form.ShowDialog()


