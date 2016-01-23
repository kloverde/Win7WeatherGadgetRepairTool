@echo off

REM Windows 7 Weather Gadget Repair Tool
REM https://www.github.com/kloverde/Win7WeatherGadgetRepairTool
REM Copyright (c) 2015 Kurtis LoVerde
REM All rights reserved.
REM
REM See LICENSE for this software's licensing terms.

setlocal enabledelayedexpansion

cls

set executionDir=%~dp0

pushd "%executionDir%"

call .\initVariables.bat
call .\checkWin7.bat

if not !errorlevel!==%RET_FUNCTION_SUCCESS% (
   pause
   goto end
)

echo Windows 7 Weather Gadget Repair Tool
echo.
echo https://www.github.com/kloverde/Win7WeatherGadgetRepairTool
echo.
echo.


REM FUNCTION   : main
REM PARAMETERS : none
REM RETURNS    : RET_FUNCTION_SUCCESS for successful gadget repair and restart
REM              Negative value on error (see initVariables.bat)
:main
   setlocal

   REM Default the return values to failure states
   set retIsLicenseAccepted=%RET_FUNCTION_UNINITIALIZED_FAILURE%
   set retFixGadget=%RET_FUNCTION_UNINITIALIZED_FAILURE%
   set retRestartSidebar=%RET_FUNCTION_UNINITIALIZED_FAILURE%
   set exitStatus=%RET_FUNCTION_UNINITIALIZED_FAILURE%

   set strError=ERROR:  Gadget repair failed with return code !retFixGadget!
   set strSuccess=All operations completed successfully.

   call .\license.bat
   set retIsLicenseAccepted=!errorlevel!

   if !retIsLicenseAccepted!==%RET_FUNCTION_SUCCESS% (
      call .\writeConfigFile.bat
      call :fixGadget retFixGadget

      if not !retFixGadget!==%RET_FUNCTION_SUCCESS% (
         set strError=ERROR:  Gadget repair failed with return code 
         set exitStatus=!retFixGadget!
      ) else (
         call :restartSidebar retRestartSidebar

         if not !retRestartSidebar!==%RET_FUNCTION_SUCCESS% (
            set strError=ERROR:  The gadget was successfully repaired but could not be restarted.  Restart failed with return code !retRestartSidebar!
            set exitStatus=!retRestartSidebar!
         ) else (
            echo Restart successful
            set exitStatus=%RET_FUNCTION_SUCCESS%
         )
      )
   ) else (
      set strError=!strError!!retIsLicenseAccepted!
      set exitStatus=!retIsLicenseAccepted!
   )

   if not !exitStatus!==%RET_FUNCTION_SUCCESS% (
      if not !retIsLicenseAccepted!==%RET_LICENSEPROMPT_USER_DECLINED% (         
         echo.
         echo !strError!
         pause
      )
   ) else (
      echo.
      echo %strSuccess%
   )

   exit /b !exitStatus!

   endlocal
   goto end

REM FUNCTION   : fixGadget
REM PARAMETERS : reference variable for return value
REM RETURNS    : RET_FIXGADGET_FILE_NOT_FOUND if the gadget config file could not be found
REM              RET_FIXGADGET_COPY_FAIL if file unsuccessfully written;
REM              RET_FUNCTION_SUCCESS if file successfully written
:fixGadget
   if not exist "%gadgetConfigFullPath%" (
      set %~1=%RET_FIXGADGET_FILE_NOT_FOUND%
   ) else (
      echo Repairing config file...

      pushd %gadgetConfigDir%
      copy %gadgetConfigFile% /b+ ,,/y

      if !errorlevel!==0 (
         set %~1=%RET_FUNCTION_SUCCESS%
      ) else (
         set %~1=%RET_FIXGADGET_COPY_FAIL%
      )
   )

   goto :eof

REM FUNCTION   : restartSidebar
REM PARAMETERS : reference variable for return value
REM RETURNS    : RET_STOP_SIDEBAR_FAIL if sidebar.exe could not be stopped
REM            : REM_START_SIDEBAR_FAIL if sidebar.exe could not be started
REM              RET_FUNCTION_SUCCESS if sidebar.exe successfully restarted
:restartSidebar
   set retStartSidebar=%RET_FUNCTION_UNINITIALIZED_FAILURE%

   echo.
   echo Restarting %sidebarExe%...

   tasklist /fi "IMAGENAME eq %sidebarExe%" | findstr "%sidebarExe%" > nul 2>&1

   if !errorlevel!==0 (
      taskkill /im %sidebarExe% /t /f > nul 2>&1

      if !errorlevel!==0 (
         echo ^ ^ ^ Stopped successfully
         call :startSidebar retStartSidebar
         set %~1=!retStartSidebar!
      ) else (
         set %~1=%RET_STOP_SIDEBAR_FAIL%
      )
   ) else (
      call :startSidebar retStartSidebar
      set %~1=!retStartSidebar!
   )

   goto :eof

REM FUNCTION   : startSidebar
REM PARAMETERS : reference variable for return value
REM RETURNS    : RET_START_SIDEBAR_FAIL if sidebar.exe could not be started
REM              RET_FUNCTION_SUCCESS if sidebar.exe was successfully started
:startSidebar
   start "" %sidebarExe%

   if !errorlevel!==0 (
      echo ^ ^ ^ Started successfully
      set %~1=%RET_FUNCTION_SUCCESS%
   ) else (
      set %~1=%RET_START_SIDEBAR_FAIL%
   )

   goto :eof

:end
   popd
   endlocal
