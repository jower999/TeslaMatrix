# Module for tesla api integration

#region login methods
function Get-AccessToken
{
    if ($null -ne $script:credential)
    {
        $body = @{
            email=$script:Credential.Username
            password=$script:Credential.GetNetworkCredential().Password
            client_secret=$script:client_secret
            client_id=$script:client_id
            grant_type="password"
        } | ConvertTo-Json
    }
    else
    {
        if ($null -eq $script:refreshtoken -or "" -eq $script:refreshtoken)
        {
            throw "Error initializing with no refresh token or credentials"
        }
        $body = @{
            refresh_token=$script:refreshtoken
            client_secret=$script:client_secret
            client_id=$script:client_id
            grant_type="refresh_token"
        } | ConvertTo-Json
    }
    Invoke-RestMethod -Method Post -Uri (GetRelativeUri "oauth/token") -ContentType "application/json" -Body $body
}

function Revoke-AccessToken
{
    $body = @{
        token=$script:AccessToken.access_token
    } | ConvertTo-Json
    Invoke-RestMethod -Method Post -Uri (GetRelativeUri "oauth/revoke") -ContentType "application/json" -Body $body
}

function Get-LoginDetails
{
    $script:AccessToken | Select-Object access_token, 
        token_type, 
        refresh_token, 
        @{Name="Created";Expression={[System.DateTimeOffset]::FromUnixTimeSeconds($_.created_at).DateTime}}, 
        @{Name="Expiry";Expression={[System.DateTimeOffset]::FromUnixTimeSeconds($_.created_at).AddSeconds($_.expires_in).DateTime}}
}
#endregion login methods

#region Public methods
function Get-Vehicles
{
    [CmdletBinding()]
    param ()
    $vehic = Invoke-TeslaAPI -Method Get -Uri "api/1/vehicles"

    return $vehic
}

function Get-Vehicle 
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [int64]$id
    )
    $vehic = Invoke-TeslaAPI -Method Get -Uri "api/1/vehicles/{0}" -id $id 

    return $vehic

}

function Get-VehicleData
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int64]$id=$(Get-SelectedVehicleId)
    )
    Invoke-TeslaAPI -Method Get -Uri "api/1/vehicles/{0}/vehicle_data" -id $id -AccessToken $script:AccessToken 
}

function Get-ChargeState
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int64]$id=$(Get-SelectedVehicleId)
    )
    Invoke-TeslaAPI -Method Get -Uri "api/1/vehicles/{0}/data_request/charge_state" -id $id
}

function Get-ClimateState
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int64]$id=$(Get-SelectedVehicleId)
    )
    Invoke-TeslaAPI -Method Get -Uri "api/1/vehicles/{0}/data_request/climate_state" -id $id
}

function Get-DriveState
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int64]$id=$(Get-SelectedVehicleId)
    )
    Invoke-TeslaAPI -Method Get -Uri "api/1/vehicles/{0}/data_request/drive_state" -id $id
}

function Get-GUISettings 
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int64]$id=$(Get-SelectedVehicleId)
    )
    Invoke-TeslaAPI -Method Get -Uri "api/1/vehicles/{0}/data_request/gui_settings" -id $id
}


function Get-VehicleState
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int64]$id=$(Get-SelectedVehicleId)
    )
    Invoke-TeslaAPI -Method Get -Uri "api/1/vehicles/{0}/data_request/vehicle_state" -id $id
}

function Get-VehicleConfig
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int64]$id=$(Get-SelectedVehicleId)
    )
    Invoke-TeslaAPI -Method Get -Uri "api/1/vehicles/{0}/data_request/vehicle_config" -id $id
}

function Get-MobileEnabled
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int64]$id=$(Get-SelectedVehicleId)
    )
    Invoke-TeslaAPI -Method Get -Uri "api/1/vehicles/{0}/mobile_enabled" -id $id
}

function Get-NearByChargingSites
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int64]$id=$(Get-SelectedVehicleId)
    )
    Invoke-TeslaAPI -Method Get -Uri "api/1/vehicles/{0}/nearby_charging_sites" -id $id
}

