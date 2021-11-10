function Get-WWCSProgramPath()
{
    return "C:\Program Files\WWCS\Programs"

}

function Install-BillingReconciliation()
{
    
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
            Write-Output "$($index)          | $($files[($index-1)])"
            $index++
        }
        Write-Output " "
        Write-Output " "
        Write-Output " "
        [int]$choice =  Read-Host -Prompt 'Pick your File to set to your clipboard'
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