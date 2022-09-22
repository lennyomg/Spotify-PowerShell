<#
.SYNOPSIS
Get current user's playlists.

.DESCRIPTION
Get a list of the playlists owned or followed by the current Spotify user.

.EXAMPLE
Get-SpotifySavedPlaylists

.FUNCTIONALITY
Playlist

.LINK
https://developer.spotify.com/documentation/web-api/reference/#/operations/get-a-list-of-current-users-playlists
#>
function Get-SpotifySavedPlaylists {
    
    $r = [pscustomobject]@{ next = "https://api.spotify.com/v1/me/playlists?limit=50" }
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
    | ForEach-Object { $_.PSObject.TypeNames.Add("spfy.$($_.type)"); $_ }
}