function Invoke-Wakeup
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int64]$id=$(Get-SelectedVehicleId),
        [switch]$PassThru
    )
    Invoke-TeslaAPI -Method Post -Uri "api/1/vehicles/{0}/wake_up" -id $id -PassThru:$PassThru
}

function Invoke-HonkHorn
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int64]$id=$(Get-SelectedVehicleId).
        [switch]$PassThru
    )
    Invoke-TeslaAPI -Method Post -Uri "api/1/vehicles/{0}/command/honk_horn" -id $id -PassThru:$PassThru
}

function Invoke-FlashLights
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int64]$id=$(Get-SelectedVehicleId),
        [switch]$PassThru
    )
    Invoke-TeslaAPI -Method Post -Uri "api/1/vehicles/{0}/command/flash_lights" -id $id -PassThru:$PassThru
}

function Invoke-RemoteStartDrive
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int64]$id=$(Get-SelectedVehicleId),
        [securestring]$password=($script:Credential.Password),
        [switch]$PassThru
    )
    Invoke-TeslaAPI -Method Post -Uri "api/1/vehicles/{0}/command/remote_start_drive" -id $id -body @{password=(ConvertFrom-SecureString -SecureString $password)} -PassThru:$PassThru
}

function Set-SpeedLimit
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int64]$id=$(Get-SelectedVehicleId),
        [Parameter(Mandatory=$true)]
        $speedLimit,
        [switch]$PassThru
    )
    $speedLimitMph = ([math]::Round((ConvertFrom-Kilometers $speedLimit)))
    Write-Verbose ("Setting speedlimit to {0} km/h ({1} MPH)" -f $speedLimit, $speedLimitMph)
    Invoke-TeslaAPI -Method Post -Uri "api/1/vehicles/{0}/command/speed_limit_set_limit" -id $id -body @{limit_mph=$speedLimitMph} -PassThru:$PassThru
}

function Enable-SpeedLimit
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int64]$id=$(Get-SelectedVehicleId),
        [Parameter(Mandatory=$true)]
        [int]$pincode,
        [switch]$PassThru
    )
    Invoke-TeslaAPI -Method Post -Uri "api/1/vehicles/{0}/command/speed_limit_activate" -id $id -body @{pin=$pincode} -PassThru:$PassThru
}

function Disable-SpeedLimit
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int64]$id=$(Get-SelectedVehicleId),
        [Parameter(Mandatory=$true)]
        [int]$pincode,
        [switch]$PassThru
    )
    Invoke-TeslaAPI -Method Post -Uri "api/1/vehicles/{0}/command/speed_limit_deactivate" -id $id -body @{pin=$pincode} -PassThru:$PassThru
}

function Clear-SpeedLimitPin
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int64]$id=$(Get-SelectedVehicleId),
        [Parameter(Mandatory=$true)]
        [int]$pincode,
        [switch]$PassThru
    )
    Invoke-TeslaAPI -Method Post -Uri "api/1/vehicles/{0}/command/speed_limit_clear_pin" -id $id -body @{pin=$pincode} -PassThru:$PassThru
}

function Enable-ValetMode
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int64]$id=$(Get-SelectedVehicleId),
        [Parameter(Mandatory=$true)]
        [securestring]$password,
        [switch]$PassThru
    )
    Invoke-TeslaAPI -Method Post -Uri "api/1/vehicles/{0}/command/set_valet_mode" -id $id -body @{on='true';password=(ConvertFrom-SecureString $password)} -PassThru:$PassThru
}

function Disable-ValetMode
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int64]$id=$(Get-SelectedVehicleId),
        [Parameter(Mandatory=$true)]
        [securestring]$password,
        [switch]$PassThru
    )
    Invoke-TeslaAPI -Method Post -Uri "api/1/vehicles/{0}/command/set_valet_mode" -id $id -body @{on='false';password=(ConvertFrom-SecureString $password)} -PassThru:$PassThru
}

function Reset-ValetPassword
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int64]$id=$(Get-SelectedVehicleId),
        [switch]$PassThru
    )
    Invoke-TeslaAPI -Method Post -Uri "api/1/vehicles/{0}/command/reset_valet_pin" -id $id -PassThru:$PassThru
}

