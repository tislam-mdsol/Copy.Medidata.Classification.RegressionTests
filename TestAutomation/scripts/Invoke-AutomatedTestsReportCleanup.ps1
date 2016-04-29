param([string]$projectName)
$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path
$TestResultPath = $ScriptDir + '\' + $projectName + 'Results.html'

get-childItem $TestResultPath -recurse | ForEach {
(Get-Content $_ | ForEach {$_ -replace '&lt;img src', '<img src'}) |
Set-Content $_ -Encoding UTF8
(Get-Content $_ | ForEach {$_ -replace '/&gt;', '/>'}) |
Set-Content $_ -Encoding UTF8
(Get-Content $_ | ForEach {$_ -replace '&lt; table', '< table'}) |
Set-Content $_ -Encoding UTF8
}