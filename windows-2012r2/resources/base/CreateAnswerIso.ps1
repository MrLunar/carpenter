$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

##
# Requires mkisofs to be available in your PATH.
# https://opensourcepack.blogspot.co.il/p/cdrtools.html
##

$isoFolder = "answer-iso"
if (test-path $isoFolder){
  remove-item $isoFolder -Force -Recurse
}

mkdir $isoFolder

copy resources\base\2012r2-desktop\Autounattend-Hyperv.xml $isoFolder\Autounattend.xml
copy resources\base\ConfigureWinRmInsecure.cmd $isoFolder\

mkisofs.exe -r -iso-level 4 -UDF -o resources\base\answer.iso $isoFolder

if (test-path $isoFolder){
  remove-item $isoFolder -Force -Recurse
}