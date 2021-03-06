#
# Module manifest for module 'TeslaApi'
#
# Generated by: Jower
#
# Generated on: 12/15/2020
#

@{

# Script module or binary module file associated with this manifest.
RootModule = 'TeslaMatrix.psm1'

# Version number of this module.
ModuleVersion = '0.9.98'

# Supported PSEditions
# CompatiblePSEditions = @()

# ID used to uniquely identify this module
GUID = 'a067124a-4138-4efd-9c31-c84158e33619'

# Author of this module
Author = 'John Petersen'

# Company or vendor of this module
CompanyName = 'TeslaMatrix'

# Copyright statement for this module
Copyright = '(c) John Petersen. All rights reserved.'

# Description of the functionality provided by this module
Description = @'
TeslaMatrix is a powershell module for managing your Tesla car from the command line.

If you are about to order a new tesla car, please consider using my referral code. 
For that you (and I) will get 1000 miles / 1500 km of free super charging and you will have a chance to win a Model Y (one time per month) and a Roadster (once every 3 months)
Click this link https://ts.la/john53080 or use the method Get-FreeSuperCharging in the module.

How to get:
The module is automatically pushed to the Powershell gallery https://www.powershellgallery.com/packages/TeslaMatrix
To install it on your system, just simply type Install-Module TeslaMatrix -scope CurrentUser

How to use:
Import the module is done just by typing Import-Module TeslaMatrix 
During Import the module will ask for your tesla credentials.
You can also save your credentials in a local credential object and pass it to the Import-Module command as shown below.
Import-Module TeslaMatrix -argumentlist @{Credential=$cred}
You can also, if preferred, only send your tesla refresh token to the module. The module will ask the tesla API for a new token based on that.
Import-Module TeslaMatrix -argumentlist @{RefreshToken="1234567890"}

Most functions in this module takes as input the id of the vehicle you want to do the operation to. 
The default value, if id is not specified, is the currently selected vehicle.
If you only have one vehicle in your account that vehicle is the selected vehicle.

If you have more than one vehicle, then you can easily select the active vehicle using the Select-Vechicle function
Either by using the id of the vehicle or the name. When you import the module, the first vehicle in your account is automatically selected.

Select-Vechicle -name Neo 
or
Select-Vehicle -id 1234567890

To view the vehicles in your account, use the function Get-Vehicles.

To get the list of functions in the module, you can write Get-Command -Module TeslaMatrix.
To get help on functions you can write Get-Help FunctionName (as in Get-Help Invoke-ValetMode)

Sourcecode can be found on github (https://github.com/jower999/TeslaMatrix).
You are most welcome to contribute by forking the code and sending me a pull-request.

TeslaMatrix powershell module is based on the unofficial documentation of the tesla API
The documentation can be found on https://tesla-api.timdorr.com
'@

# Minimum version of the PowerShell engine required by this module
# PowerShellVersion = ''

# Name of the PowerShell host required by this module
# PowerShellHostName = ''

# Minimum version of the PowerShell host required by this module
# PowerShellHostVersion = ''

# Minimum version of Microsoft .NET Framework required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# DotNetFrameworkVersion = ''

# Minimum version of the common language runtime (CLR) required by this module. This prerequisite is valid for the PowerShell Desktop edition only.
# ClrVersion = ''

# Processor architecture (None, X86, Amd64) required by this module
# ProcessorArchitecture = ''

# Modules that must be imported into the global environment prior to importing this module
# RequiredModules = @()

# Assemblies that must be loaded prior to importing this module
# RequiredAssemblies = @()

# Script files (.ps1) that are run in the caller's environment prior to importing this module.
# ScriptsToProcess = @()

# Type files (.ps1xml) to be loaded when importing this module
# TypesToProcess = @()

# Format files (.ps1xml) to be loaded when importing this module
# FormatsToProcess = @()

# Modules to import as nested modules of the module specified in RootModule/ModuleToProcess
# NestedModules = @()

# Functions to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no functions to export.
FunctionsToExport = @(
    'Clear-SpeedLimitPin',
    'Close-ChargePort',
    'Close-Windows',
    'ConvertFrom-Kilometers',
    'ConvertTo-Kilometers',
    'Disable-SentryMode',
    'Disable-SpeedLimit',
    'Disable-ValetMode',
    'Enable-SentryMode',
    'Enable-SpeedLimit',
    'Enable-ValetMode',
    'Get-AccessToken',
    'Get-ChargeState',
    'Get-ClimateState',
    'Get-DriveState',
    'Get-FreeSuperCharging',
    'Get-GUISettings',
    'Get-LoginDetails',
    'Get-MobileEnabled',
    'Get-NearByChargingSites',
    'Get-VehicleConfig',
    'Get-VehicleData',
    'Get-Vehicles',
    'Get-Vehicle',
    'Get-VehicleState',
    'Invoke-FlashLights',
    'Invoke-Frunk',
    'Invoke-HonkHorn',
    'Invoke-MyTeslaMethod',
    'Invoke-RemoteStartDrive',
    'Invoke-Trunk',
    'Invoke-Wakeup',
    'Open-ChargePort',
    'Open-Windows',
    'Reset-ValetPassword',
    'Revoke-AccessToken',
    'Select-Vehicle',
    'Set-ChargeLimit',
    'Set-ChargeMaxRange',
    'Set-ChargeStandard',
    'Set-MediaNextFavourite',
    'Set-MediaNextTrack',
    'Set-MediaPlayback',
    'Set-MediaPreviousTrack',
    'Set-MediaPrevousFavourite',
    'Set-MediaVolumeDown',
    'Set-MediaVolumeUp',
    'Set-SeatHeaterLevel',
    'Set-SpeedLimit',
    'Set-Temperature',
    'Start-AutoConditioning',
    'Start-Charging',
    'Start-PreConditioningMaxDefrost',
    'Start-Share',
    'Start-SoftwareUpdate',
    'Start-SteeringWheelHeater',
    'Stop-AutoConditioning',
    'Stop-Charging',
    'Stop-PreConditioningMaxDefrost',
    'Stop-SoftwareUpdate',
    'Stop-SteeringWheelHeater',
    'Resolve-OptionCodes'
)
# Cmdlets to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no cmdlets to export.
CmdletsToExport = @()

# Variables to export from this module
VariablesToExport = @('selectedId', 'vehicles')

# Aliases to export from this module, for best performance, do not use wildcards and do not delete the entry, use an empty array if there are no aliases to export.
AliasesToExport = @()

# DSC resources to export from this module
# DscResourcesToExport = @()

# List of all modules packaged with this module
# ModuleList = @()

# List of all files packaged with this module
FileList = @('TeslaMatrix.psd1', 'TeslaMatrix.psm1', 'OptionCodes.ps1', 'optioncode.csv', 'bin/netstandard2.1/TeslaMatrix.TeslaLogin.dll')

# Private data to pass to the module specified in RootModule/ModuleToProcess. This may also contain a PSData hashtable with additional module metadata used by PowerShell.
PrivateData = @{

    PSData = @{

        # Tags applied to this module. These help with module discovery in online galleries.
        # Tags = @()

        # A URL to the license for this module.
        # LicenseUri = ''

        # A URL to the main website for this project.
        # ProjectUri = ''

        # A URL to an icon representing this module.
        # IconUri = ''

        # ReleaseNotes of this module
        ReleaseNotes = 'Remove unneeded Http status code output'

        # Prerelease string of this module
        # Prerelease = ''

        # Flag to indicate whether the module requires explicit user acceptance for install/update/save
        # RequireLicenseAcceptance = $false

        # External dependent modules of this module
        # ExternalModuleDependencies = @()

    } # End of PSData hashtable

} # End of PrivateData hashtable

# HelpInfo URI of this module
# HelpInfoURI = ''

# Default prefix for commands exported from this module. Override the default prefix using Import-Module -Prefix.
# DefaultCommandPrefix = ''

}

