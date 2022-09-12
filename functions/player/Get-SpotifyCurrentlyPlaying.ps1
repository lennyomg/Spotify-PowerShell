<#
.SYNOPSIS
Get currently playing tracks.

.DESCRIPTION
Get the object currently being played on the user's Spotify account.

.LINK
https://developer.spotify.com/documentation/web-api/reference/#/operations/get-the-users-currently-playing-track
#>
function Get-SpotifyCurrentlyPlaying {
    Invoke-RestMethod `
        -Uri "https://api.spotify.com/v1/me/player/currently-playing" `
        -Method Get `
        -Authentication Bearer `
        -Token $global:SpotifyToken `
        -ContentType "application/json"
}