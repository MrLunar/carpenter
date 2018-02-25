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

Write-Host "Checking for Windows updates..."
$updates = Get-WUInstall -ListOnly -AcceptAll -IgnoreReboot -IgnoreUserInput

if ($updates) {
    # This is a hack fix for new installations sometimes not being able to 
    # retrieve the latest cumulative update.
    # It is unknown if this is a specific issue with this CU or something else.
    # The only workaround found so far is to allow the system to "settle", which
    # somehow allows the system to be provided the latest updates.
    # Unfortunately this "settling" takes a long time (15-30mins)
    # Fingers crossed this is only a temporary issue...
    if ($updates.KB -like 'KB4053579') {
        Write-Host "Sleeping for 10m due to a clean install not being able to retrieve the latest updates sometimes..."
        Start-Sleep -s 600
        
        Write-Host "Performing another search for Windows Updates..."
        $updates = Get-WUInstall -ListOnly -AcceptAll -IgnoreReboot -IgnoreUserInput
    }
    
    if ($updates.KB -like 'KB4053579') {
        Write-Host "ERROR: WU still retrieving old updates"
        Write-Host "ERROR: Increase timeout or find another workaround."
        exit 1
    }
    
    Write-Host "Installing Windows updates..."
    Get-WUInstall -AcceptAll -IgnoreReboot -IgnoreUserInput
}

Write-Host "Cleaning up..."
Remove-Module PSWindowsUpdate
Remove-Item "c:\windows\system32\windowspowershell\v1.0\modules\pswindowsupdate" -Recurse

Write-Host "Completed installing Windows updates."
