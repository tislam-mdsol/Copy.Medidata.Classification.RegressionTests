param([string]$projectName)
$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path

$cmd = $ScriptDir + '\NUnit\nunit-console'

$prm1= $projectName + '.dll'
$prm2= '/labels'
$prm3= '/include:VAL'
$prm4= '/xml:' + $projectName + 'Results.xml'
$prm5= '/out:' + $projectName + 'Results.txt'

& $cmd $prm1 $prm2 $prm3 $prm4 $prm5
