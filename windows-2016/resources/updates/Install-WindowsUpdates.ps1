$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2

Write-Host "Installing pre-requisites..."
Add-Type -AssemblyName System.IO.Compression.Filesystem
$installPath = "C:\Windows\System32\WindowsPowerShell\v1.0\Modules"
if (!(Test-Path "$installPath\pswindowsupdate")) {
    [System.IO.Compression.ZipFile]::ExtractToDirectory(
        "C:\Windows\Temp\PSWindowsUpdate.zip", "$installPath"
    )
}
Import-Module PSWindowsUpdate

if (!(Test-Path "HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\QualityCompat")) {
    New-Item "HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\QualityCompat"
    New-ItemProperty "HKLM:SOFTWARE\Microsoft\Windows\CurrentVersion\QualityCompat" -Name "cadca5fe-87d3-4b96-b7fb-a231484277cc" -PropertyType dword -Value 0
}

Write-Host "Installing Windows updates..."
Get-WUInstall -AcceptAll -IgnoreReboot -IgnoreUserInput

Write-Host "Cleaning up..."
Remove-Module PSWindowsUpdate
Remove-Item "c:\windows\system32\windowspowershell\v1.0\modules\pswindowsupdate" -Recurse

Write-Host "Completed installing Windows updates."
