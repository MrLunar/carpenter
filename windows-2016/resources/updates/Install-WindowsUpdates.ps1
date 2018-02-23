$ErrorActionPreference = "Stop"

# Write-Host "Installing pre-requisites ..."
# Install-PackageProvider -Name NuGet -RequiredVersion 2.8.5.208 -Force
# Install-Module PSWindowsUpdate -RequiredVersion 2.0.0.3 -Force 

# Write-Host "Performing initial search for Windows Updates..."
# $updates = Get-WindowsUpdate -Verbose
# $updates | Format-List -Property KB,Title,Size

# This is a hack fix for new installations not being able to retrieve
# the latest cumulative update (2018-01 at time of writing).
# It is unknown if this is a specific issue with this CU or something else.
# The only workaround found so far is to allow the system to "settle", which
# somehow allows the system to be provided the latest updates.
# Unfortunately this "settling" takes a long time (15-30mins)
# Fingers crossed this is only a temporary issue...
# if ($updates.KB -like 'KB4053579') {
#     Write-Host "Sleeping for 30m due to a clean install not being able to retrieve the latest updates..."
#     Start-Sleep -s 1800
    
#     Write-Host "Performing another search for Windows Updates..."
#     $updates = Get-WindowsUpdate -Verbose
#     $updates | Format-List -Property KB,Title,Size
# }

# if ($updates.KB -like 'KB4053579') {
#     Write-Host "ERROR: WU still retrieving old updates"
#     Write-Host "ERROR: Increase timeout or find another workaround."
#     exit 1
# }

# Write-Host "Installing Windows Updates..."
# Install-WindowsUpdate -AcceptAll -IgnoreReboot -Verbose `
#     | Format-List -Property X,Result,KB,Size,Title

Write-Host "Installing pre-requisites..."
Add-Type -AssemblyName System.IO.Compression.Filesystem
$installPath = "C:\Windows\System32\WindowsPowerShell\v1.0\Modules"
if (!(Test-Path "$installPath\pswindowsupdate")) {
    [System.IO.Compression.ZipFile]::ExtractToDirectory(
        "C:\Windows\Temp\PSWindowsUpdate.zip", "$installPath"
    )
}
Import-Module PSWindowsUpdate

# Ignoring KB4053579 is a hackfix for new Win2016 installs.
# It requires 15-30 minutes of uptime before Windows Update is able to retrieve
# the real latest cumulative update.
Write-Host "Installing updates..."
Get-WUInstall -AcceptAll -IgnoreReboot -IgnoreUserInput `
    -Category "Critical Update","Security Update","Definition Update","Update Rollup" `
    -NotKBArticleID "KB4053579"

Write-Host "Cleaning up..."
Remove-Module PSWindowsUpdate
Remove-Item "c:\windows\system32\windowspowershell\v1.0\modules\pswindowsupdate" -Recurse

Write-Host "Completed installing Windows updates."
