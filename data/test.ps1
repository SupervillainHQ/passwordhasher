param(
    [string]$Domain
)
$sqlOut = sqlite3.exe .\domains.db "select '-C ' || caps, '-S ' || specials, '-L ' || length from domains where name = '$Domain';"

if(-Not [string]::IsNullOrEmpty($sqlOut)){
    Write-Host "output: $sqlOut"
    #splatting is supported
    $caps,$specials,$length = $sqlOut.split("|")

    $capsArg = "-c $caps"
    $specialsArg = "-c $specials"
    $lengthArg = "-c $length"

    Write-Host "caps: $capsArg"
    Write-Host "specials: $specialsArg"
    Write-Host "length: $lengthArg"
}
else{
    Write-Host "domain not recognised"
}