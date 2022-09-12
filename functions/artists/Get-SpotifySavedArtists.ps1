<#
.SYNOPSIS
Get followed artists.

.DESCRIPTION
Get the current user's followed artists.

.EXAMPLE 
Get-SpotifySavedArtists

.EXAMPLE
Get-SpotifySavedArtists 
| Get-SpotifyArtistTopTracks 
| Sort-Object { Get-Random } 
| Add-SpotifyPlaylistTracks "56twaZEs2xHEr1kL5AXpIL"

.FUNCTIONALITY
Artist

.LINK
https://developer.spotify.com/documentation/web-api/reference/#/operations/get-followed
#>
function Get-SpotifySavedArtists {
    
    $r = [pscustomobject]@{ next = "https://api.spotify.com/v1/me/following?type=artist&limit=50" }
    & { while ($r.next) {
            $r = Invoke-RestMethod `
                -Uri $r.next `
                -Method Get `
                -Authentication Bearer `
                -Token $global:SpotifyToken `
                -ContentType "application/json" | Select-Object -ExpandProperty artists; $r 
        } 
    } | Select-Object -ExpandProperty items
}