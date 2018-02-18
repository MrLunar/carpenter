$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

$tempDir = "C:\Windows\Temp"
$wc = New-Object Net.WebClient

Write-Host "Downloading servicing stack update (KB3020369)..."
$url = "http://download.windowsupdate.com/d/msdownload/update/software/updt/2015/04/windows6.1-kb3020369-x64_5393066469758e619f21731fc31ff2d109595445.msu"
$wc.DownloadFile($url, "$tempDir\kb3020369.msu")

Write-Host "Installing servicing stack update (KB3020369)..."
Start-Process "wusa.exe" -ArgumentList "$tempDir\kb3020369.msu /quiet /norestart" -Wait

Write-Host "Downloading rollup update (KB3125574)..."
$url = "http://download.windowsupdate.com/d/msdownload/update/software/updt/2016/05/windows6.1-kb3125574-v4-x64_2dafb1d203c8964239af3048b5dd4b1264cd93b9.msu"
$wc.DownloadFile($url, "$tempDir\kb3125574.msu")

Write-Host "Installing rollup update (KB3125574)..."
Start-Process "wusa.exe" -ArgumentList "$tempDir\kb3125574.msu /quiet /norestart" -Wait

Write-Host "Cleaning up..."
Remove-Item "$tempDir\kb3020369.msu"
Remove-Item "$tempDir\kb3125574.msu"