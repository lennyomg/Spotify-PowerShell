<#
.SYNOPSIS
Save albums.

.DESCRIPTION
Save one or more albums to the current user's 'Your Music' library.

.PARAMETER AlbumId
Album ID. A maximum of 50 IDs can be sent in one request.

.EXAMPLE
Add-SpotifyAlbum -ArtistId "2CIMQHirSU0MQqyYHq0eOx"

.EXAMPLE
Add-SpotifyAlbum "2CIMQHirSU0MQqyYHq0eOx", "1vCWHaC5f2uS3yhpwWbIA6"

.EXAMPLE
"2CIMQHirSU0MQqyYHq0eOx", 57dN52uHvrHOxijzpIgu3E", "1vCWHaC5f2uS3yhpwWbIA6" | Add-SpotifyArtist

.EXAMPLE
Get-SpotifyPlaylistTracks "3cEYpjA9oz9GiPac4AsH4n" | ForEach-Object { $_.track.album } | Add-SpotifyAlbum

.LINK
https://developer.spotify.com/documentation/web-api/reference/#/operations/save-albums-user
#>
function Add-SpotifyAlbum {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
        [Alias("id")]
        [ValidateNotNullOrEmpty()]
        [ValidateCount(1, 50)]
        [string[]] $AlbumId
    )
    
    process {
        $null = Invoke-RestMethod `
            -Uri "https://api.spotify.com/v1/me/albums" `
            -Method Put `
            -Authentication Bearer `
            -Token $global:SpotifyToken `
            -ContentType "application/json" `
            -Body ([PSCustomObject]@{ ids = $AlbumId } | ConvertTo-Json)
    }
}