@echo off
REM: Authentication type: Windows NT
REM: Usage: CommandFilename [Server] [Database]

if '%1' == '' goto usage
if '%2' == '' goto usage

if '%1' == '/?' goto usage
if '%1' == '-?' goto usage
if '%1' == '?' goto usage
if '%1' == '/help' goto usage

SET /P _dir=Please enter Directory:
If "%_dir%"=="" goto :sub_error


echo.
echo Please make sure no processes are running against the following database:
echo.
echo %1.%2
echo.
echo BACKUP THE DATABASE!!!
echo.
echo Press Ctrl-C to abort or
pause

echo Starting "spUpdateRanksPeriodical"
osql -S %1 -d %2 -E -b -n -Q "spUpdateRanksPeriodical"
if %ERRORLEVEL% NEQ 0 goto errors


echo.
echo Script execution completed successfully!
goto finish

REM: How to use screen
:usage
echo.
echo Usage: MyScript Server Database
echo Server: the name of the target SQL Server
echo Database: the name of the target database
echo.
echo Example: MyScript.cmd DD58ZMLF1\AVINSTANCE2 Coder
echo.
echo.
goto done

REM: error handler
:errors
echo.
echo WARNING! Error(s) were detected!
echo --------------------------------
echo Please evaluate the situation and, if needed,
echo restart this command file. You may need to
echo supply command parameters when executing
echo this command file.
echo.
pause
goto done

REM: finished execution
:finish
:done
@echo on
 