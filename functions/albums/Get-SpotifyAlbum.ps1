<#
.SYNOPSIS
Get album.

.DESCRIPTION 
Get Spotify catalog information for a single album.

.PARAMETER AlbumId
The Spotify ID of the album. Example value: "4aawyAB9vmqN3uQ7FjRGTy".

.EXAMPLE
Get-SpotifyAlbum -AlbumId "4aawyAB9vmqN3uQ7FjRGTy"

.LINK
https://developer.spotify.com/documentation/web-api/reference/#/operations/get-an-album
#>
function Get-SpotifyAlbum {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
        [Alias("id")]
        [ValidateNotNullOrEmpty()]
        [string] $AlbumId
    )
    process {
        Invoke-RestMethod `
            -Uri "https://api.spotify.com/v1/albums/$($AlbumId)" `
            -Method Get `
            -Authentication Bearer `
            -Token $global:SpotifyToken `
            -ContentType "application/json"
    }
}