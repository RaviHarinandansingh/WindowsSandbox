$scriptStartTime = Get-Date

Write-Output "Install PackageProvider"
Start-Process powershell -ArgumentList "-NoProfile -Command `"Install-PackageProvider -Name NuGet -RequiredVersion 2.8.5.201 -Force`"" -Wait

Write-Output "Install PowerShellGet"
Start-Process powershell -ArgumentList "-NoProfile -Command `"Install-Module -Name PowerShellGet -AllowClobber -Force`"" -Wait

Write-Output "Install Microsoft.Winget.Client"
Start-Process powershell -ArgumentList "-NoProfile -Command `"Install-Module -Name Microsoft.Winget.Client -Force -AcceptLicense`"" -Wait

# Wait until Winget module is available
while (-not (Get-Module -ListAvailable -Name Microsoft.Winget.Client)) {
    Start-Sleep -Seconds 5
}

# Import the module
Import-Module Microsoft.Winget.Client

# Install Winget
Repair-WinGetPackageManager

# Remove msstore as source
Remove-WinGetSource -Name msstore

# Install Powershell 7
Write-Output "Install Powershell 7"
Find-WinGetPackage -Id "Microsoft.PowerShell" -MatchOption Equals | Install-WinGetPackage

# Install Visual Studio Code Insiders
Write-Output "Install Powershell 7"
Find-WinGetPackage -Id "Microsoft.VisualStudioCode.Insiders" -MatchOption Equals | Install-WinGetPackage

$scriptEndTime = Get-Date
$duration = $scriptEndTime - $scriptStartTime
Write-Output ("Script duration: {0}" -f $duration.ToString())

Pause