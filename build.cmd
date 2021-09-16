@echo off
echo.
echo ----------------------------------------
echo Preparing scripts
echo ----------------------------------------
echo.

rem -- default options values
echo This script can use these environment variables to customize its behavior :
echo ----------------------------------------
echo NOPAUSE if set to "true", will not pause at the end of the script (useful to chain calls to this script)
echo defaults to "false"
IF [%NOPAUSE%] == [] GOTO DefineDefaultNOPAUSE
goto DontDefineDefaultNOPAUSE
:DefineDefaultNOPAUSE
set NOPAUSE=false
:DontDefineDefaultNOPAUSE
echo current value is "%NOPAUSE%"

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
echo LUA_SCRIPTS_DEBUG_PARAMETER can be set to "-debug" or "-trace" (or not set) ; this will be passed to the lua helper scripts (e.g. veafMissionRadioPresetsEditor and veafMissionNormalizer)
echo defaults to not set
IF [%LUA_SCRIPTS_DEBUG_PARAMETER%] == [] GOTO DefineDefaultLUA_SCRIPTS_DEBUG_PARAMETER
goto DontDefineDefaultLUA_SCRIPTS_DEBUG_PARAMETER
:DefineDefaultLUA_SCRIPTS_DEBUG_PARAMETER
set LUA_SCRIPTS_DEBUG_PARAMETER=
:DontDefineDefaultLUA_SCRIPTS_DEBUG_PARAMETER
echo current value is "%LUA_SCRIPTS_DEBUG_PARAMETER%"

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
echo LUA (a string) points to the lua executable
echo defaults "lua", so it needs to be in the path
IF ["%LUA%"] == [""] GOTO DefineDefaultLUA
goto DontDefineDefaultLUA
:DefineDefaultLUA
set LUA=lua
:DontDefineDefaultLUA
echo current value is "%LUA%"

echo ----------------------------------------
echo DYNAMIC_MISSION_PATH (a string) points to folder where this mission is located
echo defaults this folder
IF ["%DYNAMIC_MISSION_PATH%"] == [""] GOTO DefineDefaultDYNAMIC_MISSION_PATH
goto DontDefineDefaultDYNAMIC_MISSION_PATH
:DefineDefaultDYNAMIC_MISSION_PATH
set DYNAMIC_MISSION_PATH=%~dp0
:DontDefineDefaultDYNAMIC_MISSION_PATH
echo current value is "%DYNAMIC_MISSION_PATH%"

echo ----------------------------------------
echo DYNAMIC_SCRIPTS_PATH (a string) points to folder where the VEAF-mission-creation-tools are located
echo defaults this folder
IF ["%DYNAMIC_SCRIPTS_PATH%"] == [""] GOTO DefineDefaultDYNAMIC_SCRIPTS_PATH
goto DontDefineDefaultDYNAMIC_SCRIPTS_PATH
:DefineDefaultDYNAMIC_SCRIPTS_PATH
set DYNAMIC_SCRIPTS_PATH=%~dp0node_modules\veaf-mission-creation-tools\
set NPM_UPDATE=true
:DontDefineDefaultDYNAMIC_SCRIPTS_PATH
echo current value is "%DYNAMIC_SCRIPTS_PATH%"

echo ----------------------------------------
echo DYNAMIC_LOAD_SCRIPTS if set to "true", will create a mission with all the scripts loaded dynamically by default
echo defaults to "false"
IF [%DYNAMIC_LOAD_SCRIPTS%] == [] GOTO DefineDefaultDYNAMIC_LOAD_SCRIPTS
goto DontDefineDefaultDYNAMIC_LOAD_SCRIPTS
:DefineDefaultDYNAMIC_LOAD_SCRIPTS
set DYNAMIC_LOAD_SCRIPTS=false
:DontDefineDefaultDYNAMIC_LOAD_SCRIPTS
echo current value is "%DYNAMIC_LOAD_SCRIPTS%"

echo ----------------------------------------
echo MISSION_FILE_SUFFIX1 (a string) will be appended to the mission file name to make it more unique
echo defaults to empty
IF [%MISSION_FILE_SUFFIX1%] == [] GOTO DefineDefaultMISSION_FILE_SUFFIX1
goto DontDefineDefaultMISSION_FILE_SUFFIX1
:DefineDefaultMISSION_FILE_SUFFIX1
set MISSION_FILE_SUFFIX1=
:DontDefineDefaultMISSION_FILE_SUFFIX1
echo current value is "%MISSION_FILE_SUFFIX1%"

