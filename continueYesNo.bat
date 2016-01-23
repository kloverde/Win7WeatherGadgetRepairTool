@echo off

REM Windows 7 Weather Gadget Repair Tool
REM https://www.github.com/kloverde/Win7WeatherGadgetRepairTool
REM Copyright (c) 2015 Kurtis LoVerde
REM All rights reserved.
REM
REM See LICENSE for this software's licensing terms.


set _yn=
set msg=%1

for /f "useback tokens=*" %%a in ( '%msg%' ) do set msg=%%~a

:top
   set /p _yn=%msg% 

   if /i "%_yn%"=="Y" (
     goto :eof
   )

   if /i "%_yn%"=="N" (
      goto :eof
   )

   goto top
