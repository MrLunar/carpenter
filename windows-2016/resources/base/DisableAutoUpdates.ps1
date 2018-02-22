Write-Host "Disabling automatic Windows Update..."

Stop-Service wuauserv

$wuKey = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate"
if (!(Test-Path $wuKey)) {
    New-Item $wuKey
}
if (!(Test-Path $wuKey\AU)) {
    New-Item $wuKey\AU
}

Set-ItemProperty -Path $wuKey\AU -Name NoAutoUpdate -Value 1
