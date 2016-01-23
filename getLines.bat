@echo off

REM Windows 7 Weather Gadget Repair Tool
REM https://www.github.com/kloverde/Win7WeatherGadgetRepairTool
REM Copyright (c) 2015 Kurtis LoVerde
REM All rights reserved.
REM
REM See LICENSE for this software's licensing terms.


REM     Known issues
REM     1.  Empty lines are not preserved (inherent to the design of FOR)


set RET_SUCCESS=0
set RET_INVALID_FROM=-1
set RET_INVALID_TO=-2
set RET_FILE_NOT_FOUND=-3

setlocal enabledelayedexpansion

set exitCode=%RET_SUCCESS%

:main
   REM Bail if there are less than 3 arguments
   if "%3"=="" (
      goto usage
   )

   if %1==^? (
      goto usage
   )

   if %1 lss 1 (
      echo Invalid argument:  [from] cannot be less than 1
      set exitCode=%RET_INVALID_FROM%
      goto end
   )

   if %2 lss %1 (
      echo Invalid argument:  [to] cannot be less than [from]
      set exitCode=%RET_INVALID_TO%
      goto end
   )

   set /a from=%1-1
   set /a to=%2
   set /a difference=!to!-!from!
   set file=%3

   if not exist !file! (
      echo File not found: !file!
      set exitCode=%RET_FILE_NOT_FOUND%
      goto end
   )   

   set lineCount=0

   for /f "delims=" %%a in ('more +!from! !file!') do ( 
     if !lineCount! geq !difference! goto :end
     echo %%a
     set /a lineCount+=1
   )

   goto end

:usage
   echo USAGE:  getLines.bat [starting line] [ending line] [file]
   echo.
   echo Example:  getLines.bat 2 10 C:\directory\file.txt
   echo.
   echo All parameters are required.
   echo Starting and ending line numbers are inclusive.
   echo Starting and ending line numbers are 1-indexed.
   echo If the path to your file contains a space,
   echo enclose the entire path in quotes.

   goto :end

:end
   exit /b !exitCode!
