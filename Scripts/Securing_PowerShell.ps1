<#
Windows PowerShell is an extremely powerful utility built into all distributions of Windows 7/2008 R2 and later.
Because of this, it has became a popular tool among attackers and can be very dangerous if not properly secured.
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
If PowerShell V2 is installed, remove it. This prevents downgrade attacks.
As of the Windows 10 Fall Creators update, PowerShell V2 is considered deprecated and was later updated
to remove the files necessary to renable, effectively disabling it altogether.
#>
$x = Get-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellV2
If ($x.State -eq "Enabled"){
    Disable-WindowsOptionalFeature -Online -FeatureName MicrosoftWindowsPowerShellV2
}

# Set the PowerShell Language mode to what is desired
$Input = Read-Host @"
PowerShell Language Modes:
0 - Full
1 - Constrained (Prevents most API calls and COM access)
Please enter the desired PowerShell language mode
"@

While ("0","1","full","constrained" -notcontains $Input)
{
    $Input = Read-Host "Invalid option, please enter 0 or 1 to proceed"
}

If ($Input -eq "0" -or $Input -eq "full"){
    write-host "full"
} ElseIf ($Input -eq "1" -or $Input -eq "constrained"){
    write-host "constrained"
}
