$ErrorActionPreference = "Stop";

# config

$version = "12.19"

# END config


if (Get-Command "chef-client" -ErrorAction SilentlyContinue) 
{ 
    Write-Host "Chef client already installed."
   exit
}

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12

. { Invoke-WebRequest -useb https://omnitruck.chef.io/install.ps1 } |
    Invoke-Expression; install -version $version 

Write-Host "Chef client install completed."
