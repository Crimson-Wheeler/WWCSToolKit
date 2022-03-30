﻿function Get-WWCSProgramPath()
{
    return "C:\Program Files\WWCS\Programs"

}

function Install-BillingReconciliation()
{
    
}

function Remove-WaveBrowser()
{


}

function Get-ApplicationList()
{
    $apps = Get-AppxPackage –AllUsers
    $apps += Get-WmiObject -Class Win32_Product | Select Name | Sort -Property Name
    $apps += Get-InstalledAppsFromRegistry | Select @{N=’Name’; E={$_.DisplayName}}

    [System.Collections.ArrayList]$apps = $apps | Sort-Object name
    for($i = 0; $i -lt $apps.Count; $i++)
    {   
        if([string]$apps[$i].name -eq [string]$apps[$i+1].name)
        {
            $apps.RemoveAt($i)
            Write-Host $apps[$i] 
            Write-Host $apps[$i+1] 
            Write-Host "--------"
            $i--
        }

    }
    return $apps
}
function Open-Program($path)
{
    Start-Process $path
}
function Open-WWCSProgram($programName)
{
    if($programName -eq $null)
    {
        #list all files in the programs
        #select a number from them
        #start that process

        [string]$path = Get-WWCSProgramPath

        $files = [System.Collections.ArrayList]@()
        $files.AddRange(@(Get-ChildItem $($path)));

        Write-Output " "
        Write-Output " "
        Write-Output " "
        Write-Output "Program Num | Program Choice to Run"
        Write-Output "-------------------------------------------"
        [int]$index = 1
        foreach($item in $files)
        {
            Write-Output "$(New-TextSpacing -amount 12 -inputText $index.ToString())| $($files[($index-1)])"
            $index++
        }
        Write-Output " "
        Write-Output " "
        Write-Output " "
        [int]$choice =  Read-Host -Prompt 'Pick your File to open and press the [Enter] key:'
        [string]$val = "$($path)\$($files[($choice-1)])"
        Write-Host $val
        Start-Process $val

    }
    else
    {
        Write-Host "Starting program from $(Get-WWCSTOOLKITPath)\Programs\$($programName)"
        Start-Process "$(Get-WWCSProgramPath)\$($programName)"
    }
    
}



# getInstalledAppsFromRegistry.ps1
# ref: https://gallery.technet.microsoft.com/scriptcenter/Get-list-of-installed-36a17e1b
function Get-InstalledAppsFromRegistry() 
{ 
     
    $scriptBlock={ 
 
        #this function gets all properties from registry 
        #It doesn't fail if a property value is corrupted 
         
        function read-AppPropertiesToObj{ 
            param($Application, $Architecture) 
 
            $prop = @{ 
                APP_Architecture = $Architecture 
                APP_GUID = $Application.PSChildName 
            } 
 
            #for PS 2.0 compatibility 
            $itemslist = @($Application | select -ExpandProperty Property) 
 
            foreach ($item in $itemslist) 
            { 
                #if value is corrupted, get-itemproperty function fails 
                try 
                { 
                    $prop.$item = $Application | Get-ItemProperty -name $item | select -ExpandProperty $item 
                } 
                catch 
                { 
                    $prop.$item = '(invalid value)' 
                } 
            } 
 
            $result = New-Object psobject -Property $prop 
 
            return $result 
        }#function 
 
        $apps = @() 
        $results = @() 
 
        if (Test-Path 'HKLM:\SOFTWARE\Wow6432Node\microsoft\Windows\CurrentVersion\Uninstall') 
        { 
            # 
            #"64 bit system, 32 bit node" 
            $apps = Get-ChildItem 'HKLM:\SOFTWARE\Wow6432Node\microsoft\Windows\CurrentVersion\Uninstall' 
         
            foreach ($app in $apps) 
            { 
                $results += read-AppPropertiesToObj -Application $app -Architecture 32 
            } 
 
            #64 bit system, 64 bit node 
            $apps = Get-ChildItem 'HKLM:\SOFTWARE\microsoft\Windows\CurrentVersion\Uninstall' 
 
            foreach ($app in $apps) 
            { 
                $results += read-AppPropertiesToObj -Application $app -Architecture 64 
            } 
 
        } 
        else 
        { 
            #32 bit system, 32 bit node 
            $apps = Get-ChildItem 'HKLM:\SOFTWARE\microsoft\Windows\CurrentVersion\Uninstall' 
 
            foreach ($app in $apps) 
            { 
                $results += read-AppPropertiesToObj -Application $app -Architecture 32 
            } 
        }#if else 
 
        return $results | sort DisplayName 
 
    }#scriptblock 
     
    #determine OS architecture and path to the native powershell.exe 
 
    #-----32 bit process running on a 64 bit machine 
    if (([intptr]::size -eq 4) -and (test-path env:\PROCESSOR_ARCHITEW6432)) 
    { 
        $PsExePath = "C:\windows\sysnative\WindowsPowerShell\v1.0\powershell.exe" 
    } 
    #-----64 bit process running on a 64 bit machine 
    elseif (([intptr]::size -eq 8) -and !(test-path env:\PROCESSOR_ARCHITEW6432)) 
    { 
        $PsExePath = "C:\windows\system32\WindowsPowerShell\v1.0\powershell.exe" 
    } 
    #-----32 bit process running on a 32 bit machine 
    else 
    { 
        $PsExePath = "C:\windows\system32\WindowsPowerShell\v1.0\powershell.exe" 
    } 
 
    #execute command 
    $tmp = & $PsExePath $scriptBlock 
 
    #return results 
    return $tmp 
}

