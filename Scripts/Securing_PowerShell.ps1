<#
Windows PowerShell is an extremely powerful utility built into all distributions of Windows 7/2008 R2 and later.
Because of this it has became a popular tool among attackers and can be very dangerous if not properly secured.
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

# Enable Constrained Language Mode, removes access to advanced features such as API calls and COM access
# Can also be done through Group Policy at Computer Configuration\Preferences\Windows Settings\Environment
[Environment]::SetEnvironmentVariable(‘__PSLockdownPolicy‘, ‘4’, ‘Machine‘)

<# 
If PowerShell V2 is installed, remove it. This prevents downgrade attacks.
As of the Windows 10 Fall Creators update, PowerShell V2 is considered deprecated and was later updated
to remove the files necessary to renable, effectively disabling it altogether.
#>
$x = Get-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellV2
If ($x.State -eq "Enabled"){
    Disable-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellV2
}
