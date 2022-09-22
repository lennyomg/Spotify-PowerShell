<#
.SYNOPSIS
Get track.

.DESCRIPTION 
Get Spotify catalog information for a single track identified by its unique Spotify ID.

.PARAMETER TrackId
The Spotify ID for the track. Example value: "11dFghVXANMlKmJXsNCbNl".

.EXAMPLE
Get-SpotifyTrack -TrackId "11dFghVXANMlKmJXsNCbNl"

.FUNCTIONALITY
Track

.LINK
https://developer.spotify.com/documentation/web-api/reference/#/operations/get-track
#>
function Get-SpotifyTrack {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
        [Alias("id")]
        [ValidateNotNullOrEmpty()]
        [string] $TrackId
    )
    process {
        Invoke-RestMethod `
            -Uri "https://api.spotify.com/v1/tracks/$($TrackId)" `
            -Method Get `
            -Authentication Bearer `
            -Token $global:SpotifyToken `
            -ContentType "application/json"
        | ForEach-Object { 
            @() + $_ + $_.artists + $_.album + $_.album.artists 
            | ForEach-Object { $_.PSObject.TypeNames.Add("spfy.$($_.type)") }; $_
        }
    }
}
