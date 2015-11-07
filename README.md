# Win7WeatherGadgetRepairTool

See LICENSE for this software's licensing terms.

This application fixes a common problem with the Windows 7
weather gadget where the gadget suddenly stops working.
Instead of showing the current weather conditions, it
displays an error which says "Cannot connect to service."
This script refreshes the gadget's configuration file; the
gadget will start working again once the gadget is
restarted.

Win7WeatherGadgetRepairTool.bat:
  This script performs the repair operation.  After
  running this script, you will need to restart the gadget
  or log out, then log back in.

install.bat
  This script will add an entry to the Windows registry to
  run Win7WeatherGadgetRepairTool.bat automatically at
  startup.  It it not necessary to use this script, but
  it can make it less likely for the gadget to malfunction.
  It might even eliminate the need for you to restart the
  gadget or log out, depending on when the malfunction
  occurs.  If the repair occurs before the gadget
  initializes, for example, you'll never even notice that
  something was wrong.

  If you want to get *really* aggressive, you could use
  Task Scheduler to create a recurring task to run
  Win7WeatherGadgetRepairTool.bat every few minutes (this
  script will not do that for you).  You can do it
  yourself by typing "Task Scheduler" into your Start
  menu.

  Note that whatever approach you choose (running
  Win7WeatherGadgetRepairTool.bat on demand, using
  install.bat or creating a scheduled task), you might
  still have to restart the gadget and/or log out and log
  back in.

uninstall.bat
  This script removes the autorun entry added to the
  registry by install.bat.
