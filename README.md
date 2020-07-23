# 55a11f29-4765-483e-bd01-a718b565a7af
PowerShell script + Qlik app to monitor TCP Port + Handle + Thread Usage

# Contents

* processUsage.ps1
  * PowerShell script which will dump the process usage bucketed into counts
* processUsage-H-2020-07-23T15.44.07.3246897-04.00.csv
  * Example output for handles
* processUsage-T-2020-07-23T15.44.07.3246897-04.00.csv
  * Example output for threads
* processUsage-N-2020-07-23T15.44.07.3246897-04.00.csv
  * Example output for TCP Ports
* Process Usage (Ports + Handles + Threads).qvf
  * Qlik app to consume the results

# Config steps for Script:

* Place the PowerShell script somewhere on the server, ideally the C drive because that's what I tested
  * Run it manually to confirm that it is working
    * Expected location for the output is `C:\TEMP\ProcessUsage`
* Configure a Windows Scheduled Task to execute this regularly:
  * Start > Task Scheduler
  * Highlight Task Scheduler Library
  * Create Task
* General Tab Config
  * Name: Arbitrary
  * Account: This needs to be a local admin account
  * Run regardless of whether the user is logged in
  * Example screenshot:
![Screenshot of setting up a task](https://i.imgur.com/webTkj9.png)
* Triggers config:
  * 15 minutes is an ideal frequency
  * Be sure to enable the trigger
  * Example Screenshot:
![Screenshot of setting up a task](https://i.imgur.com/KRO7Z3o.png)
* Actions Tab Config:
  * Start a program
  * Path: `C:\Windows\System32\WindowsPowerShell\v1.0\powershell.exe`
  * Arguments: `-ExecutionPolicy Bypass C:\Temp\processUsage.ps1`
  * Example Screenshot:
![Screenshot of setting up a task](https://i.imgur.com/65R2nzj.png)
* Manually run the task & make sure it outputs a CSV

# Config for Qlik App:
* Import app
* Reload
  * The Data Connection pointing to the CSVs is embedded to C:\TEMP\ProcessUsage
  * This may need adjusting to a UNC path
  * Feel free to adjust things

# Analysis
* Review _Process Usage_ sheet
![Screenshot of app](https://i.imgur.com/b77ywqE.png)
* The combo chart titled _Resource Use By Type_ provides high level aggregates of each type of usage. Steady trending upward signals a process is potentially problematic. Use container to cycle through a detailed view by each type and use filter object to select Qlik Sense related processes.
