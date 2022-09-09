<#
.SYNOPSIS
Get current user's playlists.

.DESCRIPTION
Get a list of the playlists owned or followed by the current Spotify user.

.EXAMPLE
Get-SpotifySavedPlaylists

.LINK
https://developer.spotify.com/documentation/web-api/reference/#/operations/get-a-list-of-current-users-playlists
#>
function Get-SpotifySavedPlaylists {
    
    $r = [pscustomobject]@{ next = "https://api.spotify.com/v1/me/playlists?limit=50" }
    & { while ($r.next) {
            $r = Invoke-RestMethod `
                -Uri $r.next `
                -Method Get `
                -Authentication Bearer `
                -Token $global:SpotifyToken `
                -ContentType "application/json"; $r 
        } 
    } | Select-Object -ExpandProperty items
}