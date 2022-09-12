<#
.SYNOPSIS
Transfer playback.

.DESCRIPTION
Transfer playback to a new device and determine if it should start playing.

.PARAMETER DeviceId
ID of the device on which playback should be started/transferred.

.EXAMPLE
Move-SpotifyPlayback "74ASZWbe4lXaubB36ztrGX"

.LINK
https://developer.spotify.com/documentation/web-api/reference/#/operations/transfer-a-users-playback
#>
function Move-SpotifyPlayback {
    param (
        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string] $DeviceId
    )
    $null = Invoke-RestMethod `
        -Uri "https://api.spotify.com/v1/me/player" `
        -Method Put `
        -Authentication Bearer `
        -Token $global:SpotifyToken `
        -ContentType "application/json" `
        -Body ([pscustomobject]@{ device_ids = @($DeviceId) } | ConvertTo-Json -Depth 99)
}