#setup.exe \configure Business_32_Config.xm

$path = "$(Get-WWCSTOOLKITPath)\ODT\setup.exe"
$arguments = "\configure Business_32_Config.xml"
Start-Process -FilePath $path  $arguments