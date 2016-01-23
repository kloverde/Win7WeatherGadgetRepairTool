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
   goto cancel
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
echo This installer adds an entry to the Windows registry to run
echo Win7WeatherGadgetRepairTool.bat automatically when your
echo system starts.  This can be undone at any time by running
echo uninstall.bat.
echo.
echo It is not necessary to use this installer, but it will make
echo it less likely that you'll need to run the .bat yourself.
echo.
echo To make this application as simple to use as possible for
echo the greatest number of people, the registry entry does not
echo rely on advanced concepts such as putting
echo Win7WeatherGadgetRepairTool.bat on your system path.
echo Instead, the registry entry will contain the full path to
echo Win7WeatherGadgetRepairTool.bat.
echo.
echo This means that if you move this application to a different
echo directory after installing it, it will no longer run
echo automatically because the registry entry will be pointing to
echo an invalid location.  If you do move it, you must run
echo install.bat a second time to update the invalid entry, or
echo run uninstall.bat to remove it.
echo.

call .\continueYesNo.bat "Do you want to continue? (Y/N)"

if /i "!_yn!"=="Y" (
  goto install
) else (
   goto cancel
)


:install
   call .\pathSanitizer.bat "!executionDir!\Win7WeatherGadgetRepairTool.bat"

   echo.
   echo Creating registry entry...
   echo.

   reg add %registryKey% /v %registryValue% /t REG_SZ /d "!sanitized_path!" /f

   if !errorlevel!==0 (
      echo.
      echo Registry entry created successfully.
      echo.

      pause

      set retCreateTask=%RET_FUNCTION_UNINITIALIZED_FAILURE%
      call :createTask retCreateTask

      echo.

      if !retCreateTask!==%RET_CREATE_TASK_DECLINED% (
         echo Skipped scheduled task creation.
         echo.
         echo Installation complete!
      ) else (
         if !retCreateTask!==%RET_FUNCTION_SUCCESS% (
            echo Installation complete!
         ) else (
            echo Installation partially failed
         )
      )
   ) else (
      echo.
      echo Installation failed when attempting to create the registry entry
   )

   echo.
   pause

   goto end


:createTask
   cls

   more createTask.txt

   echo.
   call .\continueYesNo.bat "Do you want to continue? (Y/N)"

   if /i "!_yn!"=="Y" (
      call .\createTask.bat
      set %~1=!errorlevel!
   ) else (
      set %~1=%RET_CREATE_TASK_DECLINED%
   )

   goto :eof


:cancel
   echo.
   echo Installation cancelled
   goto end

:end
   popd

endlocal
