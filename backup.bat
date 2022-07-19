ECHO OFF
CLS

ECHO.
ECHO ***********************************************
ECHO             Database Backup Utility
ECHO                      v1.0
ECHO         Developed by breakint (pvt) ltd
ECHO                 Author: Zaheer
ECHO ***********************************************

:: Display Options of Operations to Perform
:MENU
ECHO.
ECHO Options Menu:
ECHO 1. Backup Database and Data (Includes CREATE TABLE Statements)
ECHO 2. Export Data Only (CREATE TABLE Statements are not Included)
ECHO 3. Exit

:: Ask user for option and decide the MYSQLDUMP Switches
ECHO.
SET OPTION=3
SET /P OPTION=Enter your option: 
IF %OPTION% == 1 (
    SET MYDQLDUMPSWITCH=--verbose
) ELSE IF %OPTION% == 2 (
    SET MYDQLDUMPSWITCH=--verbose --no-create-info
) ELSE IF %OPTION% == 3 ( 
    ECHO Exiting the Utility....
    PAUSE
    EXIT
) ELSE (
    ECHO Enter from given options!
    GOTO MENU
)

:: Display Info
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
CALL :getDate currentDateTime

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
SET DBNAME=epi
:: Take User Input for DB Name, if different than epi
SET /P DBNAME=Enter Database Name (Default Name is %DBNAME%): 
:: Set Output File Name in format: epi_YYYYMMDD.sql
SET DBOUTPUTNAME=%DBNAME%_%currentDateTime%%EXTENSION%
:: Take User Input for Backup File Name
SET /P DBOUTPUTNAME=Enter Backup Script Name (Default Name is %DBOUTPUTNAME%): 

:: If Backup File Name does not end with 'sql' extension then append '.sql' extension
IF %DBOUTPUTNAME:~-3% NEQ sql (
    SET DBOUTPUTNAME=%DBOUTPUTNAME%.sql
)

:: Backup Database by Executing mysqldump.exe with root user with no password
:: Format: mysqldump.exe epi > epi_date.sql -u root
CMD /c %CURRENTPATH% %DBNAME% > %DBOUTPUTNAME% -u root %MYDQLDUMPSWITCH%
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
set %~1=%datestamp%_%timestamp%
::echo timestamp: "%timestamp%"
::echo fullstamp: "%fullstamp%"
EXIT /B 0