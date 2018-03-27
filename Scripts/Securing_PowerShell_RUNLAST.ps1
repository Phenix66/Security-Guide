<#
Windows PowerShell is an extremely powerful utility built into all distributions of Windows 7/2008 R2 and later.
Because of this, it has became a popular tool among attackers and can be very dangerous if not properly secured.
Good reference: https://adsecurity.org/?p=2604
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

<# 
If PowerShell V2 is installed, remove it. This prevents *most* downgrade attacks.
As of the Windows 10 Fall Creators update, PowerShell V2 is considered deprecated and was later updated
to remove the files necessary to renable, effectively disabling it altogether.
#>
Write-Host "Disabling PowerShell V2 if enabled..."
$x = Get-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellV2
If ($x.State -eq "Enabled"){
    Disable-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellV2
}

# Set the PowerShell Language mode to what is desired
$Input = Read-Host @"
PowerShell Language Modes:
0 - Full
1 - Constrained (Prevents most API calls and COM access, recommended)
Please enter the desired PowerShell language mode
"@

While ("0","1","full","constrained" -notcontains $Input)
{
    $Input = Read-Host "Invalid option, please enter 0 or 1 to proceed"
}

If ($Input -eq "1" -or $Input -eq "constrained"){
    [Environment]::SetEnvironmentVariable('__PSLockdownPolicy', '4', 'Machine')
}

# Sets PowerShell so scripts cannot be ran, interactive mode only. 
# Granted it's easy to bypass with -ep, but this will at least make it harder
Write-Host "Setting execution policy to restricted (prevents auto script running)..."
Set-ExecutionPolicy Restricted

Write-Host "Done."`n
Write-Host "Press any key to exit..."
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
