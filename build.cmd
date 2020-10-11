@echo off
echo.
echo ----------------------------------------
echo Preparing scripts
echo ----------------------------------------
echo.

rem -- default options values
set VERBOSE_LOG_FLAG=false
set SECURITY_DISABLED_FLAG=false

echo.
echo prepare the folders
rd /s /q .\build
mkdir .\build

echo.
echo fetch the veaf-mission-creation-tools package
call npm update
rem echo on

echo.
echo prepare the veaf-mission-creation-tools scripts
rem -- copy the scripts folder
xcopy /s /y /e .\node_modules\veaf-mission-creation-tools\src\scripts\* .\build\tempscripts\ >nul 2>&1

rem -- set the flags in the scripts according to the options
echo set the flags in the scripts according to the options
powershell -Command "(gc .\build\tempscripts\veaf\veaf.lua) -replace 'veaf.Development = false', 'veaf.Development = %VERBOSE_LOG_FLAG%' | sc .\build\tempscripts\veaf\veaf.lua" >nul 2>&1
powershell -Command "(gc .\build\tempscripts\veaf\veaf.lua) -replace 'veaf.SecurityDisabled = false', 'veaf.SecurityDisabled = %SECURITY_DISABLED_FLAG%' | sc .\build\tempscripts\veaf\veaf.lua" >nul 2>&1

rem -- comment all the trace and debug code
echo comment all the trace and debug code
FOR %%f IN (.\build\tempscripts\veaf\*.lua) DO powershell -Command "(gc %%f) -replace '(^\s*)(veaf.*\.[^\(^\s]*log(Trace|Debug))', '$1--$2' | sc %%f" >nul 2>&1

rem -- copy all the scripts
xcopy /Y .\build\tempscripts\*.lua src\scripts\ >nul 2>&1
xcopy /Y .\build\tempscripts\community src\scripts\ >nul 2>&1
xcopy /Y .\build\tempscripts\veaf src\scripts\ >nul 2>&1

rem -- cleanup 
rd /s /q .\build

echo.
echo ----------------------------------------
rem -- done !
echo Done !
echo ----------------------------------------

pause