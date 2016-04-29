@echo off
@pushd %~dp0

@set profile=%1
@if "%profile%" == "" set profile=Default.srprofile

@set baseFolderParam = "%~dp0..\.."
SpecRun.exe buildserverrun "%~dp0\ConfigData\%profile%" /baseFolder:"%baseFolderParam%" /log:specrun.log /outputFolder:"%~dp0 %2 %3 %4 %5" >&2

@popd
