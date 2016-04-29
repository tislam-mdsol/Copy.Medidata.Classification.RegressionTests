Write-Host "`n`n`n"
Write-Host '*******************************************************************************'
Write-Host '*                       B E G I N  Stop-Zaproxy                               *'
Write-Host '*******************************************************************************'

Invoke-WebRequest 'http://localhost:8080/JSON/core/action/shutdown/?zapapiformat=JSON&apikey='

Write-Host '*******************************************************************************'
Write-Host '*                         E N D  Stop-Zaproxy                                 *'
Write-Host '*******************************************************************************'
