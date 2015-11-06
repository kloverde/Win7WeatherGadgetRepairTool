REM Windows 7 Weather Gadget Repair Tool v1.0
REM Copyright (c) 2015 Kurtis LoVerde
REM https://www.github.com/kloverde/Win7WeatherGadgetRepairTool
REM
REM This script fixes a common problem with the Windows 7 weather
REM gadget where the gadget suddenly stops working.  Instead of
REM showing the current weather conditions, it displays an error
REM which says "Cannot connect to service."  This script
REM refreshes the gadget's configuration file; the gadget will
REM start working again once the gadget is restarted.  This is
REM usually accomplished by logging out and logging back in.
REM However, it's possible that by running this script at
REM startup, the configuration file might be refreshed before the
REM gadget initializes, eliminating the need for logging out.
REM If you would like to run this script at startup, run the
REM install.bat script which is packaged with this utility.  It
REM will create an entry in your registry to run at startup.

REM See LICENSE for this software's licensing terms.

@echo off
setlocal enabledelayedexpansion

cls

echo Windows 7 Weather Gadget Repair Tool v1.0
echo https://www.github.com/kloverde/Win7WeatherGadgetRepairTool

echo.
echo.

set RET_FUNCTION_SUCCESS=0
set RET_FUNCTION_UNINITIALIZED_FAILURE=99
set RET_ISLICENSEACCEPTED_CONFIG_FILE_DECLINED=-1
set RET_LICENSEPROMPT_USER_DECLINED=-2
set RET_FIXGADGET_FILE_NOT_FOUND=-3
set RET_FIXGADGET_COPY_FAIL=-4

set executionDir=%~dp0
set licenseFullPath=%executionDir%\LICENSE

set scriptConfigDir=%USERPROFILE%\.Win7WeatherGadgetRepairTool
set scriptConfigFile=config
set scriptConfigFullPath=%scriptConfigDir%\%scriptConfigFile%
set scriptConfigFlagAcceptedLicense=acceptedLicense

set gadgetConfigDir=%USERPROFILE%\AppData\Local\Microsoft\Windows Live\Services\Cache
set gadgetConfigFile=Config.xml
set gadgetConfigFullPath=%gadgetConfigDir%\%gadgetConfigFile%


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

   call :isLicenseAccepted retIsLicenseAccepted

   if !retIsLicenseAccepted!==%RET_FUNCTION_SUCCESS% (
      call :writeConfigFile
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
   goto :eof

REM FUNCTION   : isLicenseAccepted
REM PARAMETERS : reference variable for return value
REM RETURNS    : All possible failure codes from licensePrompt();
REM              RET_ISLICENSEACCEPTED_CONFIG_FILE_DECLINED if the config file indicates the terms were not accepted;
REM              RET_FUNCTION_SUCCESS if license is accepted
:isLicenseAccepted
   setlocal
      set found=0
      set retLicensePrompt=%RET_LICENSEPROMPT_USER_DECLINED%
   endlocal

   if not exist "%scriptConfigFullPath%" (
      echo LICENSING TERMS
      echo.
      type %licenseFullPath%
      echo.

      call :licensePrompt retLicensePrompt
      set %~1=!retLicensePrompt!
   ) else (
      REM Don't use findstr.  It has a silly bug which requires the file to have a newline
      REM at the end, which could mess up parsing if the user manually edits the file.
      REM findstr /x "%scriptConfigFlagAcceptedLicense%" "%scriptConfigFullPath%"

      for /f %%s in ( %scriptConfigFullPath% ) do (
         if %scriptConfigFlagAcceptedLicense%==%%s (
            set found=1
         )
      )

      if !found!==1 (
         set %~1=%RET_FUNCTION_SUCCESS%
      ) else (
         set %~1=%RET_ISLICENSEACCEPTED_CONFIG_FILE_DECLINED%
      )
   )

   goto :eof

REM FUNCTION   : licensePrompt
REM PARAMETERS : reference variable for return value
REM RETURNS    : RET_LICENSEPROMPT_USER_DECLINED if user did not accept the terms;
REM              RET_FUNCTION_SUCCESS if the user accepted the terms
:licensePrompt
   set /p accept=Do you accept the licensing terms^? ^(Y/N^) 

   if /i "!accept!"=="Y" (
      set %~1=%RET_FUNCTION_SUCCESS%
      goto :eof
   )
      
   if /i "!accept!"=="N" (
      set %~1=%RET_LICENSEPROMPT_USER_DECLINED%
      goto :eof
   )

   goto licensePrompt

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

   goto :eof

REM FUNCTION   : writeConfigFile
REM PARAMETERS : none
REM RETURNS    : nothing
:writeConfigFile
   if not exist "%scriptConfigDir%" (
      mkdir "%scriptConfigDir%"
   )

   REM Don't put a space in front of the redirect operator!  The space will be written to the file,
   REM which will mess up parsing.

   echo %scriptConfigFlagAcceptedLicense%> %scriptConfigFullPath%
   goto :eof


REM closing endlocal from the beginning of the script
endlocal
