$ErrorActionPreference = "Stop";
Set-StrictMode -Version 2.0

Write-Host "Installing containers feature..."
Install-WindowsFeature Containers

Write-Host "Installing nuget package provider..."
Install-PackageProvider -Name NuGet -RequiredVersion "2.8.5.201" -Force

Write-Host "Installing docker package provider..."
Install-Module -Name DockerMsftProvider -Repository PSGallery -RequiredVersion "1.0.0.4" -Force

Write-Host "Installing docker..."
Install-Package -Name docker -ProviderName DockerMsftProvider -RequiredVersion "17.06.2-ee-6" -Force

Write-Host "Containers setup completed successfully."
