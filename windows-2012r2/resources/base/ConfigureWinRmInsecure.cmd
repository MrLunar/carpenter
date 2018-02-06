call winrm quickconfig -q
call winrm set winrm/config/service/auth @{Basic="true"}
call winrm set winrm/config/service @{AllowUnencrypted="true"}

netsh advfirewall firewall set rule group="Windows Remote Management" new enable=yes