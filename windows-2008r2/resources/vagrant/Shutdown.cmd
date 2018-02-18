echo "Blocking remote desktop..."
netsh advfirewall firewall set rule group="Remote Desktop" new enable=no

echo "Running sysprep generalise ..."
start /wait C:/windows/system32/sysprep/sysprep.exe /generalize /oobe /unattend:C:/Windows/Panther/Unattend.xml

echo "Shutting down..."
shutdown /s /t 10

echo "Blocking remote management ..."
netsh advfirewall firewall set rule group="Windows Remote Management" new enable=no
