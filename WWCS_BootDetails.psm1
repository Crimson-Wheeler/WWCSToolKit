function Get-DaysSinceBoot()
{
    return (New-TIMESPAN -Start (Get-WmiObject win32_operatingsystem | select csname, @{LABEL='LastBootUpTime';EXPRESSION={$_.ConverttoDateTime($_.lastbootuptime)}}).LastBootUpTime -End (Get-Date)).Days
}