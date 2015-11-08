@echo off

REM Windows 7 Weather Gadget Repair Tool v1.0
REM https://www.github.com/kloverde/Win7WeatherGadgetRepairTool
REM Copyright (c) 2015 Kurtis LoVerde
REM All rights reserved.
REM
REM See LICENSE for this software's licensing terms.

setlocal enabledelayedexpansion

cls

echo Windows 7 Weather Gadget Repair Tool v1.0
echo.
echo https://www.github.com/kloverde/Win7WeatherGadgetRepairTool
echo.
echo.

set executionDir=%~dp0

pushd "%executionDir%"

call initVariables.bat

REM FUNCTION   : main
REM PARAMETERS : none
REM RETURNS    : 0 for successful gadget repair; non-zero for unsuccessful repair
:main
   setlocal

   REM Default the return values to failure states
   set retIsLicenseAccepted=%RET_FUNCTION_UNINITIALIZED_FAILURE%
   set retFixGadget=%RET_FUNCTION_UNINITIALIZED_FAILURE%
   set exitStatus=%RET_FUNCTION_UNINITIALIZED_FAILURE%

   set strSuccess=Gadget repaired successfully.  You might have to log out and log back in again for the change to take effect.
   set strError=ERROR:  Gadget repair failed with return code 

   call .\license.bat
   set retIsLicenseAccepted=%errorlevel%

   if !retIsLicenseAccepted!==%RET_FUNCTION_SUCCESS% (
      call .\writeConfigFile.bat
      call :fixGadget retFixGadget

      if not !retFixGadget!==%RET_FUNCTION_SUCCESS% (
         set strError=!strError!!retFixGadget!
         set exitStatus=!retFixGadget!
      ) else (
         set exitStatus=%RET_FUNCTION_SUCCESS%
      )
   ) else (
      set strError=!strError!!retIsLicenseAccepted!
      set exitStatus=!retIsLicenseAccepted!
   )

   if not !exitStatus!==%RET_FUNCTION_SUCCESS% (
      if not !retIsLicenseAccepted!==%RET_LICENSEPROMPT_USER_DECLINED% (         
         echo.
         echo !strError!
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
      echo Repairing gadget...

      pushd %gadgetConfigDir%
      copy %gadgetConfigFile% /b+ ,,/y

      if !errorlevel!==0 (
         set %~1=%RET_FUNCTION_SUCCESS%
      ) else (
         set %~1=%RET_FIXGADGET_COPY_FAIL%
      )

      popd
   )

   goto end

:end
   popd

endlocal
