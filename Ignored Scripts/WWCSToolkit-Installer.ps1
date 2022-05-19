$logPath = "C:\Program Files\WWCS\Logs"
$dataPath = "C:\Program Files\WWCS\DataControl"
$programPaths = "C:\Program Files\WWCS\Programs"
$fileName = "WWCS-TOOLKIT.log"
$tempPath = "C:\Temp"
$modulePath =  "C:\Windows\system32\WindowsPowerShell\v1.0\Modules"
$RepositoryZipUrl = "https://github.com/Crimson-Wheeler/WWCSToolkit/archive/main.zip" 

$errors = ""
try {
    
    #region Cleaup 
    if(Test-Path 'C:\Windows\system32\WindowsPowerShell\v1.0\Modules\WWCS-TOOLKITnew'){
        Remove-Item 'C:\Windows\system32\WindowsPowerShell\v1.0\Modules\WWCS-TOOLKITnew' -Recurse -Force
    }
    if(Test-Path 'C:\Windows\system32\WindowsPowerShell\v1.0\Modules\WWCS-TOOLKITold'){
        Remove-Item 'C:\Windows\system32\WindowsPowerShell\v1.0\Modules\WWCS-TOOLKITold' -Recurse -Force
    }
    if(Test-Path 'C:\Windows\system32\WindowsPowerShell\v1.0\Modules\WWCSToolKit-main'){
        Remove-Item 'C:\Windows\system32\WindowsPowerShell\v1.0\Modules\WWCSToolKit-main' -Recurse -Force
    }
    if(Test-Path 'C:\Temp\WWCSToolKit-main'){
        Remove-Item  'C:\Temp\WWCSToolKit-main' -Recurse -Force
    }
    if(Test-Path 'C:\Temp\wwcstoolkit'){
        Remove-Item  'C:\Temp\wwcstoolkit' -Recurse -Force
    }
    if(Test-Path 'C:\Temp\.zip'){
        Remove-Item 'C:\Temp\.zip' -Recurse -Force
    }
    if(Test-Path 'C:\Temp\wwcstoolkit.zip'){
        Remove-Item 'C:\Temp\wwcstoolkit.zip' -Recurse -Force
    }
    #endregion

    #region downloading 
    #download the zip 
    Write-Host 'Starting downloading the GitHub Repository'
    Invoke-RestMethod -Uri $RepositoryZipUrl -OutFile 'C:\Temp\wwcstoolkit.zip'

    #extract to toolkit
    Write-Host 'Extract Folder'
    if(Test-Path 'C:\Temp\wwcstoolkit.zip')
    {
        Expand-Archive -Path 'C:\Temp\wwcstoolkit.zip' -DestinationPath 'C:\Temp\wwcstoolkit'
    }
    else
    {
        $errors += "\n ERROR: Zip File Failed to Download"
    }


    if(Test-Path 'C:\Temp\wwcstoolkit\WWCSToolKit-main')
    {
        Copy-Item 'C:\Temp\wwcstoolkit\WWCSToolKit-main' -Destination 'C:\Windows\system32\WindowsPowerShell\v1.0\Modules\WWCS-TOOLKITnew' -Recurse -Force
    }
    else
    {
        $errors += "\n ERROR: Zip Extraction Failed."
    }
    #endregion

    #region Renaming and Deleting old toolkit
    if(Test-Path -Path "C:\Windows\system32\WindowsPowerShell\v1.0\Modules\WWCS-TOOLKIT")
    {
        Rename-Item -Path "C:\Windows\system32\WindowsPowerShell\v1.0\Modules\WWCS-TOOLKIT" `
                    -NewName "C:\Windows\system32\WindowsPowerShell\v1.0\Modules\WWCS-TOOLKITold"
    }
    if(Test-Path -Path "C:\Windows\system32\WindowsPowerShell\v1.0\Modules\WWCS-TOOLKITnew")
    {
        Rename-Item -Path "C:\Windows\system32\WindowsPowerShell\v1.0\Modules\WWCS-TOOLKITnew" `
                    -NewName "C:\Windows\system32\WindowsPowerShell\v1.0\Modules\WWCS-TOOLKIT"
    }
    else
    {
        $errors += "\n ERROR: Failed to Copy Toolkit to Module Path."
    }
    if(Test-Path -Path "C:\Windows\system32\WindowsPowerShell\v1.0\Modules\WWCS-TOOLKITold")
    {
        Remove-Item "C:\Windows\system32\WindowsPowerShell\v1.0\Modules\WWCS-TOOLKITold" -Recurse -Force
    }
    #endregion

    #region Move Programs and Data, Create Directories
    if(-not(Test-Path "C:\Program Files\WWCS"))
    {
        New-Item -Path "C:\Program Files\WWCS" -ItemType "directory"
    }  

    if(Test-Path "C:\Program Files\WWCS")
    {
        if(Test-Path 'C:\Program Files\WWCS\DataControl')
        {
            Remove-Item 'C:\Program Files\WWCS\DataControl' -Recurse
        }
        Copy-Item 'C:\Windows\system32\WindowsPowerShell\v1.0\Modules\WWCS-TOOLKIT\DataControl' `
                    'C:\Program Files\WWCS\DataControl' -Recurse -Force
    }  
    if(Test-Path "C:\Program Files\WWCS")
    {
        if(Test-Path 'C:\Program Files\WWCS\Programs')
        {
            Remove-Item 'C:\Program Files\WWCS\Programs' -Recurse
        }
        Copy-Item 'C:\Windows\system32\WindowsPowerShell\v1.0\Modules\WWCS-TOOLKIT\Programs' `
                    'C:\Program Files\WWCS\Programs' -Recurse -Force
    }
    else
    {
        $errors += "\n ERROR: WWCS Directory Does not exist."
    }

    if(Test-Path 'C:\Program Files\WWCS\Programs')
    {
        Remove-Item 'C:\Windows\system32\WindowsPowerShell\v1.0\Modules\WWCS-TOOLKIT\Programs' -Recurse
    }
    else
    {
        $errors += "\n ERROR: Programs Folder Failed."
    }
    if(Test-Path 'C:\Program Files\WWCS\DataControl')
    {
        Remove-Item 'C:\Windows\system32\WindowsPowerShell\v1.0\Modules\WWCS-TOOLKIT\DataControl' -Recurse
    }
    else
    {
        $errors += "\n ERROR: Data Control Folder Failed."
    }
    #endregion

    #region Cleaup Again
    if(Test-Path 'C:\Windows\system32\WindowsPowerShell\v1.0\Modules\WWCS-TOOLKITnew'){
        Remove-Item 'C:\Windows\system32\WindowsPowerShell\v1.0\Modules\WWCS-TOOLKITnew' -Recurse -Force
    }
    if(Test-Path 'C:\Windows\system32\WindowsPowerShell\v1.0\Modules\WWCS-TOOLKITold'){
        Remove-Item 'C:\Windows\system32\WindowsPowerShell\v1.0\Modules\WWCS-TOOLKITold' -Recurse -Force
    }
    if(Test-Path 'C:\Windows\system32\WindowsPowerShell\v1.0\Modules\WWCSToolKit-main'){
        Remove-Item 'C:\Windows\system32\WindowsPowerShell\v1.0\Modules\WWCSToolKit-main'
    }
    if(Test-Path 'C:\Temp\WWCSToolKit-main'){
        Remove-Item  'C:\Temp\WWCSToolKit-main' -Recurse -Force
    }
    if(Test-Path 'C:\Temp\wwcstoolkit'){
        Remove-Item  'C:\Temp\wwcstoolkit' -Recurse -Force
    }
    if(Test-Path 'C:\Temp\.zip'){
        Remove-Item 'C:\Temp\.zip' -Recurse -Force
    }
    if(Test-Path 'C:\Temp\wwcstoolkit.zip'){
        Remove-Item 'C:\Temp\wwcstoolkit.zip' -Recurse -Force
    }
    #endregion
}
catch {
    foreach ($item in $Error) 
    {
        $errors += "\n ERROR: $($item)"
    }
}


if($errors.Length -gt 0)
{
    $errors > "$($tempPath)\$($fileName)"
}
else 
{
    "SUCCESS: WWCS-TOOLKIT is Up to date" > "$($tempPath)\$($fileName)"
}








