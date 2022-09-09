<#
.SYNOPSIS
Search for item.

.DESCRIPTION
Get Spotify catalog information about albums, artists, playlists, tracks, shows or episodes that match a keyword string.

.PARAMETER Query
Your search query. You can narrow down your search using field filters.
The available filters are album, artist, track, year, upc, tag:hipster, tag:new, isrc, and genre.
Each field filter only applies to certain result types.
The artist and year filters can be used while searching albums, artists and tracks.
You can filter on a single year or a range (e.g. 1955-1960).
The album filter can be used while searching albums and tracks.
The genre filter can be used while searching artists and tracks.
The isrc and track filters can be used while searching tracks.
The upc, tag:new and tag:hipster filters can only be used while searching albums.
The tag:new filter will return albums released in the past two weeks and tag:hipster can be used to return only albums with the lowest 10% popularity.
Example value: "remaster track:Doxy artist:Miles Davis".

.PARAMETER Type
A comma-separated list of item types to search across. Search results include hits from all the specified item types. 
Allowed values: "album", "artist", "playlist", "track", "show", "episode". Example value: "track artist"

.EXAMPLE
Find-SpotifyItem "remaster track:Doxy artist:Miles Davis"

.EXAMPLE
Find-SpotifyItem -Query "rock" -Type playlist, track

.LINK
https://developer.spotify.com/documentation/web-api/reference/#/operations/search
#>
function Find-SpotifyItem {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, Position = 0)]
        [ValidateNotNullOrEmpty()]
        [string] $Query,

        [Parameter()]
        [ValidateSet("album", "artist", "playlist", "track", "show", "episode")]
        [ValidateNotNullOrEmpty()]
        [ValidateCount(1, 6)]
        [string[]] $Type = @("album", "artist", "playlist", "track")
    )
    $r = Invoke-RestMethod `
        -Uri "https://api.spotify.com/v1/search?q=$([System.Web.HTTPUtility]::UrlEncode($Query))&type=$($Type -join ',')&limit=50" `
        -Method Get `
        -Authentication Bearer `
        -Token $global:SpotifyToken `
        -ContentType "application/json"

    if ($r.playlists.items) {
        $r.playlists.items
    }

    if ($r.albums.items) {
        $r.albums.items
    }

    if ($r.tracks.items) {
        $r.tracks.items
    }

    if ($r.artists.items) {
        $r.artists.items
    }

    if ($r.shows.items) {
        $r.shows.items
    }

    if ($r.episodes.items) {
        $r.episodes.items
    }
}