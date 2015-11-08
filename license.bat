@echo off

REM Windows 7 Weather Gadget Repair Tool v1.0
REM https://www.github.com/kloverde/Win7WeatherGadgetRepairTool
REM Copyright (c) 2015 Kurtis LoVerde
REM All rights reserved.
REM
REM See LICENSE for this software's licensing terms.

setlocal enabledelayedexpansion

REM FUNCTION   : isLicenseAccepted
REM PARAMETERS : none
REM RETURNS    : All possible failure codes from licensePrompt();
REM              RET_ISLICENSEACCEPTED_CONFIG_FILE_DECLINED if the config file indicates the terms were not accepted;
REM              RET_FUNCTION_SUCCESS if license is accepted
:isLicenseAccepted
   setlocal

   set found=0
   set retLicensePrompt=%RET_LICENSEPROMPT_USER_DECLINED%

   if not exist "%scriptConfigFullPath%" (
      echo LICENSING TERMS
      echo.
      type %licenseFullPath%

      if not !errorlevel!==0 (
         echo.
         echo Could not display the LICENSE file.  Please check to make sure that LICENSE is present in the same directory as the script and that you have read access to it, then run this script again.
         exit /b %RET_ISLICENSEACCEPTED_CANT_READ_LICENSE%
      ) else (
         echo.

         call :licensePrompt retLicensePrompt
         exit /b !retLicensePrompt!
      )
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
         exit /b %RET_FUNCTION_SUCCESS%
      ) else (
         exit /b %RET_ISLICENSEACCEPTED_CONFIG_FILE_DECLINED%
      )
   )

   endlocal
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

endlocal
