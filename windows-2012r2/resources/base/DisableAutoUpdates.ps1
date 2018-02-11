Write-Host "Disabling automatic Windows Update..."
if (!(Test-Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate)) {
    New-Item HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate
}
Set-ItemProperty -Path HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU -Name NoAutoUpdate -Value 1