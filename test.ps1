Write-Host "THIS IS A PRELOAD TEST"

$moduleFunctions = Import-Csv -Path "C:\Users\crimson.wheeler\WorldWide Computer Solutions, Inc\WWCS - Documents\Utilities\Powershell\WWCS-TOOLKIT\WWCSToolKit\Data\WWCSFunctions.csv"
 $moduleFunctions | Format-Table

 #Write-Host $moduleFunctions