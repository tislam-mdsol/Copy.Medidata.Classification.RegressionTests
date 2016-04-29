SET SERVER=localhost
SET DB=coder_v1
SET USERNAME=developer
SET PASSWORD=developer

sqlcmd -S %SERVER% -d %DB% -U %USERNAME% -P %PASSWORD% -i spMetrics.sql
sqlcmd -S %SERVER% -d %DB% -U %USERNAME% -P %PASSWORD% -i spMetricsRunner.sql

sqlcmd -S %SERVER% -d %DB% -U %USERNAME% -P %PASSWORD% -Q "spMetricsRunner 1'" -k 1 -s "," -W -X -o output.txt

type output.txt | findstr /v "affected"  | findstr /v "^-" | findstr /v "^$" > output.csv


SendMail -s "Daily Metrics Generated" -m "Daily Metrics Generated. See Attachement." -a "output.csv"