param(
    [Alias("c")][ValidateRange(0, 16)][int]$Cap = 0,
    [Alias("s")][ValidateRange(0, 16)][int]$Specials = 0,
    [Alias("l")][ValidateRange(6, 32)][int]$Len = 32,
    [Alias("h")][switch]$Help = $false
)

Add-Type -AssemblyName 'System.Windows.Forms'

function ChangeToUpper{
    param(
        [string]$hexString
    )
    $dec = [Convert]::ToString([uint32]"0x000000$hexString", 10)
    $modded = ($dec % 24) + 65
    $char = [char[]]$modded
    return $char
}

function ChangeToSpecial{
    param(
        [string]$hexString
    )
    $dec = [Convert]::ToString([uint32]"0x000000$hexString", 10)
    $modded = ($dec % 7) + 58
    $char = [char[]]$modded
    return $char
}

if($Help){
    Write-Host "Passwordhasher (Powershell) 2.0"
    Write-Host "  Creates a 32 character hash from the clipboard contents and a secret."
    Write-Host "  Use the hash as password by copying a website domain to the clipboard"
    Write-Host "  and input a secret, then submit the clipboard contents as the pass-"
    Write-Host "  word. This way you can reuse the secret across several website domains"
    Write-Host "Usage"
    Write-Host "  Passwordhasher.ps1 [-Cap|c <int>][-Specials|s <int>]"
    exit 0
}

$utf8 = new-object -TypeName System.Text.UTF8Encoding

$secureSalt = Read-Host -AsSecureString -Prompt 'Input salt'
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureSalt)
$salt = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

$clipped = [System.Windows.Forms.Clipboard]::GetText() + $salt

$stream = [System.IO.MemoryStream]::new($utf8.GetBytes($clipped))
$hash = Get-FileHash -Algorithm MD5 -InputStream $stream | Select-Object -ExpandProperty Hash
$hash = $hash.ToLower()

if($Cap -gt 0){
    $capped = ""
    for($i = 1; $i -le $Cap; $i++){
        $sub = $i * 2
        $capped = $capped + (ChangeToUpper $hash.SubString(32 - $sub, 2))
    }
}
if($Specials -gt 0){
    $special = ""
    for($i = 1; $i -le $Specials; $i++){
        $sub = $i * 2
        $special = $special + (ChangeToSpecial $hash.SubString(($i-1) * 2, 2))
    }
}

$hash = $hash.SubString($Specials, $Len - $Specials - $Cap)

[System.Windows.Forms.Clipboard]::SetText("$special$hash$capped")

