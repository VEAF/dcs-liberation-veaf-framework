@echo off
echo.
echo ----------------------------------------
echo Preparing scripts
echo ----------------------------------------
echo.

rem -- default options values
echo This script can use these environment variables to customize its behavior :
echo ----------------------------------------
echo VERBOSE_LOG_FLAG if set to "true", will create a mission with tracing enabled (meaning that, when run, it will log a lot of details in the dcs log file)
echo defaults to "false"
IF [%VERBOSE_LOG_FLAG%] == [] GOTO DefineDefaultVERBOSE_LOG_FLAG
goto DontDefineDefaultVERBOSE_LOG_FLAG
:DefineDefaultVERBOSE_LOG_FLAG
set VERBOSE_LOG_FLAG=false
:DontDefineDefaultVERBOSE_LOG_FLAG
echo current value is "%VERBOSE_LOG_FLAG%"

echo ----------------------------------------
echo SECURITY_DISABLED_FLAG if set to "true", will create a mission with security disabled (meaning that no password is ever required)
echo defaults to "false"
IF [%SECURITY_DISABLED_FLAG%] == [] GOTO DefineDefaultSECURITY_DISABLED_FLAG
goto DontDefineDefaultSECURITY_DISABLED_FLAG
:DefineDefaultSECURITY_DISABLED_FLAG
set SECURITY_DISABLED_FLAG=false
:DontDefineDefaultSECURITY_DISABLED_FLAG
echo current value is "%SECURITY_DISABLED_FLAG%"

echo ----------------------------------------
echo SEVENZIP (a string) points to the 7za executable
echo defaults "7za", so it needs to be in the path
IF ["%SEVENZIP%"] == [""] GOTO DefineDefaultSEVENZIP
goto DontDefineDefaultSEVENZIP
:DefineDefaultSEVENZIP
set SEVENZIP=7za
:DontDefineDefaultSEVENZIP
echo current value is "%SEVENZIP%"

echo ----------------------------------------
echo DISTRIBUTION_ARCHIVE_SUFFIX (a string) will be appended to the distibution archive file name to make it more unique
echo defaults to the current iso date
IF [%DISTRIBUTION_ARCHIVE_SUFFIX%] == [] GOTO DefineDefaultDISTRIBUTION_ARCHIVE_SUFFIX
goto DontDefineDefaultDISTRIBUTION_ARCHIVE_SUFFIX
:DefineDefaultDISTRIBUTION_ARCHIVE_SUFFIX
set TIMEBUILD=%TIME: =0%
set DISTRIBUTION_ARCHIVE_SUFFIX=%date:~-4,4%%date:~-7,2%%date:~-10,2%
:DontDefineDefaultDISTRIBUTION_ARCHIVE_SUFFIX
set DISTRIBUTION_ARCHIVE=dcs-liberation-veafplugin_%DISTRIBUTION_ARCHIVE_SUFFIX%
echo current value is "%DISTRIBUTION_ARCHIVE_SUFFIX%"

echo.
echo prepare the folders
rd /s /q .\build >nul 2>&1
mkdir .\build >nul 2>&1
rd /s /q .\dist >nul 2>&1
mkdir .\dist >nul 2>&1

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

if %VERBOSE_LOG_FLAG%==false (
	rem -- comment all the trace and debug code
	echo comment all the trace and debug code
	FOR %%f IN (.\build\tempscripts\veaf\*.lua) DO powershell -Command "(gc %%f) -replace '(^\s*)(veaf.*\.[^\(^\s]*log(Trace|Debug))', '$1--$2' | sc %%f" >nul 2>&1
)

rem -- copy all the scripts
xcopy /Y .\build\tempscripts\*.lua dist\ >nul 2>&1
xcopy /Y .\build\tempscripts\community dist\ >nul 2>&1
xcopy /Y .\build\tempscripts\veaf dist\ >nul 2>&1
xcopy /Y .\src\* dist\ >nul 2>&1
	
rem -- remove unwanted scripts
del /f /q dist\autogft-1_12.lua >nul 2>&1
del /f /q dist\dcsDataExport.lua >nul 2>&1
del /f /q dist\NIOD.lua >nul 2>&1
del /f /q dist\veafCarrierOperations2.lua >nul 2>&1
del /f /q dist\VeafDynamicLoader.lua >nul 2>&1
del /f /q dist\veafMissionEditor.lua >nul 2>&1
del /f /q dist\veafMissionNormalizer.lua >nul 2>&1
del /f /q dist\veafMissionRadioPresetsEditor.lua >nul 2>&1

rem -- build distribution archive
"%SEVENZIP%" a -r -tzip %DISTRIBUTION_ARCHIVE%.zip .\dist\* >nul 2>&1

rem -- cleanup 
rd /s /q .\build >nul 2>&1

echo.
echo ----------------------------------------
rem -- done !
echo Done !
echo ----------------------------------------

pause