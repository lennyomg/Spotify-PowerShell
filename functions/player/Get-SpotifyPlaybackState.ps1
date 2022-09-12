<#
.SYNOPSIS
Get playback state.

.DESCRIPTION
Get information about the user’s current playback state, including track or episode, progress, and active device.
Returns emtpy object if there is not active playback.

.LINK
https://developer.spotify.com/documentation/web-api/reference/#/operations/get-information-about-the-users-current-playback
#>
function Get-SpotifyPlaybackState {
    Invoke-RestMethod `
        -Uri "https://api.spotify.com/v1/me/player" `
        -Method Get `
        -Authentication Bearer `
        -Token $global:SpotifyToken `
        -ContentType "application/json"
}