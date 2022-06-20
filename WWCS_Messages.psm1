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
    #New-Process "C:\Program Files\WWCS\Programs\NotificationWindow.exe" -ArgumentList @($Title,$Message)
    Start-Process powershell.exe -Argument "Import-Module WWCS-TOOLKIT; Sleep 1; Send-PSNotification `"$($Title)`" `"$($Message)`"" -NoNewWindow
}

function Send-PSNotification([string] $Title,[string]$Message)
{
    Add-Type -AssemblyName System.Windows.Forms

    function msg{
        param ($msg) [System.Windows.MessageBox]::Show($msg)
    }

    $username = $env:UserName
    $sharePointPath = "WWCS - Documents\Shared\Powershell"
    $empty = "empty"


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
    $form.BackColor          = "#ffffff"
    $form.Height             = $formHeight
    $form.Width              = $formWidth
    $xVal = ($width - $formWidth - $paddingX)
    $yVal = ($height - $formHeight - $paddingY)
    Write-Host "$($xVal),$($yVal)"
    $form.StartPosition = 'Manual'
    $form.Location = "$($xVal),$($yVal)"



    $TitlePnl                   = New-Object system.Windows.Forms.Panel
    $TitlePnl.width             = $form.Width-40
    $TitlePnl.Height                 = 100
    $TitlePnl.location          = New-Object System.Drawing.Point(10,10)
    $form.Controls.Add($TitlePnl)


    Write-Host $Title
    Write-Host "--------------"
    Write-Host $Message




    [void]$form.ShowDialog()

}

