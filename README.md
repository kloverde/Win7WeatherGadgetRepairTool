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
  recommended.  This script will add an entry to the
  Windows registry to run Win7WeatherGadgetRepairTool.bat
  automatically at startup.  Also, it allows you to
  *optionally* create a scheduled task to periodically
  run the .bat while your computer is running.  The task
  runs invisbly, so you don't need to worry about a
  random command window popping up.

**uninstall.bat**

  This script undoes the changes made to your system by
  install.bat.  It also removes the configuration file
  that this tool creates in your user profile.


<br/>
I run this application on my own machine with it set to run
on startup via install.bat.  Speaking from personal
experience, when my machine boots, it always manages to run
Win7WeatherGadgetRepairTool.bat before the gadget loads, so
the config file is always in a valid state.  After several
months of using the application in this way, the gadget has
never malfunctioned on me.  So, for me, running
automatically at startup is a complete fix.

If you're not as lucky, and if you don't want to bother
with running Win7WeatherGadgetRepairTool.bat yourself, you
can use Task Scheduler to create a recurring task to run 
Win7WeatherGadgetRepairTool.bat every so often.  This
application will not do that for you; you can do it
yourself by typing "Task Scheduler" into your Start  menu.
You'll have to consider whether you want to do this, since
you'll actually SEE the sidebar restarting every time -- it
will disappear and reappear.  However, if enough people
ask, I might investigate whether it's possible to add this
functionality on an opt-in basis.
