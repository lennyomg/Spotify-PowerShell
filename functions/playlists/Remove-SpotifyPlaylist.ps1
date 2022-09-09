<#
.SYNOPSIS
Unfollow playlist.

.DESCRIPTION
Remove the current user as a follower of a playlist.

.PARAMETER PlaylistId
The Spotify ID of the playlist. Example value: "3cEYpjA9oz9GiPac4AsH4n".

.EXAMPLE
Remove-SpotifyPlaylist -PlaylistId "3cEYpjA9oz9GiPac4AsH4n"

.EXAMPLE
"3cEYpjA9oz9GiPac4AsH4n", "37i9dQZF1DX91oIci4su1D" | Remove-SpotifyPlaylist

.LINK
https://developer.spotify.com/documentation/web-api/reference/#/operations/unfollow-playlist
#>
function Remove-SpotifyPlaylist {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0, ValueFromPipeline, ValueFromPipelineByPropertyName)]
        [Alias("Id")]
        [ValidateNotNullOrEmpty()]
        [string] $PlaylistId
    )
    process {
        $null = Invoke-RestMethod `
            -Uri "https://api.spotify.com/v1/playlists/$($PlaylistId)/followers" `
            -Method Delete `
            -Authentication Bearer `
            -Token $global:SpotifyToken `
            -ContentType "application/json"
    }
}