<#
.SYNOPSIS
Get available markets.

.DESCRIPTION
Get the list of markets where Spotify is available.

.EXAMPLE
Get-SpotifyMarkets

.FUNCTIONALITY
Market

.LINK
https://developer.spotify.com/documentation/web-api/reference/#/operations/get-available-markets
#>
function Get-SpotifyMarkets {
    Invoke-RestMethod `
        -Uri "https://api.spotify.com/v1/markets" `
        -Method Get `
        -Authentication Bearer `
        -Token $global:SpotifyToken `
        -ContentType "application/json" | Select-Object -ExpandProperty markets
}