function Enable-SentryMode
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int64]$id=$(Get-SelectedVehicleId),
        [switch]$PassThru
    )
    Invoke-TeslaAPI -Method Post -Uri "api/1/vehicles/{0}/command/set_sentry_mode" -id $id -body @{on='true'} -PassThru:$PassThru
}

function Disable-SentryMode
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int64]$id=$(Get-SelectedVehicleId),
        [switch]$PassThru
    )
    Invoke-TeslaAPI -Method Post -Uri "api/1/vehicles/{0}/command/set_sentry_mode" -id $id -body @{on='false'} -PassThru:$PassThru
}

function Invoke-Trunk
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int64]$id=$(Get-SelectedVehicleId),
        [switch]$PassThru
    )
    Invoke-TeslaAPI -Method Post -Uri "api/1/vehicles/{0}/command/actuate_trunk" -id $id -body @{which_trunk='rear'} -PassThru:$PassThru
}

function Invoke-Frunk
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int64]$id=$(Get-SelectedVehicleId),
        [switch]$PassThru
    )
    Invoke-TeslaAPI -Method Post -Uri "api/1/vehicles/{0}/command/actuate_trunk" -id $id -body @{which_trunk='front'} -PassThru:$PassThru
}

function Open-Windows
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int64]$id=$(Get-SelectedVehicleId),
        [switch]$PassThru
    )
    # TODO, fetch current location and send that too
    Invoke-TeslaAPI -Method Post -Uri "api/1/vehicles/{0}/command/window_control" -id $id -body @{command='vent';lat=0;lon=0} -PassThru:$PassThru
}

function Close-Windows
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int64]$id=$(Get-SelectedVehicleId),
        $latitude,
        $longitude,
        [switch]$PassThru
    )
    # TODO, fetch current location and send that too
    Invoke-TeslaAPI -Method Post -Uri "api/1/vehicles/{0}/command/window_control" -id $id -body @{command='close';lat=$latitude;lon=$longitude}  -PassThru:$PassThru
}

function Open-ChargePort
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int64]$id=$(Get-SelectedVehicleId),
        [switch]$PassThru
    )
    Invoke-TeslaAPI -Method Post -Uri "api/1/vehicles/{0}/command/charge_port_door_open" -id $id -PassThru:$PassThru
}

function Close-ChargePort
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int64]$id=$(Get-SelectedVehicleId),
        [switch]$PassThru
    )
    Invoke-TeslaAPI -Method Post -Uri "api/1/vehicles/{0}/command/charge_port_door_close" -id $id -PassThru:$PassThru
}

function Start-Charging
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int64]$id=$(Get-SelectedVehicleId),
        [switch]$PassThru
    )
    Invoke-TeslaAPI -Method Post -Uri "api/1/vehicles/{0}/command/charge_start" -id $id -PassThru:$PassThru
}

function Stop-Charging
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int64]$id=$(Get-SelectedVehicleId),
        [switch]$PassThru
    )
    Invoke-TeslaAPI -Method Post -Uri "api/1/vehicles/{0}/command/charge_start" -id $id  -PassThru:$PassThru
}

function Set-ChargeStandard
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int64]$id=$(Get-SelectedVehicleId),
        [switch]$PassThru
    )
    Invoke-TeslaAPI -Method Post -Uri "api/1/vehicles/{0}/command/charge_standard" -id $id -PassThru:$PassThru
}

function Set-ChargeMaxRange
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int64]$id=$(Get-SelectedVehicleId),
        [switch]$PassThru
    )
    Invoke-TeslaAPI -Method Post -Uri "api/1/vehicles/{0}/command/charge_max_range" -id $id -PassThru:$PassThru
}

function Set-ChargeLimit
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int64]$id=$(Get-SelectedVehicleId),
        [Parameter(Mandatory=$true)]
        [int]$percent,
        [switch]$PassThru
    )
    Invoke-TeslaAPI -Method Post -Uri "api/1/vehicles/{0}/command/set_charge_limit" -id $id -body $[percent=$percent] -PassThru:$PassThru
}

