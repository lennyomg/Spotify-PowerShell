<#
.SYNOPSIS
Get current user's profile.

.DESCRIPTION
Get detailed profile information about the current user (including the current user's username).

.EXAMPLE
Get-SpotifyUser

.LINK
https://developer.spotify.com/documentation/web-api/reference/#/operations/get-current-users-profile
#>
function Get-SpotifyUser {
    Invoke-RestMethod `
        -Uri "https://api.spotify.com/v1/me" `
        -Method Get `
        -Authentication Bearer `
        -Token $global:SpotifyToken `
        -ContentType "application/json" 
}