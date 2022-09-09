<#
.SYNOPSIS
Get recently played tracks.

.DESCRIPTION
Get tracks from the current user's recently played tracks. Note: Currently doesn't support podcast episodes.

.EXAMPLE
Get-SpotifyRecentlyPlayed

.LINK
https://developer.spotify.com/documentation/web-api/reference/#/operations/get-recently-played
#>
function Get-SpotifyRecentlyPlayed {
    
    $r = [pscustomobject]@{ next = "https://api.spotify.com/v1/me/player/recently-played?limit=50" }
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