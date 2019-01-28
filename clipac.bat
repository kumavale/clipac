@echo off

openfiles >nul
if errorlevel 1 (
  powershell start-process %~f0 -ArgumentList '/k ""cd /d %CD%""' -verb runas
  exit /b
)

if "%1"=="/h" (
  CALL :Help
  exit /b
) else if "%1"=="-h" (
  CALL :Help
  exit /b
) else if "%1"=="--help" (
  CALL :Help
  exit /b
)

REM init
title clipac
SET HOSTNAME=clipac
SET USER=^>^ 
SET CONF=#^ 
SET GLOCONF=(config)#^ 
SET INTCONF=(config-if)#^ 
SET MODE=%USER:>=^>%
SET INTERFACE=
SET IPADDR=
SET NETMASK=
SET GATEWAY=
SET MARKER=                                                                ^^^^


:LOOP
rem setlocal enabledelayedexpansion
set command=nullptr
set /p command="%HOSTNAME%%MODE%"
CALL :Trim %command%

if "%command%"=="nullptr" (
  goto :LOOP
)
if "%first:~0,1%"=="!" (
  goto :LOOP
)


if "%MODE%"=="%USER%" (
  echo %command% | findstr /I /R "\<l\> \<lo\> \<log\> \<logo\> \<logou\> \<logout\>" >nul
  if not errorlevel 1 (
    title & exit /b
  )
  echo %command% | findstr /I /R "\<en\> \<ena\> \<enab\> \<enabl\> \<enable\>" >nul
  if not errorlevel 1 (
    set MODE=%CONF%
    goto :LOOP
  )
  echo %command% | findstr /I /R "\<sh\> \<sho\> \<show\>" >nul
  if not errorlevel 1 (
    CALL :Show %command%
    goto :LOOP
  )


) else if "%MODE%"=="%CONF%" (
  echo %command% | findstr /I /R "\<sh\> \<sho\> \<show\>" >nul
  if not errorlevel 1 (
    CALL :Show %command%
    goto :LOOP
  )
  echo %command% | findstr /I /R "\<disa\> \<disab\> \<disabl\> \<disable\>" >nul
  if not errorlevel 1 (
    set MODE=%USER:>=^>%
    goto :LOOP
  )


) else if "%MODE%"=="%GLOCONF%" (
  echo %command% | findstr /I /R^
   "\<h\> \<ho\> \<hos\> \<host\> \<hostn\> \<hostna\> \<hostnam\> \<hostname\>" >nul
  if not errorlevel 1 (
    CALL :Hostname %command%
    goto :LOOP
  )
  echo %command% | findstr /I /R^
   "\<in\> \<int\> \<inte\> \<inter\> \<interf\> \<interfa\> \<interfac\> \<interface\>" >nul
  if not errorlevel 1 (
    CALL :Interface %command%
    goto :LOOP
  )


) else if "%MODE%"=="%INTCONF%" (
  echo %command% | findstr /I /R "\<ip\>" >nul
  if not errorlevel 1 (
    CALL :Ip %command%
    goto :LOOP
  )
  echo %command% | findstr /I /R^
   "\<in\> \<int\> \<inte\> \<inter\> \<interf\> \<interfa\> \<interfac\> \<interface\>" >nul
  if not errorlevel 1 (
    CALL :Interface %command%
    goto :LOOP
  )
  echo %command% | findstr /I /R^
   "\<sh\> \<shu\> \<shut\> \<shutd\> \<shutdo\> \<shutdow\> \<shutdown\>" >nul
  if not errorlevel 1 (
    CALL :Shutdown %command%
    goto :LOOP
  )

)


echo %command% | findstr /I /R "\<ex\> \<exi\> \<exit\> \<conf\> \<confi\> \<config\> \<configu\> \<configur\> \<configure\> end" >nul
if not errorlevel 1 (
  CALL :Mode %command%
  goto :LOOP
)

echo %command% | findstr /I /R "\<help\>" >nul
if not errorlevel 1 (
  CALL :Help
  goto :LOOP
)

echo %command% | findstr /I /R "\<quit\>" >nul
if not errorlevel 1 (
  title & exit /b
)


CALL :Error %command%
CALL :Usage

goto :LOOP


:Hostname
SET HOSTNAME=%2
exit /b


:Interface
rem if "%MODE%"=="%GLOCONF%" (
  netsh interface ip show interface | findstr /I /R "\<%2\>" >nul
  if not errorlevel 1 (
    SET INTERFACE=%2
    SET MODE=%INTCONF:)=^)%
    exit /b
  )
CALL :Error %2 %3 %4 %5 %6 %7 %8 %9
exit /b


:Mode
echo %* | findstr /I /R^
 "\<conf\> \<confi\> \<config\> \<configu\> \<configur\> \<configure\>" >nul
