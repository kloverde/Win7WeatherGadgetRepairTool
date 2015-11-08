@echo off

REM Windows 7 Weather Gadget Repair Tool v1.0
REM https://www.github.com/kloverde/Win7WeatherGadgetRepairTool
REM Copyright (c) 2015 Kurtis LoVerde
REM All rights reserved.
REM
REM See LICENSE for this software's licensing terms.

setlocal enabledelayedexpansion

set executionDir=%~dp0

pushd "%executionDir%"

call .\initVariables.bat

cls

echo Windows 7 Weather Gadget Repair Tool Uninstaller
echo.
echo https://www.github.com/kloverde/Win7WeatherGadgetRepairTool
echo.
echo Uninstallation will perform the following operations:
echo.
echo 1.  Remove the Win7WeatherGadgetRepairTool autorun entry
echo     from your registry.  After this operation completes,
echo     Win7WeatherGadgetRepairTool will no longer run
echo     automatically on system startup.
echo.
echo 2.  Remove the .Win7WeatherGadgetRepairTool settings
echo     directory stored in your user profile
echo.
echo Uninstallation will NOT delete the application files from
echo your system; you must delete these yourself.  They are
echo located at %executionDir%.
echo.

:confirmation
   set /p yesNo=Do you want to continue^? ^(Y/N^) 

   if /i "%yesNo%"=="Y" (
      goto uninstall
   )

   if /i "%yesNo%"=="N" (
      echo.
      echo Uninstall cancelled
      goto end
   )

   goto confirmation


:uninstall
   set errCodeRegDelete=%RET_FUNCTION_SUCCESS%
   set errCodeDeleteDir=%RET_FUNCTION_SUCCESS%

   REM Boolean OR doesn't exist in batch scripting.  For the love of God...
   set failed=0

   echo.

   REM Make sure the registry value exists before attempting to delete it, otherwise reg.exe
   REM could exit with an error code, causing the uninstaller to throw a false error message.

   reg query %registryKey% /v %registryValue% > nul 2>&1
   set foundRegistryEntry=!errorlevel!

   if !foundRegistryEntry!==0 (
      reg delete %registryKey% /v %registryValue% /f > nul 2>&1

      if not !errorlevel!==0 (
         set errCodeRegDelete=%RET_UNINSTALL_CANT_DELETE_REGISTRY%
         set failed=1
      )
   )

   REM Make sure the settings directory exists before attempting to delete it, otherwise rmdir
   REM could exit with an error code, causing the uninstaller to throw a false error message.

   if exist "%scriptConfigDir%" (
      rmdir /s /q "%scriptConfigDir%" 2> nul

      REM Rmdir is bad because it doesn't set errorlevel.  This includes when the target
      REM doesn't exist and when the target can't be deleted because something has a
      REM lock on it.  Check for the existence of the directory instead.

      if exist "%scriptConfigDir%" (
         set errCodeDeleteDir=%RET_UNINSTALL_CANT_DELETE_CFG_DIR%
         set failed=1
      )
   )

   echo.

   if !failed!==1 (
      echo ERROR:  Uninstall failed.  The following problems were encountered:
      echo.

      if not !errCodeRegDelete!==%RET_FUNCTION_SUCCESS% (
         echo   Could not delete the registry entry
      )

      if not !errCodeDeleteDir!==%RET_FUNCTION_SUCCESS% (
         echo   Could not delete "%scriptConfigDir%" 
      )
   ) else (
      echo Uninstall completed successfully
   )

   echo.
   pause
   goto end

:end
   popd

endlocal
