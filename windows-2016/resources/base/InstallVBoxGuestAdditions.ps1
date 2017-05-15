$ErrorActionPreference = "Stop"

Write-Host "Finding installer location ..."
$driveLetters = 65..89 | ForEach-Object { ([char]$_)+":" }
$driveLetter = $driveLetters | Where-Object { ((Test-Path "$_\cert\vbox-sha256.cer")) }
if (!$driveLetter) {
    Write-Error "ERROR: Could not find Oracle certificates."
    exit 1
}
$installerBasePath = "$driveLetter"

Write-Host "Installing Oracle certs ..."
$certUtilPath = "$env:SYSTEMROOT\System32\certutil.exe"
$certPath = "$installerBasePath\cert\vbox-sha1.cer"
cmd /c $certUtilPath -addstore -f "TrustedPublisher" $certPath
$certPath = "$installerBasePath\cert\vbox-sha256.cer"
cmd /c $certUtilPath -addstore -f "TrustedPublisher" $certPath
$certPath = "$installerBasePath\cert\vbox-sha256-r3.cer"
cmd /c $certUtilPath -addstore -f "TrustedPublisher" $certPath

Write-Host "Installing VirtualBox Guest Additions ..."
cmd /c "$installerBasePath\VBoxWindowsAdditions.exe" /S

Write-Host "Install completed."