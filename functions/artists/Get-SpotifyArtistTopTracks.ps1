<#
.SYNOPSIS
Get artist's top tracks.

.DESCRIPTION 
Get Spotify catalog information about an artist's top tracks by country.

.PARAMETER ArtistId
The Spotify ID of the artist. Example value: "0TnOYISbd1XYRBk9myaseg".

.PARAMETER Market
An ISO 3166-1 alpha-2 country code. If a country code is specified, only content that is available in that market will be returned. Example value: "ES".

.EXAMPLE
Get-SpotifyArtistTopTracks "0TnOYISbd1XYRBk9myaseg"

.EXAMPLE
Get-SpotifySavedArtists | Get-SpotifyArtistTopTracks

.FUNCTIONALITY
Artist

.LINK
https://developer.spotify.com/documentation/web-api/reference/#/operations/get-an-artists-top-tracks
#>
function Get-SpotifyArtistTopTracks {
    [CmdletBinding(PositionalBinding = $false)]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
        [Alias("id")] 
        [ValidateNotNullOrEmpty()]
        [string] $ArtistId,

        [Parameter()]
        [ValidateNotNullOrEmpty()]
        [string] $Market = "US"
    )
    process {
        Invoke-RestMethod `
            -Uri "https://api.spotify.com/v1/artists/$($ArtistId)/top-tracks?market=$($Market)" `
            -Method Get `
            -Authentication Bearer `
            -Token $global:SpotifyToken `
            -ContentType "application/json" 
        | Select-Object -ExpandProperty tracks
        | ForEach-Object { 
            @() + $_ + $_.artists + $_.album + $_.album.artists 
            | ForEach-Object { $_.PSObject.TypeNames.Add("spfy.$($_.type)") }; $_
        }
    }
}
