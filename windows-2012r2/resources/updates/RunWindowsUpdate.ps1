$ErrorActionPreference = "Stop"

Write-Host "Installing pre-requisites..."
Add-Type -AssemblyName System.IO.Compression.Filesystem
$installPath = "C:\Windows\System32\WindowsPowerShell\v1.0\Modules"
if (!(Test-Path "$installPath\pswindowsupdate")) {
    [System.IO.Compression.ZipFile]::ExtractToDirectory(
        "C:\Windows\Temp\PSWindowsUpdate.zip", "$installPath"
    )
}
Import-Module PSWindowsUpdate

Write-Host "Installing updates..."
Get-WUInstall -AcceptAll -IgnoreReboot -IgnoreUserInput -verbose | `
    Format-List -Property Status,KB,Size,Title

Write-Host "Listing any remaining updates..."
Get-WUList -IgnoreReboot -IgnoreUserInput -verbose | `
    Format-List -Property Status,KB,Size,Title

Write-Host "Cleaning up..."
Remove-Item "c:\windows\system32\windowspowershell\v1.0\modules\pswindowsupdate" -Recurse

Write-Host "Completed installing Windows updates."
