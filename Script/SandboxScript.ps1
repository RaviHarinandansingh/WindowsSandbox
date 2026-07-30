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
Write-Output "Install Visual Studio Code Insiders"
Find-WinGetPackage -Id "Microsoft.VisualStudioCode.Insiders" -MatchOption Equals | Install-WinGetPackage

# Add few VS code extensions
$extensionList = @(
			"ms-vscode.powershell",
			"mechatroner.rainbow-csv",
			"phplasma.csv-to-table",
			"awwsky.regionmarker",
			"george-alisson.html-preview-vscode",
			"azure-automation.vscode-azureautomation",
			"oderwat.indent-rainbow",
			"ms-vscode.vscode-speech"
)

foreach ($extension in $extensionList){
    & code-Insiders --install-extension $extension
}

# Install Git
Find-WinGetPackage -Id "Git.Git" -MatchOption Equals | Install-WinGetPackage

# Install DSC

# Install Ow-My-Posh



$scriptEndTime = Get-Date
$duration = $scriptEndTime - $scriptStartTime
Write-Output ("Script duration: {0}" -f $duration.ToString())

Pause