<#
.SYNOPSIS
Get saved albums.

.DESCRIPTION
Get a list of the albums saved in the current Spotify user's 'Your Music' library.

.EXAMPLE
Get-SpotifySavedAlbums

.EXAMPLE
Get-SpotifySavedAlbums | ForEach-Object { $_.album } | Get-SpotifyAlbumTracks

.LINK
https://developer.spotify.com/documentation/web-api/reference/#/operations/get-users-saved-albums
#>
function Get-SpotifySavedAlbums {
    
    $r = [pscustomobject]@{ next = "https://api.spotify.com/v1/me/albums?limit=50" }
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