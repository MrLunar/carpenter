echo "Blocking remote management ..."
netsh advfirewall firewall set rule group="Remote Desktop" new enable=no
netsh advfirewall firewall set rule group="Windows Remote Management" new enable=no

echo "Running sysprep generalise ..."
C:/windows/system32/sysprep/sysprep.exe /generalize /oobe /unattend:C:/Windows/Panther/Unattend.xml /shutdown