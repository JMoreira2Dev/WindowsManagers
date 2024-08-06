@echo off
setlocal

:WindowsCleaning
sfc /scannow > nul

for /d %%i in ("%TEMP%\*") do (
    rd /s /q "%%i" 2>nul
)
for %%i in ("%TEMP%\*") do (
    del /q /f "%%i" 2>nul
)

powershell -Command "if (Test-Path \"$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cookies\") { Remove-Item \"$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cookies\" -Force } else {}"

powershell -Command "if (Test-Path \"$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cookies\") { Remove-Item \"$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cookies\" -Force } else {}"

powershell -Command "Clear-RecycleBin -Force" 2>nul
goto :eof

call :WindowsCleaning 2>nul
