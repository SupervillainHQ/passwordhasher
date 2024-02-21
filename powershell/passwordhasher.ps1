param(
    [switch]$firstCap = $false
)

Add-Type -AssemblyName 'System.Windows.Forms'

function FirstCap{
    param(
        [string]$hash
    )

    $stack = ""
    $first = $false
    foreach ($char in [char[]]$hash) {
        if([int]($char) -gt 96 -and [int]($char) -lt 103 -and $first -ne $true){
            $char = [char]($char - 32)
            $first = $true
        }
        $stack = $stack + $char
    }

    return $stack
}

$utf8 = new-object -TypeName System.Text.UTF8Encoding

$secureSalt = Read-Host -AsSecureString -Prompt 'Input salt'
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureSalt)
$salt = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

$clipped = [System.Windows.Forms.Clipboard]::GetText() + $salt

$stream = [System.IO.MemoryStream]::new($utf8.GetBytes($clipped))
$hash = Get-FileHash -Algorithm MD5 -InputStream $stream | Select-Object -ExpandProperty Hash
$hash = $hash.ToLower()

if($firstCap){
    $hash = FirstCap $hash.ToLower()
}

[System.Windows.Forms.Clipboard]::SetText($hash)

