Write-Host "Cleaning sxs images ..."
dism.exe /online /Cleanup-Image /StartComponentCleanup /ResetBase
