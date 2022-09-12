<#
.SYNOPSIS
Set repeat mode.

.DESCRIPTION
Set the repeat mode for the user's playback. Options are repeat-track, repeat-context, and off.

.PARAMETER State
'track' will repeat the current track.
'context' will repeat the current context.
'off' will turn repeat off.

.PARAMETER DeviceId
The id of the device this command is targeting. If not supplied, the user's currently active device is the target.
Example value: "0d1841b0976bae2a3a310dd74c0f3df354899bc8".

.EXAMPLE
Set-SpotifyPlaybackRepeat off

.EXAMPLE
Set-SpotifyPlaybackRepeat -State track -DeviceId "0d1841b0976bae2a3a310dd74c0f3df354899bc8"

.LINK
https://developer.spotify.com/documentation/web-api/reference/#/operations/set-repeat-mode-on-users-playback
#>
function Set-SpotifyPlaybackRepeat {
    param (
        [Parameter(Mandatory, Position = 0)]
        [ValidateSet("track", "context", "off")]
        [string] $State,

        [Parameter(Position = 1)]
        [ValidateNotNullOrEmpty()]
        [string] $DeviceId
    )
    $null = Invoke-RestMethod `
        -Uri "https://api.spotify.com/v1/me/player/repeat?state=$($State)$($DeviceId ? "&device_id=$($DeviceId)" : $null)" `
        -Method Put `
        -Authentication Bearer `
        -Token $global:SpotifyToken `
        -ContentType "application/json"
}