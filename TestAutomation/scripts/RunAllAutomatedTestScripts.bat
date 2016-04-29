@echo off

SET BasePath=%~dp0
SET AutomatedTestErrorLevelCode=0
SET TestProjectName=%1

Powershell.exe -ExecutionPolicy Unrestricted -Command "& '%BasePath%\Invoke-AutomatedTests.ps1' -projectName %TestProjectName%"; exit $LASTEXITCODE

if %errorlevel% neq 0 SET AutomatedTestErrorLevelCode=%errorlevel%

Powershell.exe -ExecutionPolicy Unrestricted -Command "& '%BasePath%\Invoke-AutomatedTestsReport.ps1' -projectName %TestProjectName%"; exit $LASTEXITCODE

if %errorlevel% neq 0 SET AutomatedTestErrorLevelCode=%errorlevel%

Powershell.exe -ExecutionPolicy Unrestricted -Command "& '%BasePath%\Invoke-AutomatedTestsReportCleanup.ps1' -projectName %TestProjectName%"; exit $LASTEXITCODE

if %errorlevel% neq 0 SET AutomatedTestErrorLevelCode=%errorlevel%

if %AutomatedTestErrorLevelCode% neq 0 exit /b %AutomatedTestErrorLevelCode%