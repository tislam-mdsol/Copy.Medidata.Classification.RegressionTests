param([string]$projectName)
$ScriptDir = Split-Path $script:MyInvocation.MyCommand.Path

$cmd1 =$ScriptDir + '\specflow.exe' 
$cmd2 ='nunitexecutionreport' 

$prm1= $ScriptDir + '\' + $projectName + '.csproj'
$prm2= '/xmlTestResult:' + $projectName + 'Results.xml'
$prm3= '/testOutput:' + $projectName + 'Results.txt'
$prm4= '/out:' + $projectName + 'Results.html'
$prm5= '/xsltFile:' + $ScriptDir + '\Reporting\NUnitExecutionReport\NUnitExecutionReport.xslt'

& $cmd1 $cmd2 $prm1 $prm2 $prm3 $prm4 $prm5
