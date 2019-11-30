$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

# Builds
& packer.exe build -only=virtualbox-iso desktop-base.json
if ($LASTEXITCODE -ne 0) { exit 1 }
& packer.exe build -only=virtualbox-ovf desktop-baseupdates.json
if ($LASTEXITCODE -ne 0) { exit 1 }
& packer.exe build -only=virtualbox-ovf desktop-containers.json
if ($LASTEXITCODE -ne 0) { exit 1 }

# Vagrant Boxes
& packer.exe build "-var-file=vars/desktop-vagrant-nocm.vars.json" desktop-vagrant.json
if ($LASTEXITCODE -ne 0) { exit 1 }
& packer.exe build "-var-file=vars/desktop-vagrant-containers.vars.json" desktop-vagrant.json
if ($LASTEXITCODE -ne 0) { exit 1 }
