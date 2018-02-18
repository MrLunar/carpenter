##
# Provisioning for Vagrant box
##

$ErrorActionPreference = "Stop"

# Workaround for https://goo.gl/WPsbGr
$bindingFlags = [Reflection.BindingFlags] "Instance,NonPublic,GetField"
$objectRef = $host.GetType().GetField("externalHostRef", $bindingFlags).GetValue($host)
$bindingFlags = [Reflection.BindingFlags] "Instance,NonPublic,GetProperty"
$consoleHost = $objectRef.GetType().GetProperty("Value", $bindingFlags).GetValue($objectRef, @())
[void] $consoleHost.GetType().GetProperty("IsStandardOutputRedirected", $bindingFlags).GetValue($consoleHost, @())
$bindingFlags = [Reflection.BindingFlags] "Instance,NonPublic,GetField"
$field = $consoleHost.GetType().GetField("standardOutputWriter", $bindingFlags)
$field.SetValue($consoleHost, [Console]::Out)
$field2 = $consoleHost.GetType().GetField("standardErrorWriter", $bindingFlags)
$field2.SetValue($consoleHost, [Console]::Out)

Write-Host "Configuring WinRM ..."
winrm set winrm/config/service/auth "@{Basic=`"true`"}"
netsh.exe advfirewall firewall show rule name="Windows Remote Management (HTTPS-In)"
if ($LASTEXITCODE -ne 0) {
    netsh.exe advfirewall firewall add rule name="Windows Remote Management (HTTPS-In)" `
        dir=in action=allow protocol=TCP localport=5986 profile=any `
        description="Inbound rule for Windows Remote Management via WS-Management. [TCP 5986]"
}
$fw = New-Object -ComObject hnetcfg.fwpolicy2
($fw.rules | Where-Object {$_.Name -eq "Windows Remote Management (HTTPS-In)"}).Grouping = "@FirewallAPI.dll,-30252"

Write-Host "Disabling password complexity requirements ..."
secedit /export /cfg c:\secpol.cfg
((Get-Content C:\secpol.cfg) -replace "PasswordComplexity = 1", "PasswordComplexity = 0") | Out-File C:\secpol.cfg
secedit /configure /db c:\windows\security\local.sdb /cfg c:\secpol.cfg /areas SECURITYPOLICY
Remove-Item -Force c:\secpol.cfg -confirm:$false

Write-Host "Configuring vagrant user ..."
$adminUser = "vagrant"
$adminPass = "vagrant"
net user $adminUser $adminPass /add
wmic path Win32_UserAccount where "Name='$adminUser'" set PasswordExpires=false
net localgroup "Administrators" $adminUser /add
net localgroup "Remote Desktop Users" $adminUser /add

Write-Host "Disabling new network wizard (device discovery) ..."
New-Item -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Network\NewNetworkWindowOff" -Force

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
netsh advfirewall firewall set rule name="File and Printer Sharing (Echo Request - ICMPv4-In)" new enable=yes
netsh advfirewall firewall set rule name="Remote Desktop (TCP-In)" new enable=yes
netsh advfirewall firewall set rule name="Windows Remote Management (HTTP-In)" new enable=yes
netsh advfirewall firewall set rule name="Windows Remote Management (HTTPS-In)" new enable=yes

Write-Host "Provisioning complete."
