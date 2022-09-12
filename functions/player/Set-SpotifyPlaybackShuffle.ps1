<#
.SYNOPSIS
Toggle playback shuffle.

.DESCRIPTION
Toggle shuffle on or off for user’s playback.

.PARAMETER State
'true': Shuffle user's playback.
'false': Do not shuffle user's playback.

.PARAMETER DeviceId
The id of the device this command is targeting. If not supplied, the user's currently active device is the target.
Example value: "0d1841b0976bae2a3a310dd74c0f3df354899bc8".

.EXAMPLE
Set-SpotifyPlaybackShuffle $false

.EXAMPLE
Set-SpotifyPlaybackShuffle -State $true -DeviceId "0d1841b0976bae2a3a310dd74c0f3df354899bc8"

.LINK
https://developer.spotify.com/documentation/web-api/reference/#/operations/toggle-shuffle-for-users-playback
#>
function Set-SpotifyPlaybackShuffle {
    param (
        [Parameter(Mandatory, Position = 0)]
        [bool] $State,

        [Parameter(Position = 1)]
        [ValidateNotNullOrEmpty()]
        [string] $DeviceId
    )
    $null = Invoke-RestMethod `
        -Uri "https://api.spotify.com/v1/me/player/shuffle?state=$($State)$($DeviceId ? "&device_id=$($DeviceId)" : $null)" `
        -Method Put `
        -Authentication Bearer `
        -Token $global:SpotifyToken `
        -ContentType "application/json"
}