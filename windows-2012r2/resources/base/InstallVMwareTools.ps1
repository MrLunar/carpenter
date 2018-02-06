# config
$downloadUrl = 'https://packages.vmware.com/tools/esx/6.5/windows/x64/VMware-tools-10.1.0-4449150-x86_64.exe'
$checksum = '7A3A9F5183B179DF9D0AF3B6DDCBA69AFAC83252DA58CA8ECD6311DAC2DE8727'
# END config

$ErrorActionPreference = "Stop"

$installArgs = '/S /v"/qn REBOOT=R"'
$localDownloadPath = '.\vmware-tools.exe'

if (![System.IO.File]::Exists($localDownloadPath)) {    
    Write-Host "Downloading installer ..."
    Invoke-WebRequest $downloadUrl -OutFile $localDownloadPath    
}

$fileHash = Get-FileHash $localDownloadPath
if ( ! ($fileHash.Hash -eq $checksum)) {
    Write-Error "Invalid checksum"
    exit 1
}

Write-Host "File download completed."
Write-Host "Installing VMware Tools ..."

Start-Process $localDownloadPath -ArgumentList $installArgs -Wait -NoNewWindow
Remove-Item $localDownloadPath

Write-Host "Install completed."