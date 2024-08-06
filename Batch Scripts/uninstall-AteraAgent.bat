@echo off

set program=AteraAgent
setlocal enabledelayedexpansion
set "find="
for /f "tokens=*" %%i in ('wmic product get name ^| findstr "Atera"') do (
    set "find=%%i"
)

if defined find (
    wmic product where name="AteraAgent" call uninstall
) else (
    echo Atera Agent is Not installed
)
