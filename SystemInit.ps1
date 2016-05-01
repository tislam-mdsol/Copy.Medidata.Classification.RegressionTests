param([string]$psakeScriptFolder = "psake", [string]$psakeScript = "default.ps1", [string]$psakeTask = "default")

$scriptDir = Split-Path $script:MyInvocation.MyCommand.Path
$initFile  = "dotnet_init.ps1"
$helperUrl = "https://s3.amazonaws.com/aws-mdsol-dotnet-build/scripts/$initFile"
$initDir   = "$scriptDir\$psakeScriptFolder"
$outFile   = "$initDir\$initFile"

if(-not(Test-Path $initDir)){

    New-Item $initDir -type Directory
}

Invoke-WebRequest $helperUrl -OutFile $outFile

&"$outFile" "$psakeScript" "$psakeTask"