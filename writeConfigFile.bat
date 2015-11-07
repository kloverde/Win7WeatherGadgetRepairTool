@echo off

REM Windows 7 Weather Gadget Repair Tool v1.0
REM Copyright (c) 2015 Kurtis LoVerde
REM https://www.github.com/kloverde/Win7WeatherGadgetRepairTool
REM
REM See LICENSE for this software's licensing terms.


REM FUNCTION   : writeConfigFile
REM PARAMETERS : none
REM RETURNS    : nothing
:writeConfigFile
   if not exist "%scriptConfigDir%" (
      mkdir "%scriptConfigDir%"
   )

   REM Don't put a space in front of the redirect operator!  The space will be written to the file,
   REM which will mess up parsing.

   echo %scriptConfigFlagAcceptedLicense%> %scriptConfigFullPath%
   goto :eof
