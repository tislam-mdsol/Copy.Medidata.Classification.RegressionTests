@echo off

SET BasePath=%~dp0
SET AutomatedTestErrorLevelCode=0
SET TestProjectName=%1

IF "%2"=="" ( SET "ProfileName=Default.srprofile" ) ELSE ( SET "ProfileName=%2.srprofile" )

call "%BasePath%runtests.bat" %ProfileName%

if %errorlevel% neq 0 SET AutomatedTestErrorLevelCode=%errorlevel%

"%BasePath%Medidata.Specrun.Reporting.exe" %TestProjectName% %2

Powershell.exe -ExecutionPolicy Unrestricted -Command "& '%BasePath%\Invoke-AutomatedTestsReport.ps1' -projectName %TestProjectName%"; exit $LASTEXITCODE

if %errorlevel% neq 0 SET AutomatedTestErrorLevelCode=%errorlevel%

Powershell.exe -ExecutionPolicy Unrestricted -Command "& '%BasePath%\Invoke-AutomatedTestsReportCleanup.ps1' -projectName %TestProjectName%"; exit $LASTEXITCODE

if %errorlevel% neq 0 SET AutomatedTestErrorLevelCode=%errorlevel%

if %AutomatedTestErrorLevelCode% neq 0 exit /b %AutomatedTestErrorLevelCode%