function Start-AutoConditioning
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int64]$id=$(Get-SelectedVehicleId),
        [switch]$PassThru
    )
    Invoke-TeslaAPI -Method Post -Uri "api/1/vehicles/{0}/command/auto_conditioning_start" -id $id -PassThru:$PassThru
}

function Stop-AutoConditioning
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int64]$id=$(Get-SelectedVehicleId),
        [switch]$PassThru
    )
    Invoke-TeslaAPI -Method Post -Uri "api/1/vehicles/{0}/command/auto_conditioning_stop" -id $id -PassThru:$PassThru
}

function Set-Temperature
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int64]$id=$(Get-SelectedVehicleId),
        [Parameter(Mandatory=$true)]
        [string]$driverSideTempCelsius,
        [Parameter(Mandatory=$false)]
        [string]$passengerSideTempCelcius=$driverSideTempCelsius,
        [switch]$PassThru
    )
    Invoke-TeslaAPI -Method Post -Uri "api/1/vehicles/{0}/command/set_temps" -id $id -body @{driver_temp=$driverSideTempCelsius;passenger_temp=$passengerSideTempCelcius} -PassThru:$PassThru
}

function Start-PreConditioningMaxDefrost
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int64]$id=$(Get-SelectedVehicleId),
        [switch]$PassThru
    )
    Invoke-TeslaAPI -Method Post -Uri "api/1/vehicles/{0}/command/set_preconditioning_max" -id $id -body @{on='true'} -PassThru:$PassThru
}

function Stop-PreConditioningMaxDefrost
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int64]$id=$(Get-SelectedVehicleId),
        [switch]$PassThru
    )
    Invoke-TeslaAPI -Method Post -Uri "api/1/vehicles/{0}/command/set_preconditioning_max" -id $id -body @{on='false'} -PassThru:$PassThru
}

function Set-SeatHeaterLevel
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int64]$id=$(Get-SelectedVehicleId),
        [Parameter(Mandatory=$true)]
        [ValidateSet("Driver", "Passenger", "Rear left", "Rear center", "Rear right")]
        $heater,
        [Parameter(Mandatory=$true)]
        [ValidateSet("Low", "MediumLow", "MediumHigh", "High")]
        $level,
        [switch]$PassThru
    )
    $intHeater = $script:HeaterNames.$heater
    $intLevel = $script:HeaterLevels.$level
    Write-Verbose ("setting seat heater level on {0}({1} to level {2} ({3}))" -f $heater, $intHeater, $level, $intLevel)
    Invoke-TeslaAPI -Method Post -Uri "api/1/vehicles/{0}/command/remote_seat_heater_request" -id $id -body @{heater=$intHeater;level=$intLevel} -PassThru:$PassThru
}

function Start-SteeringWheelHeater
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int64]$id=$(Get-SelectedVehicleId),
        [switch]$PassThru
    )
    Invoke-TeslaAPI -Method Post -Uri "api/1/vehicles/{0}/command/remote_steering_wheel_heater_request" -id $id -body @{on='true'} -PassThru:$PassThru
}

function Stop-SteeringWheelHeater
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int64]$id=$(Get-SelectedVehicleId),
        [switch]$PassThru
    )
    Invoke-TeslaAPI -Method Post -Uri "api/1/vehicles/{0}/command/remote_steering_wheel_heater_request" -id $id -body @{on='false'} -PassThru:$PassThru
}

function Set-MediaPlayback
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int64]$id=$(Get-SelectedVehicleId),
        [switch]$PassThru
    )
    Invoke-TeslaAPI -Method Post -Uri "api/1/vehicles/{0}/command/media_toggle_playback" -id $id -PassThru:$PassThru
}

function Set-MediaNextTrack
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int64]$id=$(Get-SelectedVehicleId),
        [switch]$PassThru
    )
    Invoke-TeslaAPI -Method Post -Uri "api/1/vehicles/{0}/command/media_next_track" -id $id -PassThru:$PassThru
}

