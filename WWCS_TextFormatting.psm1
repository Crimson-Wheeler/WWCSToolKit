#if the amount is greater than textOffSetLenght, whill return spaces to offset the difference
function New-WhiteSpace($amount = 1,[string]$textOffset = "")
{
    
    $amount -= $textOffset.Length
    [string]$str = ""
    for([int]$i = 0; $i -lt $amount; $i++)
    {
        $str += " "
    }

    return $str
}

#truncates a string to be a certain length no matter what, will add spaces if smaller than target size
function New-TextSpacing($amount = 1,[string]$inputText = "")
{
    [string]$str = $inputText
    for([int]$i = 0; $i -lt $amount; $i++)
    {
        $str += " "
    }
    $str = $str.Substring(0,$amount)
    return $str
}