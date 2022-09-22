<#
.SYNOPSIS
Remove playlist items.

.DESCRIPTION
Remove one or more items from a user's playlist.

.PARAMETER PlaylistId
The Spotify ID of the playlist. Example value: "3cEYpjA9oz9GiPac4AsH4n".

.PARAMETER TrackId
An array of Spotify URIs of the tracks or episodes to remove. For example: "4iV5W9uYEdYUVa79Axb7Rh", "1301WleyT98MSxVHPZCA6M". Can be more than 100.

.EXAMPLE
Remove-SpotifyPlaylistTracks -PlaylistId "3cEYpjA9oz9GiPac4AsH4n" -TrackId "4iV5W9uYEdYUVa79Axb7Rh", "1301WleyT98MSxVHPZCA6M"

.EXAMPLE
"3cEYpjA9oz9GiPac4AsH4n"
| Get-SpotifyPlaylistTracks
| Remove-SpotifyPlaylistTracks "3cEYpjA9oz9GiPac4AsH4n"

.FUNCTIONALITY
Playlist

.LINK
https://developer.spotify.com/documentation/web-api/reference/#/operations/remove-tracks-playlist
#>
function Remove-SpotifyPlaylistTracks {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string] $PlaylistId,

        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 1)]
        [Alias("id")]
        [ValidateNotNullOrEmpty()]
        [string[]] $TrackId
    )
    begin {
        $pipe = @()
    }
    process {
        $pipe += $TrackId
    }
    end {
        $c = [pscustomobject]@{ i = 0 }
        $pipe   
        | Group-Object -Property { [System.Math]::Floor($c.i++ / 100) }
        | ForEach-Object { [pscustomobject]@{ tracks = $_.Group | ForEach-Object { [pscustomobject]@{ uri = "spotify:track:$($_)" } } } }
        | ForEach-Object {
            Invoke-RestMethod `
                -Uri "https://api.spotify.com/v1/playlists/$($PlaylistId)/tracks" `
                -Method Delete `
                -Authentication Bearer `
                -Token $global:SpotifyToken `
                -ContentType "application/json" `
                -Body ($_ | ConvertTo-Json -Depth 99)
        } 
        | Out-Null
    }
}