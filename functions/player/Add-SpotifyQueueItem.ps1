<#
.SYNOPSIS
Add item to playback queue.

.DESCRIPTION
Add an item to the end of the user's current playback queue.

.PARAMETER Uri
The uri of the item to add to the queue. Must be a track or an episode uri.
Example value: "spotify:track:4iV5W9uYEdYUVa79Axb7Rh".

.PARAMETER DeviceId
The id of the device this command is targeting. If not supplied, the user's currently active device is the target.
Example value: "0d1841b0976bae2a3a310dd74c0f3df354899bc8".

.FUNCTIONALITY
Player

.LINK
https://developer.spotify.com/documentation/web-api/reference/#/operations/add-to-queue
#>
function Add-SpotifyQueueItem {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [Alias("uri")]
        [string] $ItemUri,

        [Parameter(Position = 1)]
        [ValidateNotNullOrEmpty()]
        [string] $DeviceId
    )
    process {
        $null = Invoke-RestMethod `
            -Uri "https://api.spotify.com/v1/me/player/queue?uri=$($ItemUri)$($DeviceId ? "&device_id=$($DeviceId)" : $null)" `
            -Method Post `
            -Authentication Bearer `
            -Token $global:SpotifyToken `
            -ContentType "application/json"
    }
}