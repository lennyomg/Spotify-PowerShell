<#
.SYNOPSIS
Get the user's queue.

.DESCRIPTION
Get the list of objects that make up the user's queue.

.FUNCTIONALITY
Player

.LINK
https://developer.spotify.com/documentation/web-api/reference/#/operations/get-queue
#>
function Get-SpotifyQueue {
    Invoke-RestMethod `
        -Uri "https://api.spotify.com/v1/me/player/queue" `
        -Method Get `
        -Authentication Bearer `
        -Token $global:SpotifyToken `
        -ContentType "application/json"
    | Select-Object -ExpandProperty queue
    | ForEach-Object { 
        @() + $_ + $_.artists + $_.album + $_.album.artists 
        | ForEach-Object { $_.PSObject.TypeNames.Add("spfy.$($_.type)") }; $_
    }
}