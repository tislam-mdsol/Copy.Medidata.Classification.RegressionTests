@echo off

SET BasePath=%~dp0
SET IntegrationTestErrorLevelCode=0
SET TestProjectName=%1

"%BasePath%\NUnit\nunit-console.exe" %TestProjectName%.dll /xml:%TestProjectName%Results.xml

if %ERRORLEVEL% neq 0 SET IntegrationTestErrorLevelCode=%ERRORLEVEL%

if %IntegrationTestErrorLevelCode% neq 0 exit /b %IntegrationTestErrorLevelCode%