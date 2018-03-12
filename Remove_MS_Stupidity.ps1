# Run this script as admin

# Remove all "Apps". Retains Calc and the core Store functionality
Get-AppxPackage -AllUsers | where {$.name -notlike "calc" -AND $.name -notlike "store" -AND $.name -notlike "onenote" -AND $.name -notlike "NET." -AND $.name -notlike "VCLibs" -AND $.name -notlike "Host" -AND $_.name -notlike "AccountsControl"} | Remove-AppxPackage

# Disable telemetry services
Remove-Service -Name "DiagTrack"
Remove-Service -Name "dmwappushservice"
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
