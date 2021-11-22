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