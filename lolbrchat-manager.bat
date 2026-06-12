@ECHO OFF
SETLOCAL EnableDelayedExpansion
CLS
ECHO Verificando as permissoes de Administrador...
net session >nul 2>&1
IF %errorLevel% == 0 (
   ECHO Sucesso: O programa foi executado como Administrador.
) ELSE (
   ECHO Falha: Feche o programa e execute como Administrador!
   PAUSE >nul
   EXIT
)

SET "HOSTS=%WINDIR%\System32\drivers\etc\hosts"

TITLE LOLBR OFFLINE CHAT v3
ECHO +-------------------------------------------------------+
ECHO ^|                 LOLBR OFFLINE CHAT - MENU             ^|
ECHO +-------------------------------------------------------+
ECHO ^|                                                       ^|
ECHO ^|                1: Aparecer como invisivel             ^|
ECHO ^|                2: Aparecer como disponivel            ^|
ECHO ^|                                                       ^|
ECHO +-------------------------------------------------------+
ECHO.
ECHO Redes sociais:
ECHO   github.com/brunocarazato
ECHO   youtube.com/SenhorBizu
ECHO   instagram.com/senhorbizu
ECHO Contribudor:
ECHO   github.com/guganeri
ECHO.
SET /p "op=Digite o que deseja (1/2) ?: "

IF "%op%"=="1" (
	REM Remove regras antigas de firewall (metodo antigo, ineficaz com Kaspersky)
	netsh advfirewall firewall delete rule name="LoL Chat" >nul 2>&1

	REM Limpa entradas antigas do hosts para nao duplicar
	findstr /V /C:"chat.si.riotgames.com" /C:"LoL Chat Offline" "%HOSTS%" > "%TEMP%\hosts.tmp"

	REM Adiciona o bloqueio: redireciona os servidores de chat da Riot para lugar nenhum
	(
		ECHO # LoL Chat Offline - inicio
		ECHO 0.0.0.0 br.chat.si.riotgames.com
		ECHO 0.0.0.0 sa1.chat.si.riotgames.com
		ECHO 0.0.0.0 sa2.chat.si.riotgames.com
		ECHO 0.0.0.0 la1.chat.si.riotgames.com
		ECHO 0.0.0.0 la2.chat.si.riotgames.com
		ECHO 0.0.0.0 na1.chat.si.riotgames.com
		ECHO 0.0.0.0 na2.chat.si.riotgames.com
		ECHO # LoL Chat Offline - fim
	) >> "%TEMP%\hosts.tmp"

	COPY /Y "%TEMP%\hosts.tmp" "%HOSTS%" >nul
	IF ERRORLEVEL 1 (
		ECHO.
		ECHO ERRO: Nao foi possivel gravar o arquivo hosts!
		ECHO Se o Kaspersky exibir um alerta, escolha PERMITIR e rode de novo.
		PAUSE
		EXIT
	)
	DEL "%TEMP%\hosts.tmp" >nul 2>&1
	ipconfig /flushdns >nul

	ECHO.
	ECHO Sucesso! Os servidores de chat foram bloqueados no arquivo hosts.
	ECHO.
	SET /p "kill=Deseja fechar o cliente da Riot agora? (s/n): "
	IF /I "!kill!"=="s" (
		taskkill /F /IM LeagueClientUx.exe >nul 2>&1
		taskkill /F /IM LeagueClient.exe >nul 2>&1
		taskkill /F /IM RiotClientUx.exe >nul 2>&1
		taskkill /F /IM RiotClientServices.exe >nul 2>&1
		ECHO Cliente fechado. Abra o jogo novamente e voce estara invisivel.
	) ELSE (
		ECHO Ok. Feche e reabra o cliente da Riot manualmente para ficar invisivel.
	)
) ELSE IF "%op%"=="2" (
	REM Remove as entradas de bloqueio do hosts
	findstr /V /C:"chat.si.riotgames.com" /C:"LoL Chat Offline" "%HOSTS%" > "%TEMP%\hosts.tmp"
	COPY /Y "%TEMP%\hosts.tmp" "%HOSTS%" >nul
	DEL "%TEMP%\hosts.tmp" >nul 2>&1
	ipconfig /flushdns >nul
	netsh advfirewall firewall delete rule name="LoL Chat" >nul 2>&1

	ECHO.
	ECHO Sucesso! O bloqueio foi removido.
	ECHO Reinicie o cliente da Riot para o chat voltar a conectar.
) ELSE (
	ECHO Valor invalido! Execute novamente o programa. Veja as opcoes no menu!
)

PAUSE