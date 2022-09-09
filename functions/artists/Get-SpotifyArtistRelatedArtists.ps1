<#
.SYNOPSIS
Get artist's related artists.

.DESCRIPTION 
Get Spotify catalog information about artists similar to a given artist.

.PARAMETER ArtistId
The Spotify ID of the artist. Example value: "0TnOYISbd1XYRBk9myaseg".

.EXAMPLE
Get-SpotifyArtistRelatedArtists "0TnOYISbd1XYRBk9myaseg"

.LINK
https://developer.spotify.com/documentation/web-api/reference/#/operations/get-an-artists-related-artists
#>
function Get-SpotifyArtistRelatedArtists {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
        [Alias("id")] 
        [ValidateNotNullOrEmpty()]
        [string] $ArtistId
    )
    process {
        Invoke-RestMethod `
            -Uri "https://api.spotify.com/v1/artists/$($ArtistId)/related-artists" `
            -Method Get `
            -Authentication Bearer `
            -Token $global:SpotifyToken `
            -ContentType "application/json" | Select-Object -ExpandProperty artists
    }
}