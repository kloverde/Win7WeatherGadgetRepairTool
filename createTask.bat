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

pushd !executionDir!

call .\initVariables.bat

call .\pathSanitizer.bat "!executionDir!\task.vbs"
set vbs=!sanitized_path!

call .\pathSanitizer.bat "!executionDir!\Win7WeatherGadgetRepairTool.bat"
set vbsTarget=!sanitized_path!

call .\pathSanitizer.bat "!executionDir!\taskXmlTemplate"
set xmlTemplate=!sanitized_path!

call .\pathSanitizer.bat "!executionDir!\Win7WeatherGadgetRepairTool.xml"
set xml=!sanitized_path!

:main
   set retCreateVbs=%RET_FUNCTION_UNINITIALIZED_FAILURE%
   call :createVbs retCreateVbs

   if !retCreateVbs!==%RET_FUNCTION_SUCCESS% (
      set retCreateXml=%RET_FUNCTION_UNINITIALIZED_FAILURE%
      call :createXml retCreateXml

      if !retCreateXml!==%RET_FUNCTION_SUCCESS% (
         set retImportTask=%RET_FUNCTION_UNINITIALIZED_FAILURE%
         call :importTask retImportTask

         if not !retImportTask!==%RET_FUNCTION_SUCCESS% (
            echo Unable to create the scheduled task:  error code !retImportTask!
         )

         exit /b !retImportTask!
      ) else (
         echo Unable to create the XML file for Task Scheduler:  error code !retCreateXml!
         exit /b !retCreateXml!
      )
   ) else (
      echo Unable to create the VBS file for Task Scheduler:  error code !retCreateVbs!
      exit /b !retCreateVbs!
   )

   goto end

REM FUNCTION   : createVbs
REM PARAMETERS : reference variable for return value
REM RETURNS    : RET_FUNCTION_SUCCESS if VBS file was created successfully
REM              RET_CREATE_TASK_VBS_FAILED if VBS file could not be written
REM
REM Run the .bat via a VB script to prevent a cmd window from popping up.
REM Task Scheduler wasn't playing nicely with the 'start' command (the
REM non-VBS alternative).  The second alternative, configuring the task
REM to "Run whether user is logged on or not" was popping up a message
REM about assigning a batch role to the user, which... um, no.
:createVbs
   echo ' Windows 7 Weather Gadget Repair Tool> !vbs!

   REM errorlevel isn't set when redirection to a file fails, so
   REM determine success by checking to see if the file exists.

   if exist !vbs! (
      set %~1=%RET_FUNCTION_SUCCESS%
   ) else (
      set %~1=%RET_CREATE_TASK_VBS_FAILED%
      goto :eof
   )
   
   echo ' https://www.github.com/kloverde/Win7WeatherGadgetRepairTool>> !vbs!
   echo ' Copyright (c) 2015 Kurtis LoVerde>> !vbs!
   echo ' All rights reserved.>> !vbs!
   echo.>> !vbs!
   echo ' See LICENSE for this software's licensing terms.>> !vbs!
   echo.>> !vbs!
   echo Dim WinScriptHost>> !vbs!
   echo Set WinScriptHost = CreateObject(^"WScript.Shell^")>>  !vbs!
   echo WinScriptHost.Run Chr(34) ^& ^"!vbsTarget!^" ^& Chr(34), ^0>>!vbs!

   goto :eof

REM FUNCTION   : createXml
REM PARAMETERS : reference variable for return value
REM RETURNS    : RET_FUNCTION_SUCCESS if XML file was created successfully
REM              RET_COULDNT_FIND_TASK_XML_TEMPLATE if the XML template wasn't found
REM              RET_CREATE_TASK_XML_FAILED if XML file could not be written
REM
REM Creates a task XML file to be imported by Windows Task Scheduler.  The task
REM runs the .vbs; the .vbs runs the .bat.
:createXml
   if not exist !xmlTemplate! (
      set %~1=%RET_COULDNT_FIND_TASK_XML_TEMPLATE%
      goto :eof
   )

   set user=%COMPUTERNAME%\%USERNAME%

   call .\getLines.bat 1 4 !xmlTemplate!> !xml!

   echo ^<Author^>!user!^</Author^>>> !xml!

   call .\getLines.bat 6 22 !xmlTemplate!>> !xml!

   echo ^<UserId^>!user!^</UserId^>>> !xml!

   call .\getLines.bat 24 52 !xmlTemplate!>> !xml!

   echo ^<Command^>!vbs!^</Command^>>> !xml!

   call .\getLines.bat 54 56 !xmlTemplate!>> !xml!

   if exist !xml! (
      set %~1=%RET_FUNCTION_SUCCESS%
   ) else (
      set %~1=%RET_CREATE_TASK_XML_FAILED%
   )

   goto :eof

REM FUNCTION   : importTask
REM PARAMETERS : reference variable for return value
REM RETURNS    : RET_FUNCTION_SUCCESS if task XML was imported successfully
REM              RET_IMPORT_TASK_FAIL if the task could not be created
REM
REM Imports the generated XML to Windows Task Scheduler.  If the task
REM already exists, it is deleted before being imported.
:importTask
   schtasks /delete /tn %taskName% /f > nul 2>&1
   schtasks /create /xml !xml! /tn %taskName%

   if !errorlevel!==0 (
      set %~1=%RET_FUNCTION_SUCCESS%
   ) else (
      set %~1=%RET_IMPORT_TASK_FAIL%
   )

   goto :eof

:end
   popd
   endlocal
