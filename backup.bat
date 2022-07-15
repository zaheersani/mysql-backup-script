ECHO OFF
CLS
:MENU
ECHO.
ECHO ***********************************************
ECHO           EPI Database Backup Utility
ECHO                      v0.1
ECHO         Developed by breakint (pvt) ltd
ECHO                 Author: Zaheer
ECHO ***********************************************
ECHO.

ECHO Looking for XAMPP Installation in C, D and E Drive....
ECHO.
:: Possible Drives for XAMPP
SET DBPATH1=C:\xampp\mysql\bin\mysqldump.exe
SET DBPATH2=D:\xampp\mysql\bin\mysqldump.exe
SET DBPATH3=E:\xampp\mysql\bin\mysqldump.exe

:: There is a possibility that XAMPP is install in other drive
:: Locate and check mysqldump.exe file 
:: Set the path for mysqldump.exe file
IF EXIST %DBPATH1% (
    SET CURRENTPATH=%DBPATH1%
) ELSE IF EXIST %DBPATH2% (
    SET CURRENTPATH=%DBPATH2%
) ELSE IF EXIST %DBPATH3% (
    SET CURRENTPATH=%DBPATH3%
) ELSE (
    ECHO Could not find MYSQLDUMP File
    ECHO.
    CALL :MANUAL_MYSQLDUMP_PATH CURRENTPATH
)

:: Display path of mysqldump file
ECHO MYSQLDUMP Found at Path: %CURRENTPATH%
ECHO.

:: Get Current System Date
CALL :getDate currentDate

:: Perform Backup of the DB
CALL :BACKUP_DB

PAUSE
EXIT

::-----------------------------------------------------------
::----------Functions are Defined Below This Line------------
::-----------------------------------------------------------

:MANUAL_MYSQLDUMP_PATH
SET /P pathToMysqldump=Enter Path to mysqldump.exe:
IF EXIST %pathToMysqldump% (
    set %~1=%pathToMysqldump%
) ELSE (
    ECHO Could not find MYSQLDUMP File at Path: %pathToMysqldump%
    CALL :END
    EXIT
)
EXIT /B 0

:: Function: Backup Database
:BACKUP_DB
:: Set Backup File Extension
SET EXTENSION=.sql
:: Set Default Source DB Name
::SET DBNAME=epi
:: Take User Input for DB Name, if different than epi
SET /P DBNAME=Enter Database Name:
:: Set Output File Name in format: epi_YYYYMMDD.sql
SET DBOUTPUTNAME=%DBNAME%_%currentDate%%EXTENSION%
:: Backup Database by Executing mysqldump.exe with root user with no password
:: Format: mysqldump.exe epi > epi_date.sql -u root
CMD /c %CURRENTPATH% %DBNAME% > %DBOUTPUTNAME% -u root --verbose
:: Exit Function
EXIT /B 0

:: END Script Function
:END
ECHO.
ECHO.
PAUSE
EXIT /B 0

:: Get Date Function
:getDate
:: Source: https://stackoverflow.com/a/19131662/163589
for /f "tokens=2 delims==" %%a in ('wmic OS Get localdatetime /value') do set "dt=%%a"
set "YY=%dt:~2,2%" & set "YYYY=%dt:~0,4%" & set "MM=%dt:~4,2%" & set "DD=%dt:~6,2%"
set "HH=%dt:~8,2%" & set "Min=%dt:~10,2%" & set "Sec=%dt:~12,2%"

set "datestamp=%YYYY%%MM%%DD%" & set "timestamp=%HH%%Min%%Sec%"
set "fullstamp=%YYYY%-%MM%-%DD%_%HH%-%Min%-%Sec%"
:: echo datestamp: "%datestamp%"
set %~1=%datestamp%
::echo timestamp: "%timestamp%"
::echo fullstamp: "%fullstamp%"
EXIT /B 0