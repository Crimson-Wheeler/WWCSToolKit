#setup.exe \configure Business_32_Config.xm

#$path = "$(Get-WWCSTOOLKITPath)\ODT\setup.exe"
$arguments = "\configure Business_32_Config.xml"
#Start-Process $path -ArgumentList $arguments
#Start-Sleep -Seconds 10

cd "$(Get-WWCSTOOLKITPath)\ODT"
Start-Process "setup.exe" -ArgumentList $arguments