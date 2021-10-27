function Check-O365PasswordValid([string]$email,[string]$password)
{

    [int]$numOfComplexityIssues = 0
    if($password.Length -lt 8)
    {
        return $false    
    }
    
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

    for($num = 0 ; $num -lt $password.Length ; $num++)
    {
        $val = $password[$num]

        [int]$asc = [int]$val
        if($asc -ge 32 -and $asc -le 47){$containsSpecial = $true}
        if($asc -ge 58 -and $asc -le 64){$containsSpecial = $true}
        if($asc -ge 91 -and $asc -le 96){$containsSpecial = $true}
        if($asc -ge 123 -and $asc -le 126){$containsSpecial = $true}

        if($asc -ge 48 -and $asc -le 57){$containsNumber = $true}

        if($asc -ge 97 -and $asc -le 122){$containsLower = $true}

        if($asc -ge 65 -and $asc -le 90){$containsUpper = $true}
        
    }
    if(-not $containsSpecial){$numOfComplexityIssues++}
    if(-not $containsNumber){$numOfComplexityIssues++}
    if(-not $containsLower){$numOfComplexityIssues++}
    if(-not $containsUpper){$numOfComplexityIssues++}


    if($numOfComplexityIssues -gt 1)
    {
        return $false
    }
    

    if($email.Length -gt 0 -and $email.Contains($password))
    {
        return $false
    }

    return $true
}