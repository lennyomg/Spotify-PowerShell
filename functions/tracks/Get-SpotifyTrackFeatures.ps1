<#
.SYNOPSIS
Get track's audio features.

.DESCRIPTION
Get audio feature information for a single track identified by its unique Spotify ID.

.PARAMETER TrackId
The Spotify ID for the track. Example value: "11dFghVXANMlKmJXsNCbNl".

.EXAMPLE
Get-SpotifyTrackFeatures -TrackId "11dFghVXANMlKmJXsNCbNl"

.FUNCTIONALITY
Track

.LINK
https://developer.spotify.com/documentation/web-api/reference/#/operations/get-audio-features
#>
function Get-SpotifyTrackFeatures {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
        [Alias("id")]
        [ValidateNotNullOrEmpty()]
        [string] $TrackId
    )
    process {
        Invoke-RestMethod `
            -Uri "https://api.spotify.com/v1/audio-features/$($TrackId)" `
            -Method Get `
            -Authentication Bearer `
            -Token $global:SpotifyToken `
            -ContentType "application/json"
    }
}
