$ErrorActionPreference = "Stop"

# Workaround for https://goo.gl/WPsbGr
Start-Transcript -Path "$env:TEMP\Temp.log"

Write-Host "Installing pre-requisites..."
$installPath = "C:\Windows\System32\WindowsPowerShell\v1.0\Modules"
$shell = New-Object -com Shell.Application
$zip = $shell.NameSpace("C:\Windows\Temp\PSWindowsUpdate.zip")
foreach($item in $zip.items()) {
    $shell.Namespace($installPath).copyhere($item)
}
Import-Module PSWindowsUpdate

Write-Host "Installing updates..."
Get-WUInstall -AcceptAll -IgnoreReboot -IgnoreUserInput -Category "Critical Update","Security Update","Definition Update","Update Rollup"

Write-Host "Cleaning up..."
Remove-Module PSWindowsUpdate
Remove-Item "$installPath\pswindowsupdate" -Recurse

Write-Host "Completed installing Windows updates."

Stop-Transcript