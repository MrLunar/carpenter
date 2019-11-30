$ErrorActionPreference = "Stop";
Set-StrictMode -Version 2.0

Write-Output "Installing containers feature..."
Install-WindowsFeature Containers

# Due to a multitude of issues using the package providers unattended, we'll install manually instead
# https://docs.docker.com/install/windows/docker-ee/#use-a-script-to-install-docker-ee

Write-Output "Downloading docker..."
$url = "https://download.docker.com/components/engine/windows-server/17.06/docker-17.06.2-ee-6.zip"
$hash = "FC31D16C3EFD4E3769A58639C207410D840E89C6B4E36BF78B8FC564FE06CAA5"
$tempDir = "C:\Windows\Temp"
(New-Object Net.WebClient).DownloadFile($url, "$tempDir\docker.zip")
$downloadHash = (Get-FileHash -Algorithm SHA256 "$tempDir\docker.zip").Hash
if ($downloadHash -ne $hash) {
    Write-Output "ERROR: Download checksum does not match."
    Write-Output "ERROR:   Was: $downloadHash"
    Write-Output "ERROR:   Expected: $hash"
    exit 1
}

Write-Output "Installing docker..."
Expand-Archive "$tempDir\docker.zip" -DestinationPath $Env:ProgramFiles
Remove-Item "$tempDir\docker.zip"
$env:path += ";$env:ProgramFiles\docker"
$newPath = "$env:ProgramFiles\docker;" + [Environment]::GetEnvironmentVariable("PATH", "Machine")
[Environment]::SetEnvironmentVariable("PATH", $newPath, "Machine")
Start-Process "dockerd.exe" "--register-service" -Wait

# WARNING: Insecure configuration below.

Write-Output "Configuring daemon..."
if (!(Test-Path "$env:ProgramData\docker\config\")) {
    New-Item -ItemType Directory "$env:ProgramData\docker\config\" | Out-Null
}
$json = '{ "hosts": ["tcp://0.0.0.0:2375", "npipe://"] }'
Out-File -Input $json -Encoding ascii -FilePath "$($env:ProgramData)\docker\config\daemon.json"

Write-Output "Configuring firewall for docker..."
New-NetFirewallRule -DisplayName "Docker" -Name "Docker" -Profile Any -LocalPort 2375 -Protocol TCP

Write-Output "Containers setup completed successfully."
