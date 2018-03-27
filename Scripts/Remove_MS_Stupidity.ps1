<#
Microsoft has built in several "features" that will collect data on user behavior.
This script attempts to disable as many of these "features" as possible, but updates will sometimes re-enable "features".
My recommendation is to run this script after first install, then use O&O ShutUp on a regular basis to check configuration.
https://www.oo-software.com/en/shutup10
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

function force-mkdir($path) {
    if (!(Test-Path $path)) {
        #Write-Host "-- Creating full path to: " $path -ForegroundColor White -BackgroundColor DarkGreen
        New-Item -ItemType Directory -Force -Path $path
    }
}

# Remove all "Apps". Retains Calc and the core Store functionality
Write-Host "Removing bloatware..."
Get-AppxPackage -AllUsers | Where-Object {$_.name -notlike "*calc*" -AND $_.name -notlike "*store*" -AND $_.name `
    -notlike "*onenote*" -AND $_.name -notlike "*NET.*" -AND $_.name -notlike "*VCLibs*" -AND $_.name -notlike "*Host*" `
    -AND $_.name -notlike "*AccountsControl*"} | Remove-AppxPackage

# Disables the downloading of updates from other PCs
Write-Host "Disabling Windows Update Peer-2-Peer behavior..."
force-mkdir "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DeliveryOptimization" -Name "DODownloadMode" -Value 0

# Disable telemetry services
Write-Host "Nuking Microsoft spy services..."
If ( Get-Service "DiagTrack") {
    sc.exe delete "DiagTrack"
}
If ( Get-Service "dmwappushservice") {
    sc.exe delete "dmwappushservice"
}
force-mkdir "C:\ProgramData\Microsoft\Diagnosis ETLLogsAutoLogger"
Out-File -filepath C:\ProgramData\Microsoft\Diagnosis ETLLogsAutoLogger\AutoLogger-Diagtrack-Listener.etl
force-mkdir "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection"
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Value 0
