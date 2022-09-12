<#
.SYNOPSIS
Get recommendations.

.DESCRIPTION
Recommendations are generated based on the available information for a given seed entity and matched against similar artists and tracks. 
If there is sufficient information about the provided seeds, a list of tracks will be returned together with pool size details.
For artists and tracks that are very new or obscure there might not be enough data to generate a list of tracks.

.EXAMPLE
Get-SpotifyRecommendations -SeedArtists "2CIMQHirSU0MQqyYHq0eOx", "57dN52uHvrHOxijzpIgu3E" -MinEnergy 0.8 -MaxEnergy 1 -TargetDanceability 1

.FUNCTIONALITY
Track

.LINK
https://developer.spotify.com/documentation/web-api/reference/#/operations/get-recommendations
#>
function Get-SpotifyRecommendations {
    [CmdletBinding(PositionalBinding = $false)]
    param (

        # A list of Spotify IDs for seed artists. Up to 5 seed values may be provided in any combination of seed_artists, seed_tracks and seed_genres. Example value: "4NHQUGzhtTLFvgF5SZesLK".
        [Parameter()]
        [ValidateCount(0, 5)]
        [Alias("seed_artists")]
        [string[]] $SeedArtists,
        
        # A list of any genres in the set of available genre seeds. Up to 5 seed values may be provided in any combination of seed_artists, seed_tracks and seed_genres. Example value: "classical,country".
        [Parameter()]
        [ValidateCount(0, 5)]
        [Alias("seed_genres")]
        [string[]] $SeedGenres,

        # A list of Spotify IDs for a seed track. Up to 5 seed values may be provided in any combination of seed_artists, seed_tracks and seed_genres. Example value: "0c6xIDDpzE81m2q797ordA".
        [Parameter()]
        [ValidateCount(0, 5)]
        [Alias("seed_tracks")]
        [string[]] $SeedTracks,

        # Double 0..1
        [Parameter()]
        [Alias("max_acousticness")]
        [double] $MaxAcousticness,

        # Double 0..1
        [Parameter()]
        [Alias("max_danceability")]
        [double] $MaxDanceability,

        # Integer
        [Parameter()]
        [Alias("max_duration_ms")]
        [int] $MaxDurationMs,

        # Double 0..1
        [Parameter()]
        [Alias("max_energy")]
        [double] $MaxEnergy,

        # Double 0..1
        [Parameter()]
        [Alias("max_instrumentalness")]
        [double] $MaxInstrumentalness,

        # Integer 0..11
        [Parameter()]
        [Alias("max_key")]
        [int] $MaxKey,

        # Double 0..1
        [Parameter()]
        [Alias("max_liveness")]
        [double] $MaxLiveness,

        # Double
        [Parameter()]
        [Alias("max_loudness")]
        [double] $MaxLoudness,

        # Integer 0..1
        [Parameter()]
        [Alias("max_mode")]
        [int] $MaxMode,

        # Integer 0..100
        [Parameter()]
        [Alias("max_popularity")]
        [int] $MaxPopularity,

        # Double 0..1
        [Parameter()]
        [Alias("max_speechiness")]
        [double] $MaxSpeechiness,

        # Double (bpm)
        [Parameter()]
        [Alias("max_tempo")]
        [double] $MaxTempo,

        # Integer
        [Parameter()]
        [Alias("max_time_signature")]
        [int] $MaxTimeSignature,

        # Double 0..1
        [Parameter()]
        [Alias("max_valence")]
        [double] $MaxValence,

        # Double 0..1
        [Parameter()]
        [Alias("min_acousticness")]
        [double] $MinAcousticness,

        # Double 0..1
        [Parameter()]
        [Alias("min_danceability")]
        [double] $MinDanceability,

        # Integer
        [Parameter()]
        [Alias("min_duration_ms")]
        [int] $MinDurationMs,

        # Double 0..1
        [Parameter()]
        [Alias("min_energy")]
        [double] $MinEnergy,

        # Double 0..1
        [Parameter()]
        [Alias("min_instrumentalness")]
        [double] $MinInstrumentalness,

        # Integer 0..11
        [Parameter()]
        [Alias("min_key")]
        [int] $MinKey,

        # Double 0..1
        [Parameter()]
        [Alias("min_liveness")]
        [double] $MinLiveness,

        # Double
        [Parameter()]
        [Alias("min_loudness")]
        [double] $MinLoudness,

        # Double 0..1
        [Parameter()]
        [Alias("min_mode")]
        [int] $MinMode,

        # Integer 0..100
        [Parameter()]
        [Alias("min_popularity")]
        [int] $MinPopularity,

        # Double 0..1
        [Parameter()]
        [Alias("min_speechiness")]
        [double] $MinSpeechiness,

        # Double
        [Parameter()]
        [Alias("min_tempo")]
        [double] $MinTempo,

        # Integer
        [Parameter()]
        [Alias("min_time_signature")]
        [int] $MinTimeSignature,

        # Double 0..1
        [Parameter()]
        [Alias("min_valence")]
        [double] $MinValence,

        # Double 0..1
        [Parameter()]
        [Alias("target_acousticness")]
        [double] $TargetAcousticness,
 
        # Double 0..1
        [Parameter()]
        [Alias("target_danceability")]
        [double] $TargetDanceability,

        # Integer
        [Parameter()]
        [Alias("target_duration_ms")]
        [int] $TargetDurationMs,

        # Double 0..1
        [Parameter()]
        [Alias("target_energy")]
        [double] $TargetEnergy,

        # Double 0..1
        [Parameter()]
        [Alias("target_instrumentalness")]
        [double] $TargetInstrumentalness,

        # Integer 0..11
        [Parameter()]
        [Alias("target_key")]
        [int] $TargetKey,

        # Double 0..1
        [Parameter()]
        [Alias("target_liveness")]
        [double] $TargetLiveness,

        # Double
        [Parameter()]
        [Alias("target_loudness")]
        [double] $TargetLoudness,

        # Integer 0..1
        [Parameter()]
        [Alias("target_mode")]
        [int] $TargetMode,

        # Integer 0..100
        [Parameter()]
        [Alias("target_popularity")]
        [int] $TargetPopularity,

        # Double 0..1
        [Parameter()]
        [Alias("target_speechiness")]
        [double] $TargetSpeechiness,

        # Double (bpm)
        [Parameter()]
        [Alias("target_tempo")]
        [double] $TargetTempo,

        # Integer
        [Parameter()]
        [Alias("target_time_signature")]
        [int] $TargetTimeSignature,

        # Double 0..1
        [Parameter()]
        [Alias("target_valence")]
        [double] $TargetValence
    )

    $e = @{}
    $c = Get-Command Get-SpotifyRecommendations
    foreach ($p in $PSBoundParameters.Keys) {
        $v = $PSBoundParameters[$p]
        $e[$c.Parameters[$p].Aliases[0]] = $v.Count ? $v -join "," : $v
    }
    
    Invoke-RestMethod `
        -Uri "https://api.spotify.com/v1/recommendations?limit=100&$(($e.Keys | ForEach-Object { "$($_)=$($e[$_])" }) -join "&")" `
        -Method Get `
        -Authentication Bearer `
        -Token $global:SpotifyToken `
        -ContentType "application/json"
}