function Send-PSEmail($Password,$Subject,$Body,[string[]]$attachments)
{
    $MailMessage = @{
        From = "toolkit@wwcs.com"
        To = "toolkit@wwcs.com"
        Subject = $Subject
        Body = $Body
        Smtpserver = "smtp.office365.com"
        Port = 587
        UseSsl = $true
        Attachments = $attachments
        }
    $username = "toolkit@wwcs.com"
    $pass = ConvertTo-SecureString $Password -AsPlainText -Force
    
    $credential = New-Object System.Management.Automation.PSCredential ($username, $pass)
    
    
    Send-MailMessage @MailMessage -Credential $credential
}

function Send-Notification([string] $Title,[string]$Message)
{
    Get-Process *NotificationWindow* | Stop-Process -Force
    New-Process "C:\Program Files\WWCS\Programs\NotificationWindow.exe" -Argument "`"$($Title)`" `"$($Message)`""
    #Start-Process powershell.exe -Argument "Import-Module WWCS-TOOLKIT; Sleep 1; Send-PSNotification `"$($Title)`" `"$($Message)`"" -NoNewWindow
    #New-Process powershell.exe -Argument "Import-Module WWCS-TOOLKIT; Sleep 1; Send-PSNotification `"$($Title)`" `"$($Message)`""
}

function Send-PSNotification([string] $Title,[string]$Message)
{
    Add-Type -AssemblyName System.Windows.Forms



    $paddingX = 5;
    $paddingY = 50;
    $width = [System.Windows.Forms.SystemInformation]::PrimaryMonitorSize.Width
    $height = [System.Windows.Forms.SystemInformation]::PrimaryMonitorSize.Height

    $formWidth = 611
    $formHeight = 291

    # Create a new form
    $form                    = New-Object system.Windows.Forms.Form
    # Define the size, title and background color

    $form.text               = "Worldwide Computer Solutions Notification"
    $form.BackColor          = "#720a0b"
    $form.Height             = $formHeight
    $form.Width              = $formWidth
    $xVal = ($width - $formWidth - $paddingX)
    $yVal = ($height - $formHeight - $paddingY)
    Write-Host "$($xVal),$($yVal)"
    $form.StartPosition = 'Manual'
    $form.Location = "$($xVal),$($yVal)"



    $TitlePnl = New-Object system.Windows.Forms.Panel
    $TitlePnl.BackColor = "#c8e0dc"
    $TitlePnl.BorderStyle = "FixedSingle"
    $TitlePnl.Size = "567,67"
    $TitlePnl.location = "12,9"
    $form.Controls.Add($TitlePnl)

    $TitleLbl = New-Object System.Windows.Forms.Label
    $TitleLbl.Text = $Title
    $TitleLbl.Font = "$($TitleLbl.Font.FontFamily), 25"
    $TitleLbl.Size = $TitlePnl.Size
    $TitlePnl.Controls.Add($TitleLbl)

    ##ebe9e8

    $MessagePnl = New-Object system.Windows.Forms.Panel
    $MessagePnl.BackColor = "#ebe9e8"
    $MessagePnl.BorderStyle = "FixedSingle"
    $MessagePnl.Size = "567,150"
    $MessagePnl.location = "12,86"
    $form.Controls.Add($MessagePnl)

    $MessageLbl = New-Object System.Windows.Forms.Label
    $MessageLbl.Text = $Message
    $MessageLbl.Font = "$($MessageLbl.Font.FontFamily), 18"
    $MessageLbl.Size = $MessagePnl.Size
    $MessagePnl.Controls.Add($MessageLbl)


    Write-Host $Title
    Write-Host "--------------"
    Write-Host $Message




    [void]$form.ShowDialog()

}

function Send-UptimeNotification($threshold){
    if(Get-Uptime -gt $threshold)
    {
        Send-Notification "Message from WWCS..." "Your computer has not been restarted in $(Get-Uptime) days. `
        if you do not reboot your computer, then it has a higher chance of experiancing errors."

    }
}

