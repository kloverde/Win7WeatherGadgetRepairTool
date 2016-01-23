# Win7WeatherGadgetRepairTool

See LICENSE for this software's licensing terms.

This application fixes a common problem with the Windows 7
weather gadget where the gadget suddenly stops working.
Instead of showing the current weather conditions, it
displays an error which says "Cannot connect to service."
This application refreshes the gadget's configuration file
and restarts the gadget.  Your existing settings are kept.

The following three scripts are meant to be run by end
users.  The rest are used internally by the application
and should not be run by end users.

**Win7WeatherGadgetRepairTool.bat**

  This script performs the repair operation and restarts
  the Windows sidebar, thus restarting the gadget.  Run
  this script when you notice your gadget malfunctioning.
  (Keep reading to learn how to automate this process).

**install.bat**

  It is not required that you run this script, but it is
  recommended.  This script adds an entry to the Windows
  registry to run Win7WeatherGadgetRepairTool.bat
  automatically at startup.  Also, it allows you to
  *optionally* create a scheduled task to periodically
  run the .bat while your computer is running.  The task
  runs invisibly, so you don't need to worry about a
  random command window popping up.

**uninstall.bat**

  This script undoes the changes made to your system by
  install.bat.  It also removes the configuration file
  that this tool creates in your user profile.
