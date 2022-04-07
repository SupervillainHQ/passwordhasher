Add-Type -AssemblyName 'System.Windows.Forms'

$utf8 = new-object -TypeName System.Text.UTF8Encoding

$secureSalt = Read-Host -AsSecureString -Prompt 'Input salt'
$BSTR = [System.Runtime.InteropServices.Marshal]::SecureStringToBSTR($secureSalt)
$salt = [System.Runtime.InteropServices.Marshal]::PtrToStringAuto($BSTR)

$clipped = [System.Windows.Forms.Clipboard]::GetText() + $salt

$stream = [System.IO.MemoryStream]::new($utf8.GetBytes($clipped))
$hash = Get-FileHash -Algorithm MD5 -InputStream $stream | Select-Object -ExpandProperty Hash
[System.Windows.Forms.Clipboard]::SetText($hash.ToLower())
Write-Host $hash.ToLower()