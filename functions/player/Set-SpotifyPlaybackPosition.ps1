<#
.SYNOPSIS
Seek to position.

.DESCRIPTION
Seeks to the given position in the user’s currently playing track.

.PARAMETER Position
The position in milliseconds to seek to. Must be a positive number. Passing in a position that is greater than the length of the track will cause the player to start playing the next song.
Example value: 25000.

.PARAMETER DeviceId
The id of the device this command is targeting. If not supplied, the user's currently active device is the target.
Example value: "0d1841b0976bae2a3a310dd74c0f3df354899bc8".

.EXAMPLE
Set-SpotifyPlaybackPosition 25000

.EXAMPLE
Set-SpotifyPlaybackPosition -Position 25000 -DeviceId "0d1841b0976bae2a3a310dd74c0f3df354899bc8"

.LINK
https://developer.spotify.com/documentation/web-api/reference/#/operations/seek-to-position-in-currently-playing-track
#>
function Set-SpotifyPlaybackPosition {
    param (
        [Parameter(Mandatory, Position = 0)]
        [ValidateRange(0, 2147483647)]
        [int] $Position,

        [Parameter(Position = 1)]
        [ValidateNotNullOrEmpty()]
        [string] $DeviceId
    )
    $null = Invoke-RestMethod `
        -Uri "https://api.spotify.com/v1/me/player/seek?position_ms=$($Position)$($DeviceId ? "&device_id=$($DeviceId)" : $null)" `
        -Method Put `
        -Authentication Bearer `
        -Token $global:SpotifyToken `
        -ContentType "application/json"
}