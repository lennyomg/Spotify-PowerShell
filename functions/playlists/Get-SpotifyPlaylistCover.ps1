<#
.SYNOPSIS
Get playlist cover image.

.DESCRIPTION 
Get the current image associated with a specific playlist.

.PARAMETER PlaylistId
The Spotify ID of the playlist. Example value: "3cEYpjA9oz9GiPac4AsH4n".

.EXAMPLE
Get-SpotifyPlaylistCover -PlaylistId "3cEYpjA9oz9GiPac4AsH4n"

.EXAMPLE
"3cEYpjA9oz9GiPac4AsH4n" | Get-SpotifyPlaylistCover

.LINK
https://developer.spotify.com/documentation/web-api/reference/#/operations/get-playlist-cover
#>
function Get-SpotifyPlaylistCover {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
        [Alias("id")]
        [ValidateNotNullOrEmpty()]
        [string] $PlaylistId
    )
    process {
        Invoke-RestMethod `
            -Uri "https://api.spotify.com/v1/playlists/$($PlaylistId)/images" `
            -Method Get `
            -Authentication Bearer `
            -Token $global:SpotifyToken `
            -ContentType "application/json"
    }
}