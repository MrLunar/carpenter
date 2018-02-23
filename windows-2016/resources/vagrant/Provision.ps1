##
# Provisioning for Vagrant box
##

$ErrorActionPreference = "Stop"

Write-Host "Configuring WinRM ..."
winrm set winrm/config/service/auth "@{Basic=`"true`"}"
New-NetFirewallRule -DisplayName 'Windows Remote Management (HTTPS-In)' -Name 'WINRM-HTTPS-In-TCP' -Group "Windows Remote Management" -Profile Any -LocalPort 5986 -Protocol TCP

Write-Host "Disabling password complexity requirements ..."
# Required in order to set the password as "vagrant"
secedit /export /cfg c:\secpol.cfg
(Get-Content C:\secpol.cfg).replace("PasswordComplexity = 1", "PasswordComplexity = 0") | Out-File C:\secpol.cfg
secedit /configure /db c:\windows\security\local.sdb /cfg c:\secpol.cfg /areas SECURITYPOLICY
Remove-Item -Force c:\secpol.cfg -confirm:$false

Write-Host "Configuring vagrant user ..."
$adminUser = "vagrant"
$adminPass = "vagrant"
net user $adminUser $adminPass /add
wmic path Win32_UserAccount where "Name='$adminUser'" set PasswordExpires=false
net localgroup "Administrators" $adminUser /add
net localgroup "Remote Desktop Users" $adminUser /add
net localgroup "Remote Management Users" $adminUser /add

Write-Host "Enabling remote desktop ..."
Set-ItemProperty -Path "HKLM:\System\CurrentControlSet\Control\Terminal Server" -Name "fDenyTSConnections" -Value 0

Write-Host "Disabling automatic Windows Updates ..."
$WindowsUpdatePath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\"
$AutoUpdatePath = "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU"
if (Test-Path -Path $WindowsUpdatePath) {
    Remove-Item -Path $WindowsUpdatePath -Recurse
}
New-Item -Path $WindowsUpdatePath
New-Item -Path $AutoUpdatePath
Set-ItemProperty -Path $AutoUpdatePath -Name "NoAutoUpdate" -Value 1

Write-Host "Configuring firewall ..."
Enable-NetFirewallRule -DisplayName "File and Printer Sharing (Echo Request - ICMPv4-In)"
Enable-NetFirewallRule -DisplayName "Remote Desktop - User Mode (TCP-In)"
Enable-NetFirewallRule -DisplayName "Remote Desktop - User Mode (UDP-In)"
Enable-NetFirewallRule -DisplayName "Windows Remote Management (HTTP-In)"
Enable-NetFirewallRule -DisplayName "Windows Remote Management (HTTPS-In)"

Write-Host "Provisioning complete."
