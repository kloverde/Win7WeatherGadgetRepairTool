@echo off

REM Windows 7 Weather Gadget Repair Tool v1.0
REM Copyright (c) 2015 Kurtis LoVerde
REM https://www.github.com/kloverde/Win7WeatherGadgetRepairTool
REM
REM See LICENSE for this software's licensing terms.

REM This script trims spaces from a path and replaces double backslashes
REM with a single backslash.  Windows is inconsistent with how it copes
REM with concurrent backslashes and with how it reports paths.  This
REM causes chaos.  For example:
REM
REM   * Windows Explorer doesn't forgive double backslashes.  Try it:
REM     type C:\\Windows into an Explorer window's path textbox.  You'll
REM     get an error.
REM
REM   * CMD.exe does forgive double backslashes.  Try it:  type
REM     "cd C:\\Windows" into a prompt; it will work.
REM
REM   * Environment variables like %USERPROFILE% are returned without a
REM     trailing backslash.  Try it:  type "echo %userprofile%" into a
REM     command prompt.
REM
REM   * CMD.exe-generated variables, such as the directory of the
REM     currently-running script, are returned WITH a trailing
REM     backslash.  Try it:  put "echo %~dp0" in a script.
REM
REM In the case of Windows 7 Weather Gadget Repair Tool's installer,
REM %~dp0 is used to construct a path which is saved in the registry.
REM Constructing the path without double backslashes would look like:
REM %~dp0TheRestOfThePath.  This would look like a mistake to anyone
REM reading the code; you'd expect to see %~dp0\TheRestOfThePath.
REM That, however, results in a double backslash, which Windows can't
REM read.  It seems the only CMD.exe can cope with it.
REM
REM Given the inconsistency with how paths are reported and handled,
REM and my complete lack of confidence that the inconsistency will
REM always be consistent (how's that for a play on words), I chose to
REM write correct-looking code and create this sanitizing script to
REM fix any potential problems with the paths it generates.
REM
REM This script stores the sanitized path in %sanitized_path%.

set str=%1

REM echo Received             : [%str%]


REM Step 1:  Remove leading and trailing quotes.  
REM
REM If a path containing spaces was passed in, quotes would need to be used to ensure the
REM string is interpreted as a single argument.  This has the side effect of the quotes
REM becoming part of the argument.

for /f "useback tokens=*" %%a in ( '%str%' ) do set str=%%~a
REM echo Trim quotes          : [%str%]


REM Step 2:  Trim leading spaces

for /f "tokens=* delims= " %%a in ( "%str%" ) do set str=%%a
REM echo Trim leading spaces  : [%str%]


REM Step 3:  Trim trailing spaces

for /l %%a in ( 1, 1, 1024 ) do if "!str:~-1!"==" " set str=!str:~0,-1!
REM echo Trim trailing spaces : [%str%]


REM Step 4:  Convert double backslashes to single backslashes

set str=%str:\\=\%
REM echo Fix double backslash : [%str%]


set sanitized_path=%str%
