<#
.SYNOPSIS
Get user's saved tracks.

.DESCRIPTION
Get a list of the songs saved in the current Spotify user's 'Your Music' library.

.EXAMPLE
Get-SpotifySavedTracks

.FUNCTIONALITY
Track

.LINK
https://developer.spotify.com/documentation/web-api/reference/#/operations/get-users-saved-tracks
#>
function Get-SpotifySavedTracks {
    
    $r = [pscustomobject]@{ next = "https://api.spotify.com/v1/me/tracks?limit=50" }
    & { while ($r.next -and !$e) {
            $r = Invoke-RestMethod `
                -Uri $r.next `
                -Method Get `
                -Authentication Bearer `
                -Token $global:SpotifyToken `
                -ContentType "application/json" `
                -ErrorVariable "e"; $r 
        } 
    } 
    | Select-Object -ExpandProperty items
    | Select-Object -ExpandProperty track -Property * -ExcludeProperty track
}