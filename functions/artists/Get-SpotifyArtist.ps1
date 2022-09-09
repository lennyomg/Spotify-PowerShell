<#
.SYNOPSIS
Get artist.

.DESCRIPTION 
Get Spotify catalog information for a single artist identified by their unique Spotify ID.

.PARAMETER ArtistId
The Spotify ID of the artist. Example value: "0TnOYISbd1XYRBk9myaseg".

.EXAMPLE
Get-SpotifyArtist "0TnOYISbd1XYRBk9myaseg"

.EXAMPLE
"2CIMQHirSU0MQqyYHq0eOx", "57dN52uHvrHOxijzpIgu3E", "1vCWHaC5f2uS3yhpwWbIA6" | Get-SpotifyArtist

.LINK
https://developer.spotify.com/documentation/web-api/reference/#/operations/get-an-artist
#>
function Get-SpotifyArtist {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
        [Alias("id")] 
        [ValidateNotNullOrEmpty()]
        [string] $ArtistId
    )
    process {
        Invoke-RestMethod `
            -Uri "https://api.spotify.com/v1/artists/$($ArtistId)" `
            -Method Get `
            -Authentication Bearer `
            -Token $global:SpotifyToken `
            -ContentType "application/json"
    }
}