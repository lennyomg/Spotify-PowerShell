<#
.SYNOPSIS
Get album tracks.

.DESCRIPTION
Get Spotify catalog information about an album’s tracks. 

.PARAMETER AlbumId
The Spotify ID of the album. Example value: "4aawyAB9vmqN3uQ7FjRGTy".

.EXAMPLE
Get-SpotifyAlbumTracks "4aawyAB9vmqN3uQ7FjRGTy"

.EXAMPLE
Get-SpotifySavedAlbums | Get-SpotifyAlbumTracks

.FUNCTIONALITY
Album

.LINK
https://developer.spotify.com/documentation/web-api/reference/#/operations/get-an-albums-tracks
#>
function Get-SpotifyAlbumTracks {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
        [Alias("id")]
        [ValidateNotNullOrEmpty()]
        [string] $AlbumId
    )

    process {
        $r = [pscustomobject]@{ next = "https://api.spotify.com/v1/albums/$($AlbumId)/tracks?limit=50" }
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
        | ForEach-Object { 
            @() + $_ + $_.artists 
            | ForEach-Object { $_.PSObject.TypeNames.Add("spfy.$($_.type)") }; $_
        }
    }
}