$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

Write-Output "Waiting for .NET Framework optimisations to complete..."

while (Get-Process "ngen" -ErrorAction "SilentlyContinue") {
    Start-Sleep 5
}

Write-Output ".NET Framework optimisations complete."