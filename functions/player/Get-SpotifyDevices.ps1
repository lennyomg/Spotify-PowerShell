<#
.SYNOPSIS
Get available devices.

.DESCRIPTION
Get information about a user’s available devices. Returns empty list if there is no active devices.

.FUNCTIONALITY
Player

.LINK
https://developer.spotify.com/documentation/web-api/reference/#/operations/get-a-users-available-devices
#>
function Get-SpotifyDevices {
    Invoke-RestMethod `
        -Uri "https://api.spotify.com/v1/me/player/devices" `
        -Method Get `
        -Authentication Bearer `
        -Token $global:SpotifyToken `
        -ContentType "application/json" | Select-Object -ExpandProperty devices
}