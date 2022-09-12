<#
.SYNOPSIS
Save tracks for current user.

.DESCRIPTION
Save one or more tracks to the current user's 'Your Music' library.

.PARAMETER TrackId
A list of the Spotify IDs. For example: "4iV5W9uYEdYUVa79Axb7Rh", "1301WleyT98MSxVHPZCA6M". Maximum: 50 IDs.

.EXAMPLE
Add-SpotifyTrack -TrackId "4iV5W9uYEdYUVa79Axb7Rh", "1301WleyT98MSxVHPZCA6M"

.EXAMPLE
Get-SpotifyAlbumTracks -AlbumId "4aawyAB9vmqN3uQ7FjRGTy" | Add-SpotifyTrack

.FUNCTIONALITY
Track

.LINK
https://developer.spotify.com/documentation/web-api/reference/#/operations/save-tracks-user
#>
function Add-SpotifyTrack {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
        [Alias("id")]
        [ValidateNotNullOrEmpty()]
        [ValidateCount(1, 50)]
        [string[]] $TrackId
    )
    process {
        $null = Invoke-RestMethod `
            -Uri "https://api.spotify.com/v1/me/tracks" `
            -Method Put `
            -Authentication Bearer `
            -Token $global:SpotifyToken `
            -Body (, $TrackId | ConvertTo-Json) `
            -ContentType "application/json"    
    }
}