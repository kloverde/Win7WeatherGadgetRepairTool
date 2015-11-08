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
pushd "!executionDir!"

call .\initVariables.bat

cls

call .\checkWin7.bat

if not !errorlevel!==%RET_FUNCTION_SUCCESS% (
   pause
   goto end
)

call .\license.bat

if !errorlevel!==%RET_FUNCTION_SUCCESS% (
   call .\writeConfigFile.bat
) else (
   goto cancel
)

cls

echo Windows 7 Weather Gadget Repair Tool Installer
echo.
echo https://www.github.com/kloverde/Win7WeatherGadgetRepairTool
echo.
echo This installer adds an entry to the Windows registry to
echo run Win7WeatherGadgetRepairTool.bat automatically when
echo your system starts.  This can be undone at any time by
echo running uninstall.bat or deleting the entry yourself.
echo.
echo It is not necessary to use this installer, but it
echo might make it less likely that you'll need to run
echo Win7WeatherGadgetRepairTool.bat yourself.
echo.
echo To make this application as simple to use as possible
echo for the greatest number of people, the registry entry
echo does not rely on advanced concepts such as putting
echo Win7WeatherGadgetRepairTool.bat on your system path.
echo Instead, the registry entry will contain the full path
echo to Win7WeatherGadgetRepairTool.bat.
echo.
echo This means that if you move this application to a
echo different directory after installing it, it will no
echo longer run automatically because the registry entry
echo will be pointing to the old location.  If you do move
echo it, you must run install.bat a second time to update
echo the invalid entry, or run uninstall.bat to remove it.
echo.

:confirmation
   set /p yesNo=Do you want to continue^? ^(Y/N^) 

   if /i "!yesNo!"=="Y" (
     goto install
   )

   if /i "!yesNo!"=="N" (
      goto cancel
   )

   goto confirmation


:install
   call .\pathSanitizer.bat "!executionDir!\Win7WeatherGadgetRepairTool.bat"

   echo.
   echo Creating registry entry...
   echo.

   reg add %registryKey% /v %registryValue% /t REG_SZ /d "!sanitized_path!" /f

   if !errorlevel!==0 (
      echo.
      echo Installation complete.
   ) else (
      echo.
      echo Installation failed when attempting to create the registry entry
   )

   echo.
   pause

   goto end

:cancel
   echo.
   echo Installation cancelled
   goto end

:end
   popd

endlocal
