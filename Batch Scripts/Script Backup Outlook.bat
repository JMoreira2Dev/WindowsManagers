@echo off
REM Fechar o Outlook caso esteja aberto
taskkill /IM outlook.exe /F

REM Defina os diretórios de origem e destino
set "sourceDirectory=%USERPROFILE%\AppData\Local\Microsoft\Outlook"
set "destinationDirectory=%CD%"

REM Copie os arquivos, sobrescrevendo os existentes
xcopy "%sourceDirectory%\*.pst" "%destinationDirectory%" /Y

REM Verificar se a cópia foi bem-sucedida
if %ERRORLEVEL% equ 0 (
    REM Exibir uma mensagem de conclusão
    echo Backup was successful
    
    REM Desligar o computador após a cópia
) else (
    REM Exibir uma mensagem de erro
    echo Backup failed
)

exit /b %ERRORLEVEL%
