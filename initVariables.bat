@echo off

REM Windows 7 Weather Gadget Repair Tool
REM https://www.github.com/kloverde/Win7WeatherGadgetRepairTool
REM Copyright (c) 2015 Kurtis LoVerde
REM All rights reserved.
REM
REM See LICENSE for this software's licensing terms.


set APP_NAME=Win7WeatherGadgetRepairTool

REM Return codes
REM negative for failure, 0 for success, positive for information
set RET_FUNCTION_SUCCESS=0
set RET_CREATE_TASK_DECLINED=1
set RET_ISLICENSEACCEPTED_CANT_READ_LICENSE=-1
set RET_ISLICENSEACCEPTED_CONFIG_FILE_DECLINED=-2
set RET_LICENSEPROMPT_USER_DECLINED=-3
set RET_FIXGADGET_FILE_NOT_FOUND=-4
set RET_FIXGADGET_COPY_FAIL=-5
set RET_UNINSTALL_CANT_DELETE_REGISTRY=-6
set RET_UNINSTALL_CANT_DELETE_CFG_DIR=-7
set RET_NOT_WINDOWS_7=-8
set RET_START_SIDEBAR_FAIL=-9
set RET_STOP_SIDEBAR_FAIL=-10
set RET_CREATE_TASK_VBS_FAILED=-11
set RET_CREATE_TASK_XML_FAILED=-12
set RET_COULDNT_FIND_TASK_XML_TEMPLATE=-13
set RET_IMPORT_TASK_FAIL=-14
set RET_DELETE_IMPORT_TASK_FAIL=-15
set RET_FUNCTION_UNINITIALIZED_FAILURE=-99

set executionDir=%~dp0
set licenseFullPath=%executionDir%\LICENSE

set scriptConfigDir=%USERPROFILE%\.%APP_NAME%
set scriptConfigFile=config
set scriptConfigFullPath=%scriptConfigDir%\%scriptConfigFile%
set scriptConfigFlagAcceptedLicense=acceptedLicense

set gadgetConfigDir=%USERPROFILE%\AppData\Local\Microsoft\Windows Live\Services\Cache
set gadgetConfigFile=Config.xml
set gadgetConfigFullPath=%gadgetConfigDir%\%gadgetConfigFile%

set registryKey=HKEY_CURRENT_USER\Software\Microsoft\Windows\CurrentVersion\Run
set registryValue=%APP_NAME%

set sidebarExe=sidebar.exe
set taskName=%APP_NAME%
