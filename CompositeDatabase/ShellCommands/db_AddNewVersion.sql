@echo off
REM: Authentication type: Windows NT
REM: Usage: CommandFilename [Server] [Database] [MedicalDictionaryType] [DictionaryOID] [DictionaryName] [VersionOID] [VersionName] [Locale] [ReleaseDate]

if '%1' == '' goto usage
if '%2' == '' goto usage

if '%3' == '' goto usage
if '%4' == '' goto usage
if '%5' == '' goto usage
if '%6' == '' goto usage
if '%7' == '' goto usage
if '%8' == '' goto usage
if '%9' == '' goto usage
REM: if '%10' == '' goto usage


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

echo Starting "spAllInOneAddNewVersion '%3', '%4', '%5', '%6', '%7', '%8', '%9', '%_dir%'"
osql -S %1 -d %2 -E -b -n -Q "spAllInOneAddNewVersion '%3', '%4', '%5', '%6', '%7', '%8', '%9', '%_dir%'"
if %ERRORLEVEL% NEQ 0 goto errors


echo.
echo Script execution completed successfully!
goto finish

REM: How to use screen
:usage
echo.
echo Usage: MyScript Server Database MedicalDictionaryType DictionaryOID DictionaryName VersionOID VersionName Locale ReleaseDate
echo Server: the name of the target SQL Server
echo Database: the name of the target database
echo MedicalDictionaryType: the name of the type of dictionary (MedDRA, WhoDRUGB2, WhoDRUGC)
echo DictionaryOID : the OID of the dictionary (WhoDRUGC, WhoDRUGCSample, etc)
echo DictionaryName: the name of the dictionary (MedDRA, MedDRALikeProprietaryData, etc)
echo VersionOID: the OID of the version
echo VersionName: the name of the version
echo Locale: the abbrev. language in which the data is being loaded (eng, jpn, loc)
echo ReleaseDate: The version release date as indicated by the vendor YYYY-MM-DD (2010-01-12)
echo
echo Directory: the filesystem directory where the dictionary files are placed (include the last '\')
echo.
echo Example: MyScript.cmd DD58ZMLF1\AVINSTANCE2 Coder MedDRA MyDictionary MyDictionary 1.0 1.0 eng 2010-01-12
echo.
echo C:\testDir\
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
