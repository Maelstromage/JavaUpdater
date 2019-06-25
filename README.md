# JavaUpdater
Sorry there is not much documentation yet, just made this.

There has not been much testing so consider this application in Alpha.
The idea is that the javadownloader.ps1 script should be put on a server scheduled to run periodically. This can be down with Task Scheduler. When the script runs it will check to see if there is a new version of java and download it.

We then can create a GPO that is applied to an AD Group. Those computers that are in the AD group will have a startup script (Installjava.ps1) that executes when the computer boots before the login. At this time all old version of Java will be uninstalled and the newest version of Java will be installed.

By having people in an AD group we can apply this only to people that need the update. If we have a computer that needs to stay on an old version of Java we simply do not put them in this group.

