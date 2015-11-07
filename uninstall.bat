@echo off

REM Windows 7 Weather Gadget Repair Tool v1.0
REM Copyright (c) 2015 Kurtis LoVerde
REM https://www.github.com/kloverde/Win7WeatherGadgetRepairTool
REM
REM See LICENSE for this software's licensing terms.

setlocal

set executionDir=%~dp0

pushd "%executionDir%"

call .\initVariables.bat

cls

echo Win7WeatherGadgetRepairTool Uninstaller
echo.
echo Copyright (c) 2015 Kurtis LoVerde
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
   echo.

   set failed=0
   set errLevelRegDelete=%RET_FUNCTION_SUCCESS%

   echo Deleting registry entry...

   REM Make sure the registry value exists before attempting to delete it, otherwise reg.exe
   REM could exit with an error code, causing the uninstaller to throw a false error message.

   reg query %registryKey% /v %registryValue% > nul 2>&1

   if %errorlevel%==%RET_FUNCTION_SUCCESS% (
      reg delete %registryKey% /v %registryValue% /f
      set errLevelRegDelete=%errorlevel%
   )

   if not %errLevelRegDelete%==%RET_FUNCTION_SUCCESS% (
      set failed=1
   )

   echo.
   echo Deleting settings...

   rmdir /s /q "%scriptConfigDir%" 2> nul

   REM rmdir is weird:  %errorlevel% is 0 when the target doesn't exist.
   REM Check for the existence of the directory instead.

   if exist "%scriptConfigDir%" (
      set errCodeDeleteDir=%RET_UNINSTALL_CANT_DELETE_CFG_DIR%
      set failed=1
   ) else (
      set errCodeDeleteDir=%RET_FUNCTION_SUCCESS%
   )

   echo.

   REM Don't you just love how cmd.exe doesn't support boolean expressions?

   if %failed%==1 (
      echo ERROR:  Uninstall failed.  The following problems were encountered:
      echo.
   ) else (
      echo Uninstall completed successfully
   )

   if not %errLevelRegDelete%==%RET_FUNCTION_SUCCESS% (
      echo   Could not delete the registry entry
   )

   if not %errCodeDeleteDir%==%RET_FUNCTION_SUCCESS% (
      echo   Could not delete "%scriptConfigDir%" 
   )

   echo.
   pause
   goto end

:end
   popd

endlocal
