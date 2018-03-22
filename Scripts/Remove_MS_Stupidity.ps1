<#
Microsoft has built in several "features" that will collect data on user behavior.
This script attempts to disable as many of these "features" as possible, but updates will sometimes re-enable "features".
My recommendation is to run this script after first install, then use O&O ShutUp on a regular basis to check configuration.
#>

# Check for admin
function Test-IsAdmin { 
([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator") 
} 

# Exit the script if it is not running under admin rights
If (!(Test-ISAdmin)){
    Write-Host "This script must be ran as admin. Please re-run from an admin PowerShell session"
    $x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    exit
}

# Remove all "Apps". Retains Calc and the core Store functionality
Write-Host "Removing bloatware..."
Get-AppxPackage -AllUsers | Where-Object {$_.name -notlike "calc" -AND $_.name -notlike "store" -AND $_.name -notlike "onenote" -AND $_.name -notlike "NET." -AND $_.name -notlike "VCLibs" -AND $_.name -notlike "Host" -AND $_.name -notlike "AccountsControl"} | Remove-AppxPackage

# Disable telemetry services
Write-Host "Nuking Microsoft spy services..."
If ( Get-Service "DiagTrack") {
    sc.exe delete "DiagTrack"
}
If ( Get-Service "dmwappushservice") {
    sc.exe delete "dmwappushservice"
}
Out-File -filepath C:\ProgramData\Microsoft\Diagnosis ETLLogsAutoLogger\AutoLogger-Diagtrack-Listener.etl
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Value 0

# Place entries into the hosts file to block known MS telemetry URLs
$hosts = @(
"127.0.0.1 vortex.data.microsoft.com",
"127.0.0.1 vortex-win.data.microsoft.com",
"127.0.0.1 telecommand.telemetry.microsoft.com",
"127.0.0.1 telecommand.telemetry.microsoft.com.nsatc.net",
"127.0.0.1 oca.telemetry.microsoft.com",
"127.0.0.1 oca.telemetry.microsoft.com.nsatc.net",
"127.0.0.1 sqm.telemetry.microsoft.com",
"127.0.0.1 sqm.telemetry.microsoft.com.nsatc.net",
"127.0.0.1 watson.telemetry.microsoft.com",
"127.0.0.1 watson.telemetry.microsoft.com.nsatc.net",
"127.0.0.1 redir.metaservices.microsoft.com",
"127.0.0.1 choice.microsoft.com",
"127.0.0.1 choice.microsoft.com.nsatc.net",
"127.0.0.1 df.telemetry.microsoft.com",
"127.0.0.1 reports.wes.df.telemetry.microsoft.com",
"127.0.0.1 services.wes.df.telemetry.microsoft.com",
"127.0.0.1 sqm.df.telemetry.microsoft.com",
"127.0.0.1 telemetry.microsoft.com",
"127.0.0.1 watson.ppe.telemetry.microsoft.com",
"127.0.0.1 telemetry.appex.bing.net",
"127.0.0.1 telemetry.urs.microsoft.com",
"127.0.0.1 telemetry.appex.bing.net:443",
"127.0.0.1 settings-sandbox.data.microsoft.com",
"127.0.0.1 vortex-sandbox.data.microsoft.com",
"127.0.0.1 telemetry.*"
)

Add-Content C:\Users\omni\Desktop\test.txt $hosts
