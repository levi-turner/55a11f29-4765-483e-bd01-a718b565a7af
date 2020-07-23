#--------------------------------------------------------------------------------------------------------------------------------
#
# Script Name:  port_usage.ps1
# Description:  enumerates port usage by process name and dumps to a csv file
# Dependency:   None
# Requirements: 
# 
#   Version     Date        Author          Change Notes
#   0.1         2018-09-24  Levi Turner     Initial Version 
# 
#--------------------------------------------------------------------------------------------------------------------------------
#Requires -RunAsAdministrator

# Check if C:\Temp exists, else create it
Set-Location /
if (Test-Path C:\Temp) {
} else {
    New-Item -Name Temp -ItemType directory
}
# Check if C:\Temp\ProcessUsage exists, else create it
Set-Location C:\Temp
if (Test-Path C:\Temp\ProcessUsage) {
} else {

    New-Item -Name ProcessUsage -ItemType directory
}
<#
    Generate time stamp for file name
    Format example: 2018-10-18T23:01:52.7775605+02.00
    Then replace : with . to form a valid Windows filename
#>
$filenamedate = "$(Get-Date -Format o | foreach {$_ -replace ":", "."})"
# Gen CSV naming format. Example: processUsage-Type-2018-10-18T23.02.53.3581963+02.00.csv
$portCSV = "processUsage-N-$($filenamedate).csv"
$handleCSV = "processUsage-H-$($filenamedate).csv"
$threadCSV = "processUsage-T-$($filenamedate).csv"

# Set working directory to storage path
Set-Location C:\Temp\ProcessUsage

# Build Array of running processes
$Processes = @{}
foreach ($Program in (Get-Process)) {
    $Processes.Add("$($Program.ID)", $Program)
}
<#
Get current TCP connections and store to CSV with timestamp
Expected format example:
"Count","Name"
"41","chrome"
"2","powershell"
"7","Idle"
#>
Get-NetTCPConnection | Select-Object -Property @{
    Name       = "OwningProcess"
    Expression = { $Processes["$($_.OwningProcess)"].Name }
}, Count |
    Group-Object -Property OwningProcess -NoElement |
    Select-Object -Property Count,Name | Export-Csv -Path "$portCSV" -NoTypeInformation

Get-Process | Select-Object Name, Threads -ExpandProperty Threads | Group-Object Name | Select-Object Name, Count | Export-Csv -Path "$threadCSV" -NoTypeInformation
Get-Process | Select-Object ProcessName, HandleCount | Export-Csv -Path "$handleCSV" -NoTypeInformation