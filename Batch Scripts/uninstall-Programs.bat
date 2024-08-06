@echo off

set /P "program=Enter Program Name: "
setlocal enabledelayedexpansion
set "find="
for /f "tokens=*" %%i in ('wmic product get name ^| findstr "%program%"') do (
    set "find=%%i"
)

if defined find (
    echo %program% is Installed
    echo Proceeding with the uninstall...
    wmic product where name="%program%" call uninstall
) else (
    echo %program% is Not installed
)

pause