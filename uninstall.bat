@echo off

REM Windows 7 Weather Gadget Repair Tool
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
echo This uninstaller will remove the autorun entry from the
echo Windows registry and will delete the scheduled task if
echo you told the installer to create one.  After this operation
echo completes, Win7WeatherGadgetRepairTool will no longer run
echo automatically on your system.
echo.
echo The .Win7WeatherGadgetRepairTool settings directory stored
echo in your user profile will also be removed.
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
   set statusRegDelete=%RET_FUNCTION_UNINITIALIZED_FAILURE%
   set statusCodeDeleteTask=%RET_FUNCTION_UNINITIALIZED_FAILURE%
   set statusCodeDeleteDir=%RET_FUNCTION_UNINITIALIZED_FAILURE%

   set failed=0

   echo.

   REM Make sure the registry value exists before attempting to delete it, otherwise reg.exe
   REM could exit with an error code, causing the uninstaller to throw a false error message.

   echo Searching for registry entry...

   reg query %registryKey% /v %registryValue% > nul 2>&1
   set foundRegistryEntry=!errorlevel!

   if !foundRegistryEntry!==0 (
      echo Removing registry entry...

      reg delete %registryKey% /v %registryValue% /f > nul 2>&1

      if not !errorlevel!==0 (
         echo FAILED
         set statusRegDelete=%RET_UNINSTALL_CANT_DELETE_REGISTRY%
         set failed=1
      ) else (
         echo Success!
         set statusRegDelete=%RET_FUNCTION_SUCCESS%
      )
   ) else (
      echo Registry entry is not present
   )

   echo.
   echo Searching for scheduled task...

   schtasks /query /tn %taskName% > nul 2>&1

   if !errorlevel!==0 (
      echo Deleting scheduled task...

      schtasks /delete /tn %taskName% /f > nul 2>&1

      if !errorlevel!==0 (
         echo Success!
         set statusCodeDeleteTask=%RET_FUNCTION_SUCCESS%
      ) else (
         echo FAILED
         set statusCodeDeleteTask=%RET_DELETE_IMPORT_TASK_FAIL%
         set failed=1
      )
   ) else (
      echo Scheduled task is not present
   )

   echo.
   echo Searching for settings directory...

   if exist "%scriptConfigDir%" (
      echo Removing settings directory...

      rmdir /s /q "%scriptConfigDir%" 2> nul

      REM Rmdir is bad because it doesn't set errorlevel.  This includes when the target
      REM doesn't exist and when the target can't be deleted because something has a
      REM lock on it.  Check for the existence of the directory instead.

      if exist "%scriptConfigDir%" (
         echo FAILED
         set statusCodeDeleteDir=%RET_UNINSTALL_CANT_DELETE_CFG_DIR%
         set failed=1
      ) else (
         echo Success!
         set statusCodeDeleteDir=%RET_FUNCTION_SUCCESS%
      )
   ) else (
      echo Settings directory is not present
   )

   echo.

   if !failed!==1 (
      echo.
      echo ERROR:  Uninstall failed.  The following problems were encountered:
      echo.

      if not !statusRegDelete!==%RET_FUNCTION_SUCCESS% (
         echo   Could not delete the registry entry
      )

      if not !statusCodeDeleteTask!==%RET_FUNCTION_SUCCESS% (
         echo   Could not delete the scheduled task
      )

      if not !statusCodeDeleteDir!==%RET_FUNCTION_SUCCESS% (
         echo   Could not delete "%scriptConfigDir%" 
      )
   ) else (
      echo.
      echo Uninstall completed successfully
   )

   echo.
   pause
   goto end

:end
   popd

endlocal
