@echo off
taskkill /IM outlook.exe /F

set "sourceDirectory=%USERPROFILE%\AppData\Local\Microsoft\Outlook"
set "destinationDirectory=%CD%"

xcopy "%sourceDirectory%\*.pst" "%destinationDirectory%" /Y

if %ERRORLEVEL% equ 0 (
    echo Backup was successful
) else (
    echo Backup failed
)

exit /b %ERRORLEVEL%
