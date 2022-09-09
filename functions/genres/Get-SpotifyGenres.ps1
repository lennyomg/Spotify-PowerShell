<#
.SYNOPSIS
Get Available genre seeds.

.DESCRIPTION
Retrieve a list of available genres seed parameter values for recommendations.

.EXAMPLE
Get-SpotifyGenres

.LINK
https://developer.spotify.com/documentation/web-api/reference/#/operations/get-recommendation-genres
#>
function Get-SpotifyGenres {
    Invoke-RestMethod `
        -Uri "https://api.spotify.com/v1/recommendations/available-genre-seeds" `
        -Method Get `
        -Authentication Bearer `
        -Token $global:SpotifyToken `
        -ContentType "application/json" | Select-Object -ExpandProperty genres
}