<#
.SYNOPSIS
Set playback volume.

.DESCRIPTION
Set the volume for the user’s current playback device.

.PARAMETER VolumePercent
The volume to set. Must be a value from 0 to 100 inclusive. Example value: 50.

.PARAMETER DeviceId
The id of the device this command is targeting. If not supplied, the user's currently active device is the target.
Example value: "0d1841b0976bae2a3a310dd74c0f3df354899bc8".

.EXAMPLE
Set-SpotifyPlaybackVolume 50

.EXAMPLE
Set-SpotifyPlaybackVolume -VolumePercent 25 -DeviceId "0d1841b0976bae2a3a310dd74c0f3df354899bc8"

.LINK
https://developer.spotify.com/documentation/web-api/reference/#/operations/set-volume-for-users-playback
#>
function Set-SpotifyPlaybackVolume {
    param (
        [Parameter(Mandatory, Position = 0)]
        [ValidateRange(0, 100)]
        [int] $VolumePercent,

        [Parameter(Position = 1)]
        [ValidateNotNullOrEmpty()]
        [string] $DeviceId
    )
    $null = Invoke-RestMethod `
        -Uri "https://api.spotify.com/v1/me/player/volume?volume_percent=$($VolumePercent)$($DeviceId ? "&device_id=$($DeviceId)" : $null)" `
        -Method Put `
        -Authentication Bearer `
        -Token $global:SpotifyToken `
        -ContentType "application/json"
}