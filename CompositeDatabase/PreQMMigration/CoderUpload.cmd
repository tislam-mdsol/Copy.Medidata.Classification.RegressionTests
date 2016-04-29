@echo off

For /f "tokens=1-3 delims=/: " %%a in ('time /t') do (set StartTime=%%a:%%b %%c)
REM: Authentication type: Windows NT
REM: Usage: CommandFilename [User] [Password] [Database] [Server]

set user=%1
set password=%2
set database=%3
set server=%4
set ravetoken=%5

shift

if "%user%" == "" goto usage
if "%password%" == "" goto usage
if "%server%" == "" goto usage

if '%server%' == '/?' goto usage
if '%server%' == '-?' goto usage
if '%server%' == '?' goto usage
if '%server%' == '/help' goto usage

echo 0. Create table (in Coder) if it does not exist

sqlcmd -S %server% -d %database% -i RaveExtractCreateTable.sql
if %ERRORLEVEL% NEQ 0 goto errors

echo 1. Import translated data from Rave

bcp [%database%].dbo.RaveCoderExtract in Data\RaveCoderExtract.txt -f Data\RaveCoderExtract.fmt -U %user% -P %password% -S %server%
if %ERRORLEVEL% NEQ 0 goto errors

echo 2. TODO : correlate data

sqlcmd -S %server% -d %database% -I -i spCorrelateCoderTasks.sql
if %ERRORLEVEL% NEQ 0 goto errors

sqlcmd -S %server% -d %database% -E -b -n -Q "exec spCorrelateCoderTasks $(ravetoken)"
if %ERRORLEVEL% NEQ 0 goto errors
echo.
echo Script execution completed successfully!

For /f "tokens=1-3 delims=/: " %%a in ('time /t') do (set EndTime=%%a:%%b %%c)
echo.
echo Finished executing Import script successfully. Start-time: %StartTime% End-Time: %EndTime%.

goto finish

REM: How to use screen
:usage
echo.
echo Usage: CommandFilename [User] [Password] [Database] [Server]
echo User: The database user
echo Password: The database user password
echo Database: the name of the target database
echo Server: The target SQL server name
echo.
echo Example: MyScript.cmd developer developer coder_v1 localhost
echo.
goto done

REM: error handler
:errors
echo.
echo WARNING! Error(s) were detected!
echo --------------------------------
echo.

echo .
echo Execution of import script failed.

echo.
goto done

REM: finished execution
:finish
:done
@echo on 