function Set-MediaPreviousTrack
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int64]$id=$(Get-SelectedVehicleId),
        [switch]$PassThru
    )
    Invoke-TeslaAPI -Method Post -Uri "api/1/vehicles/{0}/command/media_prev_track" -id $id -PassThru:$PassThru
}

function Set-MediaNextFavourite
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int64]$id=$(Get-SelectedVehicleId),
        [switch]$PassThru
    )
    Invoke-TeslaAPI -Method Post -Uri "api/1/vehicles/{0}/command/media_next_fav" -id $id -PassThru:$PassThru
}

function Set-MediaPrevousFavourite
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int64]$id=$(Get-SelectedVehicleId),
        [switch]$PassThru
    )
    Invoke-TeslaAPI -Method Post -Uri "api/1/vehicles/{0}/command/media_prev_fav" -id $id -PassThru:$PassThru
}

function Set-MediaVolumeUp
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int64]$id=$(Get-SelectedVehicleId),
        [switch]$PassThru
    )
    Invoke-TeslaAPI -Method Post -Uri "api/1/vehicles/{0}/command/media_volume_up" -id $id -PassThru:$PassThru
}

function Set-MediaVolumeDown
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int64]$id=$(Get-SelectedVehicleId),
        [switch]$PassThru
    )
    Invoke-TeslaAPI -Method Post -Uri "api/1/vehicles/{0}/command/media_volume_down" -id $id -PassThru:$PassThru
}

function Start-Share
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int64]$id=$(Get-SelectedVehicleId),
        [Parameter(Mandatory=$false)]
        $locale="en-US",
        [Parameter(Mandatory=$false)]
        [string]$value,
        [switch]$PassThru
    )

    #TODO: Verify the android scheisse is needed :-)
    Invoke-TeslaAPI -Method Post -Uri "api/1/vehicles/{0}/command/share" -id $id -body @{
        type='share_ext_content_raw'
        locale=$locale
        timestamp_ms=$([DateTimeOffset]::Now.ToUnixTimeMilliseconds())
        value=@{'android.intent.extra.TEXT'=$value}
    } -PassThru:$PassThru
}

function Start-SoftwareUpdate
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int64]$id=$(Get-SelectedVehicleId),
        [Parameter(Mandatory=$false)]
        $delayInSeconds=30,
        [switch]$PassThru
    )
    Invoke-TeslaAPI -Method Post -Uri "api/1/vehicles/{0}/command/schedule_software_update" -id $id -body @{offset_sec=$delayInSeconds} -PassThru:$PassThru
}

function Stop-SoftwareUpdate
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false, ValueFromPipelineByPropertyName=$true)]
        [int64]$id=$(Get-SelectedVehicleId),
        [switch]$PassThru
    )
    Invoke-TeslaAPI -Method Post -Uri "api/1/vehicles/{0}/command/cancel_software_update" -id $id -PassThru:$PassThru
}

function Resolve-OptionCodes 
{
    param
    (
        [string[]]$optionCodes
    )

    foreach ($optionCode in $optionCodes)
    {
        $teslaOptionCodeLookup.$optionCode
    }
}

<#
.SYNOPSIS
Get free Super Charging. 
.DESCRIPTION
By using this link (which opens in your default browser) you will get 1000 miles / 1500 km of free super charging when you buy a new tesla
#>
function Get-FreeSuperCharging
{
    $referralLink = "https://ts.la/john53080"
    Start-Process $referralLink
}
Set-Alias FreeSuperCharging Get-FreeSuperCharging

function Select-Vehicle
{
    param 
    (
        [Parameter(Mandatory=$true, ValueFromPipelineByPropertyName=$true)]
        [Int64]$id
    )

    $script:selectedId = $id
}

#endregion Public methods

#region Utility methods
function Get-SelectedVehicleId
{
    if ($script:vehicles.Count -eq 0){
        throw "You have no vehicles in your tesla account, waiting to take delivery?"
    }
    if (-not ($script:selectedId)){
        throw "There is no vehicle selected. Maybe you have more than one vehicle and need to call Select-Vehicle?"
    }
    return $script:selectedId
}
function ConvertTo-Kilometers
{
    [CmdletBinding()]
    param (
        [Parameter()]
        [int]$miles
    )
    return $miles * $script:conversionFactor
}

