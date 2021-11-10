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
    
    }
    else
    {
        Write-Host "Starting program from $(Get-WWCSTOOLKITPath)\Programs\$($programName)"
        Start-Process "$(Get-WWCSTOOLKITPath)\Programs\$($programName)"
    }
    
}