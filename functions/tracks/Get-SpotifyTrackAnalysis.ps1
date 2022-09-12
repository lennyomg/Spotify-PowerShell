<#
.SYNOPSIS
Get track's audio analysis.

.DESCRIPTION
Get a low-level audio analysis for a track in the Spotify catalog. The audio analysis describes the track’s structure and musical content, including rhythm, pitch, and timbre.

.PARAMETER TrackId
The Spotify ID for the track. Example value: "11dFghVXANMlKmJXsNCbNl".

.EXAMPLE
Get-SpotifyTrackAnalysis -TrackId "11dFghVXANMlKmJXsNCbNl"

.FUNCTIONALITY
Track

.LINK
https://developer.spotify.com/documentation/web-api/reference/#/operations/get-audio-analysis
#>
function Get-SpotifyTrackAnalysis {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
        [Alias("id")]
        [ValidateNotNullOrEmpty()]
        [string] $TrackId
    )
    process {
        Invoke-RestMethod `
            -Uri "https://api.spotify.com/v1/audio-analysis/$($TrackId)" `
            -Method Get `
            -Authentication Bearer `
            -Token $global:SpotifyToken `
            -ContentType "application/json"
    }
}
