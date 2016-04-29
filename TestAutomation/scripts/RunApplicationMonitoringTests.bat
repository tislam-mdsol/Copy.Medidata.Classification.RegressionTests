CALL bundle install
CALL bundle exec rake config:deploy
CALL RunAllAutomatedTestScripts.bat Coder.ApplicationMonitoringTests