function ConvertFrom-Kilometers
{
    [CmdletBinding()]
    param (
        [Parameter()]
        [int]$kilometers
    )
    return $kilometers / $script:conversionFactor
}


<#
.SYNOPSIS
Utility method to call the api using correct header

.DESCRIPTION
Long description

.PARAMETER uri
The uri to send request to

.PARAMETER method
The method of the request (Get, Post, ...)

.PARAMETER AccessToken
The AccessToken returned from the call to Get-MyTeslaAccessToken
#>
function Invoke-TeslaAPI
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [int64]$id,
        [Parameter(Mandatory=$true)]
        [string]$uri,
        [ValidateSet("Get", "Post")]
        [string]$method="Get",
        [PSCustomObject]$AccessToken=$script:AccessToken,
        [Parameter(Mandatory=$false)]
        [switch]$PassThru,
        [Parameter(Mandatory=$false)]
        $body
    )
    $header = @{Authorization=("Bearer {0}" -f $AccessToken.access_token)}
    if ($null -eq $body){
        $result = Invoke-RestMethod -Method $method -Uri (GetRelativeUri $uri -id $id) -Headers $header
    }
    else {
        Write-Verbose ("Sending JSon body with request '{0}'" -f (ConvertTo-Json $body))
        $result = Invoke-RestMethod -Method $method -Uri (GetRelativeUri $uri -id $id) -Headers $header -Body (ConvertTo-Json $body) -ContentType "application/json"
    }
    if ($PassThru -and $null -ne $result.response -and $result.response.result -eq $true){
        return Get-Vehicle -id $id
    }
    return $result.response
}

function GetRelativeUri
{
    [CmdletBinding()]
    param (
        [Parameter()]
        [string]$relativeUri,
        [Parameter(Mandatory=$false)]
        [int64]$id
    )
    $relUri = $relativeUri
    if ($id -ne 0)
    {
        $relUri = ($relativeUri -f $id)
    }
    return ("{0}/{1}" -f $script:baseUri, $relUri)
}

#endregion Utility methods

#region Module init
function InitializeModule
{
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [pscredential]$Credential,
        [Parameter(Mandatory=$false)]
        [string]$RefreshToken

    )
    $script:credential = $Credential
    $script:refreshtoken = $RefreshToken
    $script:client_secret="c7257eb71a564034f9419ee651c7d0e5f7aa6bfbd18bafb5c5c033b093bb2fa3"
    $script:client_id="81527cff06843c8634fdc09e8ac0abefb46ac849f38fe1e431c2ef2106796384"
    $script:baseUri = "https://owner-api.teslamotors.com"
    $script:conversionFactor = 1.609344
    $script:HeaterNames = @{Driver=0;Passenger=1;'Rear left'=2;'Rear center'=4;'Rear right'=5}
    $script:HeaterLevels = @{Low=0;MediumLow=1;MediumHigh=2;High=3}
    . $PSScriptRoot\optionCodes.ps1
    $script:AccessToken = Get-AccessToken
    $script:vehicles = Get-Vehicles
    $script:selectedId = $script:vehicles[0].id
}

if ($Args[0] -isnot [Hashtable] -or ($Args[0].Credential -isnot [pscredential] -and $Args[0].TestMode -eq $false) -or ($null -ne $args[0].RefreshToken -and $args[0].TestMode -eq $false))
{    
    $cred = Get-Credential -Message "Please enter your tesla credentials"
    InitializeModule -Credential $cred
}
else 
{
    if ($args[0].Credential -is [pscredential] -and $Args[0].TestMode -ne $true)
    {
        InitializeModule -Credential $Args[0].Credential
    }
    else 
    {
        if ($null -ne $args[0].RefreshToken -and  $Args[0].TestMode -ne $true)
        {
            InitializeModule -RefreshToken $args[0].RefreshToken
        }
    }
}



#endregion Module init

Export-ModuleMember -Function * -Variable AccessToken, vehicles, selectedId