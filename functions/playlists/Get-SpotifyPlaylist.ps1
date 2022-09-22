<#
.SYNOPSIS
Get playlist.

.DESCRIPTION 
Get a playlist owned by a Spotify user.

.PARAMETER PlaylistId
The Spotify ID of the playlist. Example value: "3cEYpjA9oz9GiPac4AsH4n".

.EXAMPLE
Get-SpotifyPlaylist -PlaylistId "3cEYpjA9oz9GiPac4AsH4n"

.EXAMPLE
"3cEYpjA9oz9GiPac4AsH4n" | Get-SpotifyPlaylist

.FUNCTIONALITY
Playlist

.LINK
https://developer.spotify.com/documentation/web-api/reference/#/operations/get-playlist
#>
function Get-SpotifyPlaylist {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)] 
        [Alias("id")]
        [ValidateNotNullOrEmpty()]
        [string] $PlaylistId
    )
    process {
        Invoke-RestMethod `
            -Uri "https://api.spotify.com/v1/playlists/$($PlaylistId)" `
            -Method Get `
            -Authentication Bearer `
            -Token $global:SpotifyToken `
            -ContentType "application/json"
        | ForEach-Object { $_.PSObject.TypeNames.Add("spfy.$($_.type)"); $_ }
    }
}