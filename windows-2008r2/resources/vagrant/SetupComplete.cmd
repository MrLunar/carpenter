:: C:\Windows\Setup\Scripts\SetupComplete.cmd
::
:: Post-OOBE configuration for Vagrant box.

:: Ensure built-in administrator is disabled
net user administrator /random >nul
net user administrator /active:no

:: Generate WinRm SSL certificate
powershell -Command ". C:/Windows/Panther/Configure-WinRmSecureSelfSigned.ps1"

:: Cleanup
del /Q /F C:\Windows\Panther\Configure-WinRmSecureSelfSigned.ps1
del /Q /F C:\Windows\Panther\Unattend.xml

:: The machine is now ready for use
netsh advfirewall firewall set rule name="Remote Desktop (TCP-In)" new enable=yes
netsh advfirewall firewall set rule name="Windows Remote Management (HTTP-In)" new enable=yes
netsh advfirewall firewall set rule name="Windows Remote Management (HTTPS-In)" new enable=yes