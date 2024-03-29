<#
.SYNOPSIS
Get new releases.

.DESCRIPTION
Get a list of new album releases featured in Spotify (shown, for example, on a Spotify player’s “Browse” tab).

.EXAMPLE
Get-SpotifyNewReleases

.EXAMPLE
Get-SpotifyNewReleases | Get-SpotifyAlbumTracks

.FUNCTIONALITY
Album

.LINK
https://developer.spotify.com/documentation/web-api/reference/#/operations/get-new-releases
#>
function Get-SpotifyNewReleases {
   
    $r = [pscustomobject]@{ next = "https://api.spotify.com/v1/browse/new-releases?limit=50" }
    & { while ($r.next -and !$e) {
            $r = Invoke-RestMethod `
                -Uri $r.next `
                -Method Get `
                -Authentication Bearer `
                -Token $global:SpotifyToken `
                -ContentType "application/json" `
                -ErrorVariable "e" | Select-Object -ExpandProperty albums; $r 
        } 
    } 
    | Select-Object -ExpandProperty items
    | ForEach-Object { 
        @() + $_ + $_.artists | ForEach-Object { $_.PSObject.TypeNames.Add("spfy.$($_.type)") }; $_
    }
}