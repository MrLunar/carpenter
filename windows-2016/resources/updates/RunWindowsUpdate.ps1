$ErrorActionPreference = "Stop"

Write-Host "Installing pre-requisites ..."
Install-PackageProvider -Name NuGet -Force
Install-Module PSWindowsUpdate -Force

Write-Host "Starting Windows Update ..."
Get-WUInstall -WindowsUpdate -AcceptAll -UpdateType Software -IgnoreReboot -Verbose 
