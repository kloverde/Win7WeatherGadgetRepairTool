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

   REM trim leading and trailing spaces
   for /f "tokens=* delims= " %%a in ( "%_yn%" ) do set _yn=%%a
   for /l %%a in ( 1, 1, 1024 ) do if "!_yn:~-1!"==" " set _yn=!_yn:~0,-1!

   if /i "%_yn%"=="Y" (
     goto :eof
   )

   if /i "%_yn%"=="N" (
      goto :eof
   )

   goto top
