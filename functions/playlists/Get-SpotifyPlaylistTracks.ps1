<#
.SYNOPSIS
Get playlist items.

.DESCRIPTION
Get full details of the items of a playlist owned by a Spotify user.

.PARAMETER PlaylistId
The Spotify ID of the playlist. Example value: "3cEYpjA9oz9GiPac4AsH4n".

.EXAMPLE
Get-SpotifyPlaylistTracks "3cEYpjA9oz9GiPac4AsH4n" | Select-Object -ExpandProperty track

.FUNCTIONALITY
Playlist

.LINK
https://developer.spotify.com/documentation/web-api/reference/#/operations/get-playlists-tracks
#>
function Get-SpotifyPlaylistTracks {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
        [Alias("id")]
        [string] $PlaylistId
    )

    process {
        $r = [pscustomobject]@{ next = "https://api.spotify.com/v1/playlists/$($PlaylistId)/tracks?limit=100" }
        & { while ($r.next) {
                $r = Invoke-RestMethod `
                    -Uri $r.next `
                    -Method Get `
                    -Authentication Bearer `
                    -Token $global:SpotifyToken `
                    -ContentType "application/json"; $r 
            } 
        } | Select-Object -ExpandProperty items
    }
}