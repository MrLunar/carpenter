$ErrorActionPreference = "Stop"

Write-Host "Stopping Windows Update service ..."
Stop-Service wuauserv

Write-Host "Installing Microsoft Update service manager ..."
$mu = New-Object -ComObject Microsoft.Update.ServiceManager -Strict 
$mu.AddService2("7971f918-a847-4430-9279-4a52d1efe18d",7,"")

Write-Host "Starting Windows Update service ..."
Start-Service wuauserv
