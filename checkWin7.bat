@echo off

REM Windows 7 Weather Gadget Repair Tool
REM https://www.github.com/kloverde/Win7WeatherGadgetRepairTool
REM Copyright (c) 2015 Kurtis LoVerde
REM All rights reserved.
REM
REM See LICENSE for this software's licensing terms.

setlocal enabledelayedexpansion

ver | findstr /i "6.1" > nul 2>&1

if not !errorlevel!==0 (
   echo You aren't running Windows 7.  This application
   echo is for Windows 7 only; it doesn't solve
   echo problems with gadgets on other versions of
   echo Windows.  The application will now close.
   echo.

   exit /b %RET_NOT_WINDOWS_7%
) else (
   exit /b %RET_FUNCTION_SUCCESS%
)

endlocal
