<#
.SYNOPSIS
Get user's top artists.

.DESCRIPTION
Get the current user's top artists based on calculated affinity.

.PARAMETER Term
Over what time frame the affinities are computed. Valid values: long_term (calculated from several years of data and including all new data as it becomes available), medium_term (approximately last 6 months), short_term (approximately last 4 weeks).

.EXAMPLE
Get-SpotifyUserTopArtists

.EXAMPLE
Get-SpotifyUserTopArtists long_term

.LINK
https://developer.spotify.com/documentation/web-api/reference/#/operations/get-users-top-artists-and-tracks
#>
function Get-SpotifyUserTopArtists {
    param (
        [Parameter(Position = 0)]
        [ValidateSet("short_term", "medium_term", "long_term")]
        [string] $Term = "medium_term"
    )

    $r = [pscustomobject]@{ next = "https://api.spotify.com/v1/me/top/artists?time_range=$Term&limit=50" }
    & { while ($r.next) {
            $r = Invoke-RestMethod `
                -Uri $r.next `
                -Method Get `
                -Authentication Bearer `
                -Token $global:SpotifyToken `
                -ContentType "application/json"; $r 
            break
        }
    } | Select-Object -ExpandProperty items
}
