<#
.SYNOPSIS
Add items to playlist.

.DESCRIPTION
Add one or more items to a user's playlist.

.PARAMETER PlaylistId
The Spotify ID of the playlist. Example value: "3cEYpjA9oz9GiPac4AsH4n".

.PARAMETER TrackUri
An array of Spotify URIs of the tracks or episodes to remove. For example: "spotify:track:4iV5W9uYEdYUVa79Axb7Rh", "spotify:track:1301WleyT98MSxVHPZCA6M". Can be more than 100.

.EXAMPLE
Add-SpotifyPlaylistTracks -PlaylistId "3cEYpjA9oz9GiPac4AsH4n" -TrackUri "spotify:track:4iV5W9uYEdYUVa79Axb7Rh", "spotify:track:1301WleyT98MSxVHPZCA6M"

.EXAMPLE
Get-SpotifySavedAlbums
| Get-SpotifyAlbumTracks
| Select-Object -ExpandProperty uri -Unique
| Sort-Object { Get-Random }
| Add-SpotifyPlaylistTracks "69kakrmDURRcDTMOnI9PXX"

.FUNCTIONALITY
Playlist

.LINK
https://developer.spotify.com/documentation/web-api/reference/#/operations/add-tracks-to-playlist
#>
function Add-SpotifyPlaylistTracks {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string] $PlaylistId,

        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 1)]
        [Alias("uri")]
        [ValidateNotNullOrEmpty()]
        [string[]] $TrackUri
    )
    begin {
        $pipe = @()
    }
    process {
        $pipe += $TrackUri
    }
    end {
        $c = [pscustomobject]@{ i = 0 }
        $pipe   
        | Group-Object -Property { [System.Math]::Floor($c.i++ / 100) }
        | ForEach-Object { [pscustomobject]@{ uris = $_.Group } }
        | ForEach-Object {
            Invoke-RestMethod `
                -Uri "https://api.spotify.com/v1/playlists/$($PlaylistId)/tracks" `
                -Method Post `
                -Authentication Bearer `
                -Token $global:SpotifyToken `
                -ContentType "application/json" `
                -Body ($_ | ConvertTo-Json -Depth 99)
        } 
        | Out-Null
    }
}