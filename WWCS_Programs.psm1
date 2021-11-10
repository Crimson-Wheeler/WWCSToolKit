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
        Start-Process "$(Get-WWCSTOOLKITPath)\$programName"
    }
    
}