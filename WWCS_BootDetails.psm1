#Gets the uptime of the computer
function Get-DaysSinceBoot()
{
    #Uses the timespan object to evaluate the difference in time between the last boot up time and now
    return (New-TIMESPAN -Start (Get-WmiObject win32_operatingsystem | select csname, @{LABEL='LastBootUpTime';EXPRESSION={$_.ConverttoDateTime($_.lastbootuptime)}}).LastBootUpTime -End (Get-Date)).Days
}