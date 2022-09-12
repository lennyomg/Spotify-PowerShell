<#
.SYNOPSIS
Start playback.

.DESCRIPTION
Start a new context playback on the user's active device.

.PARAMETER DeviceId
The id of the device this command is targeting. If not supplied, the user's currently active device is the target.
Example value: "0d1841b0976bae2a3a310dd74c0f3df354899bc8".

.PARAMETER ContextUri
Optional. Spotify URI of the context to play. Valid contexts are albums, artists & playlists. Example: "spotify:album:1Je1IMUlBXcx1Fz0WE7oPT".

.PARAMETER TrackUri
Optional. A JSON array of the Spotify track URIs to play. For example: "spotify:track:4iV5W9uYEdYUVa79Axb7Rh", "spotify:track:1301WleyT98MSxVHPZCA6M"

.PARAMETER Offset
Optional. Integer or string.
Indicates from where in the context playback should start. 
Only available when context_uri corresponds to an album or playlist. 
Example "5" or "spotify:track:1301WleyT98MSxVHPZCA6M".

.PARAMETER Position
Optional. Track position in milliseconds.

.EXAMPLE
Start-SpotifyPlayback `
    -ContextUri "spotify:album:1Je1IMUlBXcx1Fz0WE7oPT" `
    -Offset 2

.EXAMPLE
Start-SpotifyPlayback `
    -TrackUri "6dOuyNJIAQC7ws10eEk0G9", "2Eqv3lSPNQCbtHfHTIlyKK", "4Xz2mxHREzWiEr0AyCJuU6" `
    -Offset "spotify:track:2Eqv3lSPNQCbtHfHTIlyKK" `
    -Position 5000 `
    -DeviceId "0d1841b0976bae2a3a310dd74c0f3df354899bc8"

.FUNCTIONALITY
Player

.LINK
https://developer.spotify.com/documentation/web-api/reference/#/operations/start-a-users-playback
#>
function Start-SpotifyPlayback {
    [CmdletBinding(PositionalBinding = $false)]
    param (
        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string] $DeviceId,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string] $ContextUri,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string[]] $TrackUri,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string] $Offset,

        [Parameter()]
        [int] $Position
    )

    $body = @{}
    foreach ($p in $PSBoundParameters.Keys) {
        switch ($p) {
            "ContextUri" { $body.context_uri = $ContextUri }
            "TrackUri" { $body.uris = $TrackUri }
            "Offset" { $body.offset = $Offset.Contains("spotify:track:") ? [pscustomobject]@{ uri = $Offset } : [pscustomobject]@{ position = $Offset } }
            "Position" { $body.position_ms = $Position }
        }
    }

    $null = Invoke-RestMethod `
        -Uri "https://api.spotify.com/v1/me/player/play$($DeviceId ? "?device_id=$($DeviceId)" : $null)" `
        -Method Put `
        -Authentication Bearer `
        -Token $global:SpotifyToken `
        -ContentType "application/json" `
        -Body ($body | ConvertTo-Json -Depth 99)
}