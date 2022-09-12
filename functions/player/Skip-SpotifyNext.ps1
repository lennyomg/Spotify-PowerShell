<#
.SYNOPSIS
Skip to next.

.DESCRIPTION
Skips to next track in the user’s queue.

.PARAMETER DeviceId
The id of the device this command is targeting. If not supplied, the user's currently active device is the target.
Example value: "0d1841b0976bae2a3a310dd74c0f3df354899bc8".

.EXAMPLE
Skip-SpotifyNext

.EXAMPLE
Skip-SpotifyNext "0d1841b0976bae2a3a310dd74c0f3df354899bc8"

.LINK
https://developer.spotify.com/documentation/web-api/reference/#/operations/skip-users-playback-to-next-track
#>
function Skip-SpotifyNext {
    param (
        [Parameter(Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string] $DeviceId
    )
    $null = Invoke-RestMethod `
        -Uri "https://api.spotify.com/v1/me/player/next$($DeviceId ? "?device_id=$($DeviceId)" : $null)" `
        -Method Post `
        -Authentication Bearer `
        -Token $global:SpotifyToken `
        -ContentType "application/json"
}