<#
.SYNOPSIS
Follow artists.

.DESCRIPTION
Add the current user as a follower of one or more artists.

.PARAMETER ArtistId
Artist ID. A maximum of 50 IDs can be sent in one request.

.EXAMPLE
Add-SpotifyArtist -ArtistId "2CIMQHirSU0MQqyYHq0eOx"

.EXAMPLE
"2CIMQHirSU0MQqyYHq0eOx", "57dN52uHvrHOxijzpIgu3E", "1vCWHaC5f2uS3yhpwWbIA6" | Add-SpotifyArtist

.FUNCTIONALITY
Artist

.LINK
https://developer.spotify.com/documentation/web-api/reference/#/operations/unfollow-artists-users
#>
function Add-SpotifyArtist {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory, ValueFromPipeline, ValueFromPipelineByPropertyName, Position = 0)]
        [Alias("id")]
        [ValidateNotNullOrEmpty()]
        [ValidateCount(1, 50)]
        [string[]] $ArtistId
    )
    
    process {
        $null = Invoke-RestMethod `
            -Uri "https://api.spotify.com/v1/me/following?type=artist" `
            -Method Put `
            -Authentication Bearer `
            -Token $global:SpotifyToken `
            -ContentType "application/json" `
            -Body ([PSCustomObject]@{ ids = $ArtistId } | ConvertTo-Json)
    }
}