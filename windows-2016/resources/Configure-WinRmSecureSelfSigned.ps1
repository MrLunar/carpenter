##
# Generates a self-signed certificate for the host 
# then creates the WinRM HTTPS listener with the 
# generated cert.
# 
# This script should be run *after* generalize.
##

$hostname = $env:COMPUTERNAME

Write-Host "Generating host certificate for WinRM ..."
$cert = New-SelfSignedCertificate -DnsName "$hostname" -CertStoreLocation Cert:\LocalMachine\My

Write-Host "Configuring WinRM listener for HTTPS ..."
winrm create winrm/config/Listener?Address=*+Transport=HTTPS "@{Hostname=`"$hostname`";CertificateThumbprint=`"$($cert.ThumbPrint)`"}"