echo ----------------------------------------
echo MISSION_FILE_SUFFIX2 (a string) will be appended to the mission file name to make it more unique
echo defaults to the current iso date
IF [%MISSION_FILE_SUFFIX2%] == [] GOTO DefineDefaultMISSION_FILE_SUFFIX2
goto DontDefineDefaultMISSION_FILE_SUFFIX2
:DefineDefaultMISSION_FILE_SUFFIX2
set TIMEBUILD=%TIME: =0%
set MISSION_FILE_SUFFIX2=%date:~-4,4%%date:~-7,2%%date:~-10,2%
:DontDefineDefaultMISSION_FILE_SUFFIX2
echo current value is "%MISSION_FILE_SUFFIX2%"

echo ----------------------------------------
echo MISSION_FILE_SUFFIX1 (a string) will be appended to the mission file name to make it more unique
echo defaults to empty
IF [%MISSION_FILE_SUFFIX1%] == [] GOTO DontUseSuffix1
set MISSION_FILE=.\build\%MISSION_NAME%_%MISSION_FILE_SUFFIX1%_%MISSION_FILE_SUFFIX2%
goto EndOfSuffix1
:DontUseSuffix1
set MISSION_FILE=.\build\%MISSION_NAME%_%MISSION_FILE_SUFFIX2%
:EndOfSuffix1

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
IF ["%NPM_UPDATE%"] == [""] GOTO DontNPM_UPDATE
echo fetching the veaf-mission-creation-tools package
if exist yarn.lock (
	call yarn upgrade
) else (
	call yarn install
)
goto DoNPM_UPDATE
:DontNPM_UPDATE
echo skipping npm update
:DoNPM_UPDATE

echo.
echo prepare the veaf-mission-creation-tools scripts
rem -- copy the scripts folder
xcopy /s /y /e %DYNAMIC_SCRIPTS_PATH%\src\scripts\* .\build\tempscripts\ >nul 2>&1

rem -- set the flags in the scripts according to the options
echo set the flags in the scripts according to the options
powershell -File replace.ps1 .\build\tempscripts\veaf\veaf.lua "veaf.Development = (true|false)" "veaf.Development = %VERBOSE_LOG_FLAG%" >nul 2>&1
powershell -File replace.ps1 .\build\tempscripts\veaf\veaf.lua "veaf.SecurityDisabled = (true|false)" "veaf.SecurityDisabled = %SECURITY_DISABLED_FLAG%" >nul 2>&1

if %VERBOSE_LOG_FLAG%==false (
	rem -- comment all the trace and debug code
	echo comment all the trace and debug code
	FOR %%f IN (.\build\tempscripts\veaf\*.lua) DO powershell -File replace.ps1 %%f "(^\s*)(.*veaf\.loggers.get\(.*\):(trace|debug|marker|cleanupMarkers))" "$1--$2" >nul 2>&1
)

rem -- copy all the scripts
xcopy /Y .\build\tempscripts\*.lua dist\ >nul 2>&1
xcopy /Y .\build\tempscripts\community dist\ >nul 2>&1
xcopy /Y .\build\tempscripts\veaf dist\ >nul 2>&1
xcopy /Y .\src\* dist\ >nul 2>&1
	
rem -- remove unwanted scripts
del /f /q dist\dcsDataExport.lua >nul 2>&1
del /f /q dist\NIOD.lua >nul 2>&1
del /f /q dist\VeafDynamicLoader.lua >nul 2>&1
del /f /q dist\veafMissionEditor.lua >nul 2>&1
del /f /q dist\veafMissionNormalizer.lua >nul 2>&1
del /f /q dist\veafMissionRadioPresetsEditor.lua >nul 2>&1
del /f /q dist\veafMissionTriggerInjector.lua >nul 2>&1
del /f /q dist\veafMissionFlightPlanEditor.lua >nul 2>&1
del /f /q dist\veafSpawnableAircraftsEditor.lua >nul 2>&1

rem -- build distribution archive
"%SEVENZIP%" a -r -tzip %DISTRIBUTION_ARCHIVE%.zip .\dist\* >nul 2>&1

rem -- cleanup 
rd /s /q .\build >nul 2>&1

echo.
echo ----------------------------------------
rem -- done !
echo Done !
echo ----------------------------------------
echo.

IF [%NOPAUSE%] == [true] GOTO EndOfFile
pause
:EndOfFile
