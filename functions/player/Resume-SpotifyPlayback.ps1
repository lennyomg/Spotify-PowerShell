<#
.SYNOPSIS
Resume playback.

.DESCRIPTION
Resume current playback on the user's active device.

.PARAMETER DeviceId
The id of the device this command is targeting. If not supplied, the user's currently active device is the target.
Example value: "0d1841b0976bae2a3a310dd74c0f3df354899bc8".

.EXAMPLE
Resume-SpotifyPlayback

.EXAMPLE
Resume-SpotifyPlayback "0d1841b0976bae2a3a310dd74c0f3df354899bc8"

.FUNCTIONALITY
Player

.LINK
https://developer.spotify.com/documentation/web-api/reference/#/operations/start-a-users-playback
#>
function Resume-SpotifyPlayback {
    param (
        [Parameter(Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string] $DeviceId
    )
    $null = Invoke-RestMethod `
        -Uri "https://api.spotify.com/v1/me/player/play$($DeviceId ? "?device_id=$($DeviceId)" : $null)" `
        -Method Put `
        -Authentication Bearer `
        -Token $global:SpotifyToken `
        -ContentType "application/json"
}