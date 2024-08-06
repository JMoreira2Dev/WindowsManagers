@echo off
setlocal

:DetectWindowsVersion
for /f "tokens=4-5 delims=[.] " %%i in ('ver') do (
    set MAJOR=%%i
    set MINOR=%%j
)

if "%MAJOR%"=="10" (
    if "%MINOR%"=="0" (
        for /f "tokens=4-5 delims=. " %%i in ('wmic os get version') do set BUILD=%%i
        if "%BUILD%" geq "22000" (
            echo Windows 11 Detected!
            echo Waiting 10 seconds...
            timeout /t 10 /nobreak >nul
        ) else (
            echo Windows 10 Detected!
            echo Waiting 5 seconds...
            timeout /t 5 /nobreak >nul
        )
        call :WindowsCleaning
    )
) else if "%MAJOR%"=="6" (
    if "%MINOR%"=="3" (
        echo Windows 8.1 Detected!
        call :WindowsCleaning
    ) else if "%MINOR%"=="2" (
        echo Windows 8 Detected!
        call :WindowsCleaning
    ) else if "%MINOR%"=="1" (
        echo Windows 7 Detected!
        call :WindowsCleaning
    ) else if "%MINOR%"=="0" (
        echo Windows Vista Detected!
        call :WindowsCleaning
    )
) else (
    echo [!] Unsupported Windows version detected.
)

endlocal
exit /b %ERRORLEVEL%

call :DetectWindowsVersion

:WindowsCleaning
echo(
echo [+] Running SFC /scannow ...
sfc /scannow
echo(

echo [+] Starting to remove temporary files...
timeout /t 8 /nobreak > null

for /d %%i in ("%TEMP%\*") do (
    echo [+] Deleting folder "%%i"...
    rd /s /q "%%i" 2>nul || echo "%%i" is being used by another process.
)
for %%i in ("%TEMP%\*") do (
    echo [+] Deleting file "%%i"...
    del /q /f "%%i" 2>nul || echo "%%i" is being used by another process.
)
echo All files removed!
timeout /t 8 /nobreak > null

echo(
echo [+] Cleaning cookies from Google Chrome...
powershell -Command "if (Test-Path \"$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cookies\") { Remove-Item \"$env:LOCALAPPDATA\Google\Chrome\User Data\Default\Cookies\" -Force } else { Write-Host 'The cookie file has already been cleared.' }"

timeout /t 8 /nobreak > null

echo(
echo [+] Cleaning cookies from Microsoft Edge...
powershell -Command "if (Test-Path \"$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cookies\") { Remove-Item \"$env:LOCALAPPDATA\Microsoft\Edge\User Data\Default\Cookies\" -Force } else { Write-Host 'The cookie file has already been cleared.' }"

timeout /t 8 /nobreak > null

echo(
echo [+] Cleaning system trash...
powershell -Command "Clear-RecycleBin -Force" 2>nul || echo "Recycle Bin is empty."

timeout /t 3 /nobreak > null

echo(
echo [!] Finished!
timeout /t 5 /nobreak > null
goto :eof