if not errorlevel 1 (
  echo %* | findstr /I /R^
   "\<t\> \<te\> \<ter\> \<term\> \<termi\> \<termin\> \<termina\> \<terminal\>" >nul
    if not errorlevel 1 (
      SET MODE=%GLOCONF:)=^)%
      exit /b
    )
)
echo %* | findstr /I /R "\<ex\> \<exi\> \<exit\>" >nul
if not errorlevel 1 (
  if "%MODE%"=="%INTCONF%" (
    SET MODE=%GLOCONF:)=^)%
  ) else if "%MODE%"=="%GLOCONF%" (
    SET MODE=%CONF:)=^)%
  )
  exit /b
)
echo %* | findstr /I /R "\<end\>" >nul
if not errorlevel 1 (
  SET MODE=%CONF:)=^)%
  exit /b
)
CALL :Error %*
exit /b


:Show
echo %* | findstr /I /R "\<ip\>" >nul
if not errorlevel 1 (
  echo %* | findstr /I /R^
   "\<in\> \<int\> \<inte\> \<inter\> \<interf\> \<interfa\> \<interfac\> \<interface\>" >nul
  if not errorlevel 1 (
    if not "%4" == "" (
      powershell " & netsh interface ip show ipaddresses | Select-String -Context 0,4 %4"
      netsh interface ip show ipaddresses | findstr /I /R "%4" >nul
      if not errorlevel 1 (
        exit /b
      )
    )
    CALL :Error %4 %5 %6 %7 %8 %9
    exit /b
  ) else (
    netsh interface ip show ipaddresses
    exit /b
  )
)
echo %* | findstr /I /R^
 "\<in\> \<int\> \<inte\> \<inter\> \<interf\> \<interfa\> \<interfac\> \<interface\>" >nul
if not errorlevel 1 (
  netsh interface ip show interface
  exit /b
)
CALL :Error %2 %3 %4 %5 %6 %7 %8 %9
exit /b


:Ip
echo %2 | findstr /I /R "\<a\> \<ad\> \<add\> \<addr\> \<addre\> \<addres\> \<address\>" >nul
if not errorlevel 1 (
  echo %3 | findstr /I /R "\<d\> \<dh\> \<dhc\> \<dhcp\>" >nul
  if not errorlevel 1 (
  netsh interface ip set address "%INTERFACE%" dhcp
    if not errorlevel 1 (
      echo success^!
    )
    exit /b
  ) else (
    netsh interface ip set address "%INTERFACE%" static %3 %4 %5
    if not errorlevel 1 (
      echo success^!
      set IPADDR=%3
      set NETMASK=%4
      set GATEWAY=%5
      exit /b
    )
    CALL :Error %3 %4 %5 %6 %7 %8 %9
    exit /b
  )
)
CALL :Error %2 %3 %4 %5 %6 %7 %8 %9
exit /b


:Shutdown
echo %* | findstr /I /R "\<n\> \<no\>" >nul
if not errorlevel 1 (
  netsh interface set interface %INTERFACE% admin=enable
  exit /b
) else (
  netsh interface set interface %INTERFACE% admin=disable
  exit /b
)

CALL :Error %2 %3 %4 %5 %6 %7 %8 %9
exit /b


:STRLEN
set str=%*
:STRLOOP
if not "%str%"=="" (
  set str=%str:~1%
  set /a len=%len%+1
  goto :STRLOOP
)
exit /b


:Trim
set first=%*
exit /b


:Help
echo.
echo Detailed description is `doc/clipac.txt`.
echo.
echo.
echo  [ Example ]
echo.
echo ^# show interface
echo.
echo Idx     Met         MTU          State                Name
echo ---  ----------  ----------  ------------  ---------------------------
echo   6          40        1500  connected     Wi-Fi
echo  10           5        1500  disconnected  Ethernet
echo.
echo clipac^# ! Remember the "Name".
echo clipac^# conf t
echo clipac(config^)^# int Ethernet
echo clipac(config-if^)^# ip address 10.0.0.1 255.255.255.0 10.0.0.254
echo clipac(config-if^)^# ip address dhcp
echo clipac(config-if^)^# end
echo clipac^#
echo clipac^# quit
echo.
exit /b


:Usage
echo Try ^`help^` for more information.
exit /b


:Error
setlocal enabledelayedexpansion
set len=0
CALL :STRLEN %*
set argslen=%len%
if "%MODE%"=="%USER%" (
  set len=2
) else if "%MODE%"=="%CONF%" (
  set len=2
) else if "%MODE%"=="%GLOCONF%" (
  set len=10
) else (
  set len=13
)
CALL :STRLEN %HOSTNAME%
CALL :STRLEN %command%
set /a len=%len%-%argslen%+2
set len=!MARKER:~-%len%!
echo %len%
rem echo %%^*:%*
rem echo argslen:%argslen%
rem echo len:%len%
echo Invalid input detected at '^^' marker.
