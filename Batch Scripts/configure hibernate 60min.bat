@echo off
echo Setting the computer to hibernate after 60 minutes of inactivity...

:: Define o tempo de espera em segundos (60 minutos)
set tempo_de_espera=3600

:: Define o caminho do arquivo temporário
set arquivo_temporario=%temp%\temp_idle_time.txt

:: Obtém o tempo atual do sistema
for /f "tokens=1 delims=." %%a in ('wmic os get LocalDateTime ^| find "."') do set dt=%%a

:: Calcula o tempo em que o computador deve hibernar
set /a hibernar_em=%dt:~0,4%*365*24*60*60 + %dt:~4,2%*30*24*60*60 + %dt:~6,2%*24*60*60 + %dt:~8,2%*60*60 + %dt:~10,2%*60 + %dt:~12,2% + %tempo_de_espera%

:: Cria o arquivo temporário
echo %hibernar_em% > "%arquivo_temporario%"

:: Inicia o monitoramento de inatividade
powercfg -change -monitor-timeout-ac %tempo_de_espera%
powercfg -change -monitor-timeout-dc %tempo_de_espera%
powercfg -change -standby-timeout-ac %tempo_de_espera%
powercfg -change -standby-timeout-dc %tempo_de_espera%
powercfg -change -hibernate-timeout-ac %tempo_de_espera%
powercfg -change -hibernate-timeout-dc %tempo_de_espera%

:: Monitora a atividade do usuário
:monitorar
timeout /t 60 /nobreak > nul
for /f "tokens=3" %%s in ('quser ^| find /i "%username%"') do (
    if "%%s" == "Active" (
        echo %dt% > "%arquivo_temporario%"
    )
)
for /f %%t in ('type "%arquivo_temporario%"') do (
    if %dt% geq %%t (
        shutdown /h
        exit
    )
)
goto monitorar