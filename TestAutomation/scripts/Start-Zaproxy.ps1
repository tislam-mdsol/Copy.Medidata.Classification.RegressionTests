Write-Host "`n`n`n"
Write-Host '*******************************************************************************'
Write-Host '*                     B E G I N  Start-Zaproxy                                *'
Write-Host '*******************************************************************************'
$zaproxyDir = 'C:\Program Files (x86)\OWASP\Zed Attack Proxy\'
cd $zaproxyDir

#start zaproxy and load session
& .\ZAP.exe -session 'C:\Program Files (x86)\OWASP\Zed Attack Proxy\session\CoderAdmin_Sandbox\CoderAdmin_Sandbox.session' -daemon

#set forced user mode
do 
{
    $response = Invoke-WebRequest 'http://localhost:8080/JSON/forcedUser/action/setForcedUserModeEnabled/?zapapiformat=JSON&apikey=&boolean=true'
} until ($response.StatusCode -eq 200)
Write-Host '*******************************************************************************'
Write-Host '*                       E N D  Start-Zaproxy                                  *'
Write-Host '*******************************************************************************'
