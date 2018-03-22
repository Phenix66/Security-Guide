<#
All versions of SMB 1 and 2 are highly vunerable. By default a Windows computer will auto negotiate which version of the protocol
to use for an SMB connection in order to provide maximum backwards compatibility. By disabling SMB versions 1 and 2, you can
force Windows to only accept SMB v3 connections and prevent attackers from exploiting old and well known vulnerabilities.
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

# Get SMB v1 config
Write-Host "Disabling SMB v1..."
$x = Get-WindowsOptionalFeature –Online –FeatureName SMB1Protocol

# If SMB v1 is enabled, disable it
If ($x.State -eq "Enabled"){
  Disable-WindowsOptionalFeature -Online -FeatureName SMB1Protocol
}

# Get SMB v2 config
Write-Host "Disabling SMB v2..."
$y = Get-SmbServerConfiguration | Select EnableSMB2Protocol

# If SMB v2 is enabled, disable it
If ($y -Match 'True'){
  Set-SmbServerConfiguration -EnableSMB2Protocol $false
}

Write-Host "Done."`n
Write-Host "Press any key to exit..."
$x = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
