<#
.SYNOPSIS
Get one or several tracks.

.DESCRIPTION 
Get Spotify catalog information for multiple tracks based on their Spotify IDs. 

.PARAMETER TrackId
A list of the Spotify IDs. Can be more than 50. Example value: "11dFghVXANMlKmJXsNCbNl".

.EXAMPLE
Get-SpotifyTrack -TrackId "11dFghVXANMlKmJXsNCbNl"

.EXAMPLE
Get-SpotifyTrack 11dFghVXANMlKmJXsNCbNl, 3WM935x8fQpvSskUP1LHPB

.EXAMPLE
"11dFghVXANMlKmJXsNCbNl", "3WM935x8fQpvSskUP1LHPB" | Get-SpotifyTrack

.FUNCTIONALITY
Track

.LINK
https://developer.spotify.com/documentation/web-api/reference/get-several-tracks
#>
function Get-SpotifyTrack {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
        [Alias("id")]
        [ValidateNotNullOrEmpty()]
        [string[]] $TrackId
    )
    begin {
        $pipe = @()

        function Invoke {
            Invoke-RestMethod `
                -Uri "https://api.spotify.com/v1/tracks?ids=$($pipe -join ',')" `
                -Method Get `
                -Authentication Bearer `
                -Token $global:SpotifyToken `
                -ContentType "application/json"
            | Select-Object -ExpandProperty tracks
            | ForEach-Object { 
                @() + $_ + $_.artists + $_.album + $_.album.artists 
                | ForEach-Object { $_.PSObject.TypeNames.Add("spfy.$($_.type)") }; $_ }
        }
    }
    process {
        $pipe += $TrackId
        if ($pipe.Length -ge 50) {
            Invoke
            $pipe = @()
        }
    }
    end {
        if ($pipe) {
            Invoke
        }
    }
}