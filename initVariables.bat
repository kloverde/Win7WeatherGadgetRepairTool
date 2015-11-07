@echo off

REM Windows 7 Weather Gadget Repair Tool v1.0
REM Copyright (c) 2015 Kurtis LoVerde
REM https://www.github.com/kloverde/Win7WeatherGadgetRepairTool
REM
REM See LICENSE for this software's licensing terms.


set RET_FUNCTION_SUCCESS=0
set RET_FUNCTION_UNINITIALIZED_FAILURE=99
set RET_ISLICENSEACCEPTED_CANT_READ_LICENSE=-1
set RET_ISLICENSEACCEPTED_CONFIG_FILE_DECLINED=-2
set RET_LICENSEPROMPT_USER_DECLINED=-3
set RET_FIXGADGET_FILE_NOT_FOUND=-4
set RET_FIXGADGET_COPY_FAIL=-5
set RET_UNINSTALL_CANT_DELETE_CFG_DIR=-6

set executionDir=%~dp0
set licenseFullPath=%executionDir%\LICENSE

set scriptConfigDir=%USERPROFILE%\.Win7WeatherGadgetRepairTool
set scriptConfigFile=config
set scriptConfigFullPath=%scriptConfigDir%\%scriptConfigFile%
set scriptConfigFlagAcceptedLicense=acceptedLicense

set gadgetConfigDir=%USERPROFILE%\AppData\Local\Microsoft\Windows Live\Services\Cache
set gadgetConfigFile=Config.xml
set gadgetConfigFullPath=%gadgetConfigDir%\%gadgetConfigFile%

set registryKey=HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run
set registryValue=Win7WeatherGadgetRepairTool
