<#
.SYNOPSIS
Get artist's albums.

.DESCRIPTION
Get Spotify catalog information about an artist's albums.

.PARAMETER ArtistId
The Spotify ID of the artist. Example value: "0TnOYISbd1XYRBk9myaseg".

.EXAMPLE
Get-SpotifyArtistAlbums "0TnOYISbd1XYRBk9myaseg"

.EXAMPLE
Get-SpotifySavedArtists | Get-SpotifyArtistAlbums

.LINK
https://developer.spotify.com/documentation/web-api/reference/#/operations/get-an-artists-albums
#>
function Get-SpotifyArtistAlbums {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
        [Alias("id")]
        [ValidateNotNullOrEmpty()]
        [string] $ArtistId
    )

    process {
        $r = [pscustomobject]@{ next = "https://api.spotify.com/v1/artists/$($ArtistId)/albums?limit=50" }
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