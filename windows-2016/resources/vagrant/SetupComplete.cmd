:: C:\Windows\Setup\Scripts\SetupComplete.cmd
::
:: Post-OOBE configuration for Vagrant box.

:: Generate WinRm SSL certificate
powershell -Command ". C:/Windows/Panther/Configure-WinRmSecureSelfSigned.ps1"

:: The machine is now ready for use
netsh advfirewall firewall set rule name="Remote Desktop - User Mode (TCP-In)" new enable=yes
netsh advfirewall firewall set rule name="Remote Desktop - User Mode (UDP-In)" new enable=yes
netsh advfirewall firewall set rule name="Windows Remote Management (HTTP-In)" new enable=yes
netsh advfirewall firewall set rule name="Windows Remote Management (HTTPS-In)" new enable=yes