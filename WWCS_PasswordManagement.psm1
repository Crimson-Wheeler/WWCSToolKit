
function Check-O365PasswordValid([string]$email,[string]$password)
{
    [int]$numOfComplexityIssues = 0

    #len has to be greater than or equal to 8
    if($password.Length -lt 8)
    {
        return $false    
    }
    
    #password cannot contain spaces
    if($password.Contains(' '))
    {
        return $false
    }

    #-----------------------------------------------CHECKING COMPLEXITY
    $arrOfChars = [System.Collections.ArrayList]@()
    
    [bool]$containsSpecial = $false
    [bool]$containsNumber = $false
    [bool]$containsLower = $false
    [bool]$containsUpper = $false

    #checks each character in password and determins if it failes a complexity requirement
    for($num = 0 ; $num -lt $password.Length ; $num++)
    {
        $val = $password[$num]

        [int]$asc = [int]$val

        #special characters in the ascii range
        if($asc -ge 32 -and $asc -le 47){$containsSpecial = $true}

        #special characters in the ascii range
        if($asc -ge 58 -and $asc -le 64){$containsSpecial = $true}

        #special characters in the ascii range
        if($asc -ge 91 -and $asc -le 96){$containsSpecial = $true}

        #special characters in the ascii range
        if($asc -ge 123 -and $asc -le 126){$containsSpecial = $true}

        #numbers in the ascii range
        if($asc -ge 48 -and $asc -le 57){$containsNumber = $true}

        #lower case in the ascii range
        if($asc -ge 97 -and $asc -le 122){$containsLower = $true}

        #upper case in the ascii range
        if($asc -ge 65 -and $asc -le 90){$containsUpper = $true}
        
    }

    #counts the number of failed complexity requirements
    if(-not $containsSpecial){$numOfComplexityIssues++}
    if(-not $containsNumber){$numOfComplexityIssues++}
    if(-not $containsLower){$numOfComplexityIssues++}
    if(-not $containsUpper){$numOfComplexityIssues++}

    #values must be lest than or equal to 1
    if($numOfComplexityIssues -gt 1)
    {
        return $false
    }
    
    #if an email is provided, check to see if the password is contained in the email
    if($email.Length -gt 0 -and $email.Contains($password))
    {
        return $false
    }

    